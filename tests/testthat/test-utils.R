test_that("create PNG object",{
  png_obj <- png_path(path = system.file("extdata/test_image.png", package = "docorator"))

  expect_equal(class(png_obj), "PNG")
})

test_that("markdown chunks are created correctly",{

  skip_if_not(interactive())

  png_obj <- png_path(path = system.file("extdata/test_image.png", package = "docorator"))
  docorator <- as_docorator(png_obj, display_name = "myfig", save_object = FALSE)
  chunk_png <- create_chunk(x = docorator, transform = NULL) |> capture.output()
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
  docorator <- as_docorator(my_gt, display_name = "mytbl", save_object = FALSE)
  chunk_gt <- create_chunk(x = docorator, transform = NULL) |> capture.output()
  expect_snapshot(chunk_gt)

  my_gt_group <- gt::gt_group(my_gt,my_gt)
  docorator <- as_docorator(my_gt_group, display_name = "mytbl", save_object = FALSE)
  chunk_gt_group <- create_chunk(x = docorator, transform = NULL) |> capture.output()
  expect_snapshot(chunk_gt_group)

})

test_that("package version messages are printed correctly",{

  skip_on_cran()
  skip_on_ci()

  my_gt <- gt::exibble |>
    gt::gt(
      rowname_col = "row",
      groupname_col = "group"
    )

  docorator <- as_docorator(my_gt,
                            display_name = "mytbl",
                            save_object = FALSE)
  current_version <- utils::packageVersion("gt")

  # amend the sessionInfo

  # non-existent gt version
  old_gt <- docorator
  old_gt$session_info$loadedOnly$gt$Version <- "0.0.1234"
  expect_message(check_pkg_version(old_gt), paste0("Note: docorator object was created with gt 0.0.1234. You are now running gt ",current_version,". There may be issues rendering your document."))

  # empty other packages still renders message
  old_gt$session_info$otherPkgs <- NULL
  expect_message(check_pkg_version(old_gt),paste0("Note: docorator object was created with gt 0.0.1234. You are now running ", current_version, ". There may be issues rendering your document."))


})

