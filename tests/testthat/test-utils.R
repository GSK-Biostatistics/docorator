test_that("create PNG object",{
  png_obj <- png_path(path = system.file("extdata/test_image.png", package = "docorator"))

  expect_equal(class(png_obj), "PNG")
})

test_that("markdown chunks are created correctly",{

  skip_on_cran()
  skip_on_ci()

  png_obj <- png_path(path = system.file("extdata/test_image.png", package = "docorator"))
  chunk_png <- create_chunk(x = png_obj, fig_dim = c(5,8), transform = NULL) |> capture.output()
  # avoiding snapshot because of temp directory + mardown header
  expect_true(any(grepl('<div class=\"figure\">', chunk_png)))

  my_gt <- gt::exibble |>
    gt::gt(
      rowname_col = "row",
      groupname_col = "group"
    ) |>
    apply_scale(fontsize = 10,
                tbl_scale = TRUE,
                tbl_stub_pct = 0.5)

  chunk_gt <- create_chunk(x = my_gt, fig_dim = c(5,8), transform = NULL) |> capture.output()
  expect_snapshot(chunk_gt)

  my_gt_group <- gt::gt_group(my_gt,my_gt)
  chunk_gt_group <- create_chunk(x = my_gt_group, fig_dim = c(5,8), transform = NULL) |> capture.output()
  expect_snapshot(chunk_gt_group)

})
