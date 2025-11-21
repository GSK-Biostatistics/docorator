test_that("scale_gt works", {

  # table with 1 stub column
  tbl_1stub <- gt::exibble |>
    gt::gt(
      rowname_col = "row"
    )

  gt_out <- scale_gt(tbl_1stub, tbl_stub_pct = 0.3)$`_boxhead`

  expect_equal(
    dplyr::filter(gt_out, type=="stub")$column_width |> unlist(),
    "30%"
  )
  expect_equal(
    dplyr::filter(gt_out, !type=="stub")$column_width |> unlist(),
    rep("8.75%", ncol(gt::exibble)-1)
  )


  # table with 1 stub column and hidden column
  tbl_1stub_1hidden <- tbl_1stub |>
    gt::cols_hide(
      group
    )

  gt_out <- scale_gt(tbl_1stub_1hidden, tbl_stub_pct = 0.3)$`_boxhead`

  expect_equal(
    dplyr::filter(gt_out, type=="stub")$column_width |> unlist(),
    "30%"
  )
  expect_equal(
    dplyr::filter(gt_out, !type=="stub")$column_width |> unlist(),
    rep("10%", ncol(gt::exibble)-1)
  )

  # table with 2 stub columns
  tbl_2stub <- gt::exibble |>
    gt::gt(
      rowname_col = "row",
      groupname_col = "group"
    ) |>
    gt::tab_options(
      row_group.as_column = TRUE
    )

  gt_out <- scale_gt(tbl_2stub, tbl_stub_pct = 0.3)$`_boxhead`

  expect_equal(
    dplyr::filter(gt_out, type=="stub")$column_width |> unlist(),
    "15%"
  )
  expect_equal(
    dplyr::filter(gt_out, !type=="stub" & var=="group")$column_width |> unlist(),
    "15%"
  )
  expect_equal(
    dplyr::filter(gt_out, !type=="stub" & !var=="group")$column_width |> unlist(),
    rep("10%", ncol(gt::exibble)-2)
  )

  # table with 0 stub columns
  tbl_nostub <- gt::exibble |>
    gt::gt()

  gt_out <- scale_gt(tbl_nostub)$`_boxhead`

  widths <- as.numeric(gsub("%","",gt_out$column_width |> unlist()))
  expect_equal(unique(widths),
               100/ncol(gt::exibble))

  # table with 1 stub column that is a groupname_col (not rowname_col)
  tbl_grp1stub <- gt::exibble |>
    gt::gt(groupname_col = "fctr",
           row_group_as_column = TRUE)

  gt_out <- scale_gt(tbl_grp1stub)$`_boxhead`

  expect_equal(dplyr::filter(gt_out, type=="stub") |> nrow(),
               0)
  expect_equal(
    dplyr::filter(gt_out, type=="row_group")$column_width |> unlist(),
    "30%"
  )
  expect_equal(
    dplyr::filter(gt_out, !type=="row_group")$column_width |> unlist(),
    rep("8.75%", ncol(gt::exibble)-1)
  )

})

test_that("check_gt_widths works",{
  no_widths <- gt::exibble |>
    gt::gt()

  expect_equal(check_gt_widths(no_widths),list(tbl_scale = FALSE, table_width = "100%"))

  large_widths <- no_widths |>
    gt::cols_width(
      num ~ "400.5%",
      char ~ "3%"
    )
  expect_warning(check_gt_widths(large_widths),"Column widths must be add to =<100%, not 403.5%. Applying auto table scaling.")
  expect_equal(suppressWarnings(check_gt_widths(large_widths)),list(tbl_scale = TRUE, table_width = "100%"))

  px_widths <- no_widths |>
    gt::cols_width(
      num ~ "400px",
      char ~ "3%"
    )

  expect_warning(check_gt_widths(px_widths),"Column widths must be specified in % not px. Applying auto table scaling.")
  expect_equal(suppressWarnings(check_gt_widths(px_widths)), list(tbl_scale = TRUE, table_width = "100%"))

  # defaults to px
  px_widths2 <- no_widths |>
    gt::cols_width(
      num ~ 40,
      char ~ 3
    )

  expect_warning(check_gt_widths(px_widths2),"Column widths must be specified in % not px. Applying auto table scaling.")
  expect_equal(suppressWarnings(check_gt_widths(px_widths2)), list(tbl_scale = TRUE, table_width = "100%"))

  # no % specified
  no_pct_widths <- no_widths |>
    gt::cols_width(
      num ~ "40",
      char ~ "3"
    )

  expect_warning(check_gt_widths(no_pct_widths),"Column widths must be specified in %. Applying auto table scaling.")
  expect_equal(suppressWarnings(check_gt_widths(px_widths2)),list(tbl_scale = TRUE, table_width = "100%"))

  good_widths <- no_widths |>
    gt::cols_width(
      num ~ "10%",
      char ~ "10%",
      fctr ~ "10%",
      date ~ "10%",
      time ~ "10%",
      datetime ~ "10%",
      currency ~ "10%",
      row ~ "30%"
    )

  expect_equal(check_gt_widths(good_widths), list(tbl_scale = FALSE, table_width = "100%"))

  # all columns are specified, <100
  small_widths <- no_widths |>
    gt::cols_width(
      num ~ "1%",
      char ~ "1%",
      fctr ~ "1%",
      date ~ "1%",
      time ~ "1%",
      datetime ~ "1%",
      currency ~ "1%",
      row ~ "3%",
      group ~ "2%"
    )

  expect_equal(check_gt_widths(small_widths), list(tbl_scale = FALSE, table_width = NULL))
})

