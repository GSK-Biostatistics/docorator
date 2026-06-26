test_that("render docx works - string", {
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
        render_docx()
    )

    # file exists
    expect_true(file.exists("string.docx"))

    # headers and footers are as expected
    doc <- officer::read_docx("string.docx")

    # header xml
    header_xml <- xml2::read_xml(file.path(
      doc$package_dir,
      "word",
      "header1.xml"
    )) |>
      as.character()
    # check for header content
    expect_equal(
      stringr::str_detect(header_xml, "Left header"),
      TRUE
    )
    expect_equal(
      stringr::str_detect(header_xml, "Center header"),
      TRUE
    )
    expect_equal(
      stringr::str_detect(header_xml, "Right header"),
      TRUE
    )

    # footer xml
    footer_xml <- xml2::read_xml(file.path(
      doc$package_dir,
      "word",
      "footer1.xml"
    ))
    # check for footer content
    expect_equal(
      stringr::str_detect(as.character(footer_xml), "Left footer"),
      TRUE
    )
    expect_equal(
      stringr::str_detect(as.character(footer_xml), "Center footer"),
      TRUE
    )
    expect_equal(
      stringr::str_detect(as.character(footer_xml), "Right footer"),
      TRUE
    )

    # file contains expected content
    officer::docx_summary(doc) |>
      dplyr::pull(text) |>
      stringr::str_detect("This is a string") |>
      expect_true()

    # vector of strings
    suppressMessages(
      as_docorator(
        c("This is a string", "with multiple lines"),
        display_name = "string_vec"
      ) |>
        render_docx()
    )

    # file exists
    expect_true(file.exists("string_vec.docx"))

    # file contains expected content
    doc_vec <- officer::read_docx("string_vec.docx")
    expect_equal(
      officer::docx_summary(doc_vec) |>
        dplyr::pull(text) |>
        stringr::str_detect("This is a string") |>
        any(),
      TRUE
    )
    expect_equal(
      officer::docx_summary(doc_vec) |>
        dplyr::pull(text) |>
        stringr::str_detect("with multiple lines") |>
        any(),
      TRUE
    )
  })
})

test_that("render docx works - gt table", {
  withr::with_tempdir({
    gt_tbl <- gt::gt(mtcars[1:5, 1:5]) |>
      gt::tab_header(title = "", subtitle = "A gt table")

    suppressMessages(
      gt_tbl |>
        as_docorator(
          display_name = "gt_tbl"
        ) |>
        render_docx()
    )

    # file exists
    expect_true(file.exists("gt_tbl.docx"))

    doc <- officer::read_docx("gt_tbl.docx")

    # file contains expected content - subtitle
    expect_equal(
      officer::docx_summary(doc) |>
        dplyr::pull(text) |>
        stringr::str_detect("A gt table") |>
        any(),
      TRUE
    )

    # check table content is present
    expect_equal(
      officer::docx_summary(doc) |>
        dplyr::pull(text) |>
        stringr::str_detect("mpg") |>
        any(),
      TRUE
    )
  })
})

test_that("render docx works - gt_group", {
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
        render_docx()
    )
    # file exists
    expect_true(file.exists("gt_group.docx"))
    # file contains expected content - subtitle from first table
    doc <- officer::read_docx("gt_group.docx")
    expect_equal(
      officer::docx_summary(doc) |>
        dplyr::pull(text) |>
        stringr::str_detect("A gt table") |>
        any(),
      TRUE
    )
    # file contains expected content - subtitle from second table
    expect_equal(
      officer::docx_summary(doc) |>
        dplyr::pull(text) |>
        stringr::str_detect("A second gt table") |>
        any(),
      TRUE
    )
  })

  # check both table contents are present - mpg is in first table, qsec is in second table
  expect_equal(
    officer::docx_summary(doc) |>
      dplyr::pull(text) |>
      stringr::str_detect("mpg") |>
      any(),
    TRUE
  )
  expect_equal(
    officer::docx_summary(doc) |>
      dplyr::pull(text) |>
      stringr::str_detect("qsec") |>
      any(),
    TRUE
  )
})

test_that("render docx works - ggplot2", {
  withr::with_tempdir({
    p <- ggplot2::ggplot(mtcars, ggplot2::aes(x = wt, y = mpg)) +
      ggplot2::geom_point() +
      ggplot2::labs(title = "A ggplot2 plot")

    suppressMessages(
      p |>
        as_docorator(display_name = "ggplot2") |>
        render_docx()
    )

    expect_true(file.exists("ggplot2.docx"))

    doc <- officer::read_docx("ggplot2.docx")
    doc_summary <- officer::docx_summary(doc, detailed = TRUE)

    expect_true(stringr::str_detect(doc_summary$image_path, ".png"))
  })
})

test_that("render docx works - png", {
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
        render_docx()
    )

    expect_true(file.exists("png.docx"))

    doc <- officer::read_docx("png.docx")
    doc_summary <- officer::docx_summary(doc, detailed = TRUE)

    expect_true(stringr::str_detect(doc_summary$image_path, ".png"))
  })
})

test_that("render docx works - list", {
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
        render_docx()
    )
    # file exists
    expect_true(file.exists("gt_group.docx"))

    # file contains expected content - subtitle from first table
    doc <- officer::read_docx("gt_group.docx")
    summary <- officer::docx_summary(doc, detailed = TRUE)
    expect_equal(
      summary |>
        dplyr::pull(run_content_text) |>
        stringr::str_detect("A gt table") |>
        any(),
      TRUE
    )
    # file contains expected content - plot
    expect_true(any(stringr::str_detect(summary$image_path, ".png")))

    # file contains expected content - subtitle from gt_group appears twice
    expect_equal(
      summary |>
        dplyr::pull(run_content_text) |>
        stringr::str_detect("A second gt table") |>
        sum(na.rm = TRUE),
      2
    )
  })
})
