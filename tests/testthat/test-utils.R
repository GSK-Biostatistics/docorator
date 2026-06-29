test_that("create PNG object",{
  png_obj <- png_path(path = system.file("extdata/test_image.png", package = "docorator"))

  expect_equal(class(png_obj), "PNG")
})

test_that("markdown chunks are created correctly",{

  skip_if_not(interactive())

  png_obj <- png_path(path = system.file("extdata/test_image.png", package = "docorator"))
  docorator <- as_docorator(png_obj, display_name = "myfig", save_object = FALSE)
  chunk_png <- create_chunks_all(x = docorator, transform = NULL) |> capture.output()
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
  chunk_gt <- create_chunks_all(x = docorator, transform = NULL) |> capture.output()
  expect_snapshot(chunk_gt)

  my_gt_group <- gt::gt_group(my_gt,my_gt)
  docorator <- as_docorator(my_gt_group, display_name = "mytbl", save_object = FALSE)
  chunk_gt_group <- create_chunks_all(x = docorator, transform = NULL) |> capture.output()
  expect_snapshot(chunk_gt_group)

  my_gt_group_caption <- gt::gt_group(my_gt |> gt::tab_caption("test"),my_gt |> gt::tab_caption("test"))
  docorator <- as_docorator(my_gt_group_caption, display_name = "mytbl", save_object = FALSE)
  chunk_gt_group_caption <- create_chunks_all(x = docorator, transform = NULL) |> capture.output()
  expect_snapshot(chunk_gt_group_caption)
  expect_true(any(grepl('new_chunk1', chunk_gt_group_caption)))
  expect_true(any(grepl('new_chunk2', chunk_gt_group_caption)))

  # list of ggplot2 - tempdir to stop creation of figure folder
  withr::with_tempdir({

  ggplot1 <- ggplot2::ggplot(data = mtcars, ggplot2::aes(y=cyl, x=mpg)) +
    ggplot2::geom_point() +
    ggplot2::labs(title = "title1", subtitle = "subtitle1", tag = "tag1", caption = "footnote1")
  ggplot2 <- ggplot2::ggplot(data = mtcars, ggplot2::aes(x=cyl, y=mpg)) +
    ggplot2::geom_point() +
    ggplot2::labs(title = "title2", subtitle = "subtitle2", tag = "tag2", caption = "footnote2")

  list_of_ggplots <- list(ggplot1, ggplot2)
  docorator <- as_docorator(list_of_ggplots, display_name = "my_plot_list", save_object = FALSE)
  chunk_list <- create_chunks_all(x = docorator, transform = NULL) |> capture.output()
  expect_true(any(grepl('new_chunk1', chunk_list)))
  expect_true(any(grepl('new_chunk2', chunk_list)))

})

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
  suppressMessages({
    expected_message <- cli::cli_text("Note: docorator object was created with {.pkg gt 0.0.1234}. You are now running {.pkg gt {current_version}}. There may be issues rendering your document.")
    expect_equal( check_pkg_version(old_gt), expected_message)
  })

  # empty other packages still renders message
  old_gt$session_info$otherPkgs <- NULL
  suppressMessages({
    expect_equal( check_pkg_version(old_gt), expected_message)
  })

})

test_that("ggplot2 objects are converted to PNG", {
  ggplot1 <- ggplot2::ggplot(data = mtcars, ggplot2::aes(y = cyl, x = mpg)) +
    ggplot2::geom_point() +
    ggplot2::labs(
      title = "title1",
      subtitle = "subtitle1",
      tag = "tag1",
      caption = "footnote1"
    )

  docorator <- as_docorator(
    ggplot1,
    display_name = "my_plot",
    save_object = FALSE
  )

  # check that the display is a PNG object
  expect_equal(class(docorator$display), "PNG")
})
test_that("convert_list_displays works", {
  gt_tbl <- gt::exibble |> gt::gt()
  gt_tbl2 <- gt::exibble |>
    dplyr::slice_head(n = 5) |>
    gt::gt() |>
    gt::tab_header(title = "title2")
  gt_group <- gt::gt_group(gt_tbl, gt_tbl2)

  gt_list <- convert_list_displays(gt_group)

  expect_equal(class(gt_list), "list")
  expect_equal(length(gt_list), 2)
  expect_true(inherits(gt_list[[1]], "gt_tbl"))
  expect_true(inherits(gt_list[[2]], "gt_tbl"))

  # display is not a gt_group stays the same

  no_list <- convert_list_displays(gt_tbl)
  expect_equal(no_list, gt_tbl)

  # list with gt_groups gets flattened to list with gt_tbls
  plot <- ggplot2::ggplot(mtcars) +
    ggplot2::aes(x = disp, y = mpg) +
    ggplot2::geom_point()
  list <- list(plot, gt_group, gt_tbl2)

  list_flattened <- convert_list_displays(list)

  expect_equal(class(list_flattened), "list")
  # should have 3 gt_tbls and 1 ggplot
  expect_equal(length(list_flattened), 4)
  expect_true(inherits(list_flattened[[1]], "ggplot"))
  expect_true(inherits(list_flattened[[2]], "gt_tbl"))
  expect_true(inherits(list_flattened[[3]], "gt_tbl"))
  expect_true(inherits(list_flattened[[4]], "gt_tbl"))

  # nested lists are not supported
  nested_list <- list(gt_tbl, list(gt_tbl2, plot))

  expect_error(
    convert_list_displays(nested_list),
    "Nested lists are not supported. See documentation for supported display types."
  )
})

