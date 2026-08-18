test_that("render html works - string", {
  withr::with_tempdir({
    suppressMessages(
      # single string with headers and footers
      as_docorator(
        "This is a string",
        display_name = "string",
        header = fancyhead(
          fancyrow(
            left = "Left header"
          ),
          fancyrow(center = "Center header", right = "Right header")
        ),
        footer = fancyfoot(
          fancyrow(
            left = "Left footer",
            center = "Center footer"
          ),
          fancyrow(right = "Right footer") 
        )
      ) |>
        render_html()
    )

    # file exists
    expect_true(file.exists("string.html"))

    # headers and footers are as expected
    html <- xml2::read_html("string.html") |> 
      as.character()

    # check for header content
    expect_equal(
      stringr::str_detect(html, c('<span class=\"hf-left\">Left header</span>', '<span class=\"hf-center\">Center header</span>', '<span class=\"hf-right\">Right header</span>')),
      c(TRUE, TRUE, TRUE)
    )
    # check for footer content
    expect_equal(
      stringr::str_detect(html, c('<span class=\"hf-left\">Left footer</span>', '<span class=\"hf-center\">Center footer</span>', '<span class=\"hf-right\">Right footer</span>')),
      c(TRUE, TRUE, TRUE)
    )

    # check body content
    expect_true(
      stringr::str_detect(html, 'style=\"text-align:center;\">This is a string')
    )
  })
})

test_that("render html works - gt table", {
  withr::with_tempdir({
    gt_tbl <- gt::gt(mtcars[1:5, 1:5]) |>
      gt::tab_header(title = "", subtitle = "A gt table")

    suppressMessages(
      gt_tbl |>
        as_docorator(
          display_name = "gt_tbl"
        ) |>
        render_html()
    )

    # file exists
    expect_true(file.exists("gt_tbl.html"))

    html <- xml2::read_html("gt_tbl.html") |> as.character()

    # gt table subtitle is present in body
    expect_true(stringr::str_detect(html, "A gt table"))

    # column names from mtcars are present
    expect_equal(
      stringr::str_detect(html, c("mpg", "cyl", "disp", "hp", "drat")),
      c(TRUE, TRUE, TRUE, TRUE, TRUE)
    )
  })
})

test_that("render html works - gt_group", {
  withr::with_tempdir({
    gt_tbl <- gt::gt(mtcars[1:5, 1:5]) |>
      gt::tab_header(title = "", subtitle = "A gt table")
    gt_tbl2 <- gt::gt(mtcars[6:10, 6:10]) |>
      gt::tab_header(title = "", subtitle = "A second gt table")
    gt_group <- gt::gt_group(gt_tbl, gt_tbl2)

    suppressMessages(
      gt_group |>
        as_docorator(
          display_name = "gt_group"
        ) |>
        render_html()
    )

    # file exists
    expect_true(file.exists("gt_group.html"))

    html <- xml2::read_html("gt_group.html") |> as.character()

    # both table subtitles are present
    expect_true(stringr::str_detect(html, "A gt table"))
    expect_true(stringr::str_detect(html, "A second gt table"))
  })
})

test_that("render html works - ggplot2", {
  withr::with_tempdir({
    p <- ggplot2::ggplot(mtcars, ggplot2::aes(x = wt, y = mpg)) +
      ggplot2::geom_point() +
      ggplot2::labs(title = "A ggplot2 plot")

    suppressMessages(
      p |>
        as_docorator(display_name = "ggplot2") |>
        render_html()
    )

    expect_true(file.exists("ggplot2.html"))

    html <- xml2::read_html("ggplot2.html") |> as.character()

    # ggplot is embedded as a base64 img
    expect_true(stringr::str_detect(html, "data:image/png;base64"))
  })
})

test_that("render html works - png", {
  withr::with_tempdir({
    p <- ggplot2::ggplot(mtcars, ggplot2::aes(x = wt, y = mpg)) +
      ggplot2::geom_point() +
      ggplot2::labs(title = "A ggplot2 plot")

    ggplot2::ggsave(
      filename = "test.png",
      plot = p,
      width = 5,
      height = 5
    )

    suppressMessages(
      as_docorator(
        png_path("test.png"),
        display_name = "png"
      ) |>
        render_html()
    )

    expect_true(file.exists("png.html"))

    html <- xml2::read_html("png.html") |> as.character()

    # png is embedded as a base64 img
    expect_true(stringr::str_detect(html, "data:image/png;base64"))
  })
})

test_that("render html works - list", {
  withr::with_tempdir({
    gt_tbl <- gt::gt(mtcars[1:5, 1:5]) |>
      gt::tab_header(title = "", subtitle = "A gt table")
    gt_tbl2 <- gt::gt(mtcars[6:10, 6:10]) |>
      gt::tab_header(title = "", subtitle = "A second gt table")
    gt_group <- gt::gt_group(gt_tbl2, gt_tbl2)
    p <- ggplot2::ggplot(mtcars, ggplot2::aes(x = wt, y = mpg)) +
      ggplot2::geom_point() +
      ggplot2::labs(title = "A ggplot2 plot")

    suppressMessages(
      list(gt_tbl, p, gt_group) |>
        as_docorator(
          display_name = "gt_group"
        ) |>
        render_html()
    )

    # file exists
    expect_true(file.exists("gt_group.html"))

    html <- xml2::read_html("gt_group.html") |> as.character()

    # gt table content is present
    expect_true(stringr::str_detect(html, "A gt table"))

    # ggplot is embedded
    expect_true(stringr::str_detect(html, "data:image/png;base64"))
  })
})

test_that("render html works - display_loc", {
  withr::with_tempdir({
    dir.create("output_dir")

    suppressMessages(
      as_docorator(
        "This is a string",
        display_name = "string"
      ) |>
        render_html(display_loc = "output_dir")
    )

    expect_true(file.exists(file.path("output_dir", "string.html")))
  })
})

test_that("render non-docorator object fails", {
  my_gt <- gt::gt(mtcars[1:5, 1:5])

  expect_error(
    render_html(my_gt),
    "The `my_gt` argument must be class docorator"
  )
})

