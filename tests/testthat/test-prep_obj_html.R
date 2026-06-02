test_that("prep_obj_html for 1 table", {
  doc <- gt::exibble |>
    gt::gt() |>
    as_docorator(
      display_name = "mytbl",
      save_object = FALSE
    )

  result <- prep_obj_html(doc)

  expect_type(result, "character")
  expect_true(grepl("<table class=\"gt_table\"", result))
})

test_that("prep_obj_html for 2 tables", {
  gt_tbl <- gt::exibble |> gt::gt()
  gt_grp <- gt::gt_group(gt_tbl, gt_tbl)

  doc <- as_docorator(
    x = gt_grp,
    display_name = "mytbl",
    save_object = FALSE
  )

  result <- prep_obj_html(doc)

  expect_type(result, "character")
  expect_equal(stringr::str_count(result, "<table class=\"gt_table\""), 2)
})

test_that("prep_obj_html for ggplot", {
  gg <- ggplot2::ggplot(mtcars, ggplot2::aes(x = mpg, y = cyl)) +
    ggplot2::geom_point()

  doc <- as_docorator(
    x = gg,
    display_name = "myfig",
    footer = NULL,
    save_object = FALSE
  )

  result <- suppressMessages(prep_obj_html(doc))

  expect_type(result, "character")
  expect_true(grepl('<img src=', result))
})

test_that("prep_obj_html.default returns display object unchanged", {
  custom_obj <- structure(list(foo = "bar"), class = "some_unknown_class")

  doc <- as_docorator(
    x = custom_obj,
    display_name = "mytbl",
    footer = NULL,
    save_object = FALSE
  )

  result <- prep_obj_html(doc)
  expect_equal(result, custom_obj)
})

test_that("prep_obj_html.gg errors when ggsave fails", {
  custom_obj <- structure(list(foo = "bar"), class = "gg")

  withr::with_tempdir({
    doc <- as_docorator(
      x = custom_obj,
      display_name = "my_display",
      display_loc = NULL,
      save_object = FALSE
    )

    expect_error(
      suppressMessages(prep_obj_html(doc))
    )
  })
})


test_that("png objects are prepared correctly ",{
  png <- png_path(path = system.file("extdata/test_image.png", package = "docorator"))
  docorator <- as_docorator(png, display_name = "myfig", save_object = FALSE)
  html_png <- prep_obj_html(docorator)

  expect_type(html_png, "character")
  expect_true(grepl('<img src=', html_png))
})
