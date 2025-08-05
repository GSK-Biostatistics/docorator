test_that("add footnotes and headers",{
  my_gt <- gt::exibble |>
    gt::gt(
      rowname_col = "row",
      groupname_col = "group"
    )


  docorator <- as_docorator(
    x = my_gt,
    header = fancyhead(
      fancyrow(center = "first line header"),
      fancyrow(left = "left header"),
      fancyrow(center = "second line header"),
      fancyrow(center = "third line header")
    ),
    footer = fancyfoot(
      fancyrow(left = "footnote 1"),
      fancyrow(left = "footnote 2"),
      fancyrow(right = "timestamp")),
    display_name = "my_first_gt",
    save_object = FALSE

  )

  head_foot_gt <- hf_to_gt(docorator)

  # footnote
  expect_equal(unlist(head_foot_gt$`_footnotes`$footnotes),c("footnote 1", "footnote 2"))
  # title
  expect_equal(head_foot_gt$`_heading`$title, "first line header")
  # subtitle
  expect_equal(head_foot_gt$`_heading`$subtitle, gt::md("second line header<br>third line header"))

})

test_that("add footnotes and headers - gt_group",{
  # create docorator object
  gt_group  <- gt::gt_group(gt::gt(head(mtcars)), gt::gt(tail(mtcars)))


  docorator <- as_docorator(
    x = gt_group,
    header = fancyhead(
      fancyrow(center = "first line header"),
      fancyrow(left = "left header"),
      fancyrow(center = "second line header"),
      fancyrow(center = "third line header")
    ),
    footer = fancyfoot(
      fancyrow(left = "footnote 1"),
      fancyrow(left = "footnote 2"),
      fancyrow(right = "timestamp")),
    display_name = "my_first_gt",
    save_object = FALSE

  )

  head_foot_gt_group <- hf_to_gt(docorator)

  # separate out the two tables
  tab1 <- gt::grp_pull(head_foot_gt_group,1)
  tab2 <- gt::grp_pull(head_foot_gt_group,2)

  # footnote
  expect_equal(unlist(tab1$`_footnotes`$footnotes),c("footnote 1", "footnote 2"))
  # title
  expect_equal(tab1$`_heading`$title, "first line header")
  # subtitle
  expect_equal(tab1$`_heading`$subtitle, gt::md("second line header<br>third line header"))

  # footnote
  expect_equal(unlist(tab2$`_footnotes`$footnotes),c("footnote 1", "footnote 2"))
  # title
  expect_equal(tab2$`_heading`$title, "first line header")
  # subtitle
  expect_equal(tab2$`_heading`$subtitle, gt::md("second line header<br>third line header"))


})

test_that("add footnotes and headers - existing group info",{
  # create docorator object
  my_gt <- gt::exibble |>
    gt::gt(
      rowname_col = "row",
      groupname_col = "group"
    ) |>
    gt::tab_header(title = "",subtitle = "TRT = Placebo, <br>X = Y")



  docorator <- as_docorator(
    x = my_gt,
    header = fancyhead(
      fancyrow(center = "first line header"),
      fancyrow(left = "left header"),
      fancyrow(center = "second line header"),
      fancyrow(center = "third line header")
    ),
    footer = fancyfoot(
      fancyrow(left = "footnote 1"),
      fancyrow(left = "footnote 2"),
      fancyrow(right = "timestamp")),
    display_name = "my_first_gt",
    save_object = FALSE

  )

  head_foot_gt <- hf_to_gt(docorator)

  # subtitle
  expect_equal(head_foot_gt$`_heading`$subtitle, gt::md("second line header<br>third line header<br>TRT = Placebo, <br>X = Y"))

  # no additional subtitles
  docorator2 <- as_docorator(
    x = my_gt,
    display_name = "my_first_gt",
    save_object = FALSE
  )

  head_foot_gt2 <- hf_to_gt(docorator2)

  # subtitle
  expect_equal(head_foot_gt2$`_heading`$subtitle, gt::md("TRT = Placebo, <br>X = Y"))

})


test_that("no footnotes or headers",{
  my_gt <- gt::exibble |>
    gt::gt(
      rowname_col = "row",
      groupname_col = "group"
    )


  docorator <- as_docorator(
    x = my_gt,
    footer = NULL,
    display_loc ="test",
    display_name = "my_first_gt",
    save_object = FALSE

  )

  head_foot_gt <- hf_to_gt(docorator)

  # footnote
  expect_equal(unlist(head_foot_gt$`_footnotes`$footnotes),NULL)
  # title
  expect_equal(head_foot_gt$`_heading`$title, NULL)
  # subtitle
  expect_equal(head_foot_gt$`_heading`$subtitle, NULL)


  # no subtitle but title
  docorator2 <- as_docorator(
    x = my_gt,
    header = fancyhead(
      fancyrow(center = "first line header")
    ),
    footer = NULL,
    display_loc ="test",
    display_name = "my_first_gt",
    save_object = FALSE

  )

  head_foot_gt2 <- hf_to_gt(docorator2)

  # footnote
  expect_equal(unlist(head_foot_gt2$`_footnotes`$footnotes),NULL)
  # title
  expect_equal(head_foot_gt2$`_heading`$title, "first line header")
  # subtitle
  expect_equal(head_foot_gt2$`_heading`$subtitle, NULL)
})

test_that("apply_to_grp works",{
  # create gt group example
  gt_tbl <- gt::exibble %>% gt::gt()
  gt_group <- gt::gt_group(gt_tbl, gt_tbl)

  # bad object
  arg_list <- list(data = mtcars)
  expect_error(apply_to_grp(gt::tab_options, arg_list), 'First arg must be a gt_tbl or gt_group object, not a data frame')

  # create arguments - cols_align function
  gt_group <- gt::gt_group(gt_tbl, gt_tbl)
  func <- gt::tab_options
  arg_list_group <- list(data = gt_group, page.header.use_tbl_headings = c(TRUE))
  arg_list_tbl <- list(data = gt_tbl, page.header.use_tbl_headings = c(TRUE))

  # aligned gt_tbl
  options_tbl <- gt_tbl %>%
    gt::tab_options(
      page.header.use_tbl_headings = TRUE
    )

  # aligned group 2 ways: one via apply_to_group one via individual aligned tables
  options_group <- apply_to_grp(func,arg_list_group)
  expect_identical(options_group, gt::gt_group(options_tbl, options_tbl))

  # check apply_to_grp works for gt_tbl
  expect_identical(options_tbl, apply_to_grp(func, arg_list_tbl))
})