test_that("apply_scale works - gt_tbl",{
  # bad column widths, scale false
  gt_tbl1 <- gt::exibble |>
    gt::gt() |> gt::cols_width(num ~ "400%", char ~ "3%") |>
    gt:: tab_options(table.font.size = "10pt",
                     heading.subtitle.font.size = "10pt",
                     heading.title.font.size = "10pt",
                     table.width = "100%"
    )

  expect_warning(apply_scale(gt_tbl1, fontsize = 10, tbl_scale = FALSE, tbl_stub_pct = 0.3),"Column widths must be add to =<100%, not 403%. Applying auto table scaling.")
  expect_identical(suppressWarnings(apply_scale(gt_tbl1, fontsize = 10, tbl_scale = FALSE, tbl_stub_pct = 0.3)), scale_gt(gt_tbl1, tbl_stub_pct = 0.3))

  # col widths <100
  gt_tbl2 <- gt::exibble |>
    gt::gt() |> gt::cols_width(num ~ "10%", char ~ "3%")

  expect_message(apply_scale(gt_tbl2, fontsize = 10, tbl_scale = FALSE, tbl_stub_pct = 0.3),"NOTE: Column widths total <100%. Resulting table may not respect document margins.")
  expect_identical(suppressMessages(apply_scale(gt_tbl2, fontsize = 10,  tbl_scale = FALSE, tbl_stub_pct = 0.3)), gt_tbl2 |>
                     gt:: tab_options(table.font.size = "10pt",
                                      heading.subtitle.font.size = "10pt",
                                      heading.title.font.size = "10pt",
                                      table.width = "100%"
                     ))

  # col widths =100
  gt_tbl3 <- gt::exibble |>
    dplyr::select(num, char) |>
    gt::gt() |> gt::cols_width(everything() ~ "50%" )


  expect_identical(apply_scale(gt_tbl3, fontsize = 10,  tbl_scale = FALSE, tbl_stub_pct = 0.3), gt_tbl3 |>
                     gt:: tab_options(table.font.size = "10pt",
                                      heading.subtitle.font.size = "10pt",
                                      heading.title.font.size = "10pt"
                     ))

  # scale true
  gt_tbl4 <- gt::exibble |>
    gt::gt() |> gt::cols_width(num ~ "10%", char ~ "3%")

  expect_identical(apply_scale(gt_tbl4, fontsize = 10, tbl_scale = TRUE, tbl_stub_pct = 0.3), scale_gt(gt_tbl4, tbl_stub_pct = 0.3)|>
                     gt:: tab_options(table.font.size = "10pt",
                                      heading.subtitle.font.size ="10pt",
                                      heading.title.font.size = "10pt",
                                      table.width = "100%"
                     ))
})

test_that("check_gt_widths works - hidden columns",{

  hidden_cols <- gt::exibble |>
    gt::gt() |>
    gt::cols_hide(num) |>
    gt::cols_width(
      num ~ "400.5%",
      char ~ "3%"
    )

 # should ignore the 400.5% and total should be <100
  expect_message(check_gt_widths(hidden_cols),"NOTE: Column widths total <100%. Resulting table may not respect document margins.")
  expect_equal(suppressMessages(check_gt_widths(hidden_cols)),list(tbl_scale = FALSE, table_width = "100%"))
})

test_that("apply_scale works - gt_group",{
  gt_tbl <- gt::exibble |>
    gt::gt()|>
    gt:: tab_options(table.font.size = "10pt",
                     heading.subtitle.font.size = "10pt",
                     heading.title.font.size = "10pt",
                     table.width = "100%"
    )

  # one table with bad column widths one is fine
  gt_group1 <- gt::gt_group(gt_tbl |> gt::cols_width(num ~ "400%", char ~ "3%"), gt_tbl)

  # expect first table to be auto rescaled, second table unchanged
  expected_group <- gt::gt_group(scale_gt(gt_tbl, tbl_stub_pct = 0.3), gt_tbl)

  expect_warning(apply_scale(gt_group1, fontsize = 10, tbl_scale = FALSE, tbl_stub_pct = 0.3),"Column widths must be add to =<100%, not 403%. Applying auto table scaling.")
  expect_identical(suppressWarnings(apply_scale(gt_group1, fontsize = 10, tbl_scale = FALSE, tbl_stub_pct = 0.3)), expected_group)

  # tbl_scale = TRUE
  gt_group2 <- gt::gt_group(gt_tbl, gt_tbl)
  expected_group2 <- gt::gt_group(scale_gt(gt_tbl, tbl_stub_pct = 0.3), scale_gt(gt_tbl, tbl_stub_pct = 0.3))

  expect_identical(apply_scale(gt_group2, fontsize = 10, tbl_scale = TRUE, tbl_stub_pct = 0.3), expected_group2)
})
