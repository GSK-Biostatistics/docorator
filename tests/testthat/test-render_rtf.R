test_that("render to rtf works", {

  skip_on_cran()
  skip_on_ci()

  my_gt <- gt::exibble |>
    gt::gt(
      rowname_col = "row",
      groupname_col = "group"
    )

  withr::with_tempdir({

    docorator <- as_docorator(
      x = my_gt,
      header = fancyhead(fancyrow(left = "first line header"), fancyrow(center = "second line header")),
      footer = NULL,
      display_name = "my_first_gt",
      display_loc = NULL,
      save_object = FALSE
    )

    res <- suppressMessages( docorator |> render_rtf()
    )

    expect_true(file.exists("my_first_gt.rtf"))
  })

})

test_that("rtf unicode characters",{


  my_gt <- gt::exibble |>
    gt::gt(
      rowname_col = "row",
      groupname_col = "group"
    ) |>
    gt::text_transform(
      locations = gt::cells_body(columns = everything()),
      fn = function(x) {
        paste0("\U00A0", x ,"\U00A0")
      }
    )

  withr::with_tempdir({

    docorator <- as_docorator(
      x = my_gt,
      display_name = "my_gt_with_spaces",
      display_loc = NULL,
      save_object = FALSE
    )

    # unicode spaces have been replaced with actual spaces
    res <- suppressMessages( docorator |> render_rtf())
    doc <- readLines("my_gt_with_spaces.rtf")|> paste0(collapse = "")
    expect_false(grepl("\u00A0", doc, perl = TRUE))

    # unicode spaces are still present
    res <- suppressMessages( docorator |> render_rtf(remove_unicode_ws = FALSE))
    doc <- readLines("my_gt_with_spaces.rtf") |> paste0(collapse = "")
    expect_true(grepl("\u00A0", doc, perl = TRUE))
  })

})

test_that("rtf headers",{

  my_gt <- gt::exibble |>
    gt::gt(
      rowname_col = "row",
      groupname_col = "group"
    )|>
    gt::tab_options(
      page.header.use_tbl_headings = TRUE
    )

  withr::with_tempdir({
    docorator <- as_docorator(
      x = my_gt,
      display_name = "my_gt_header",
      display_loc = NULL,
      save_object = FALSE,
      header = fancyhead(fancyrow(center = "Header 1")),
      footer = fancyfoot(fancyrow("test footnote"))
    )

    res <- suppressMessages( docorator |> render_rtf())
    doc <- readLines("my_gt_header.rtf") |> paste0(collapse="")
    expect_false(grepl("\\{\\\\header",doc))
    res2 <- suppressMessages( docorator |> render_rtf(use_page_header = TRUE))
    doc2 <- readLines("my_gt_header.rtf")|> paste0(collapse="")
    expect_true(grepl("\\{\\\\header",doc2))

  })
})

test_that("render to rtf, lists of figures", {

  skip_on_cran()
  skip_on_ci()

  png_obj1 <- png_path(path = system.file("extdata/test_image.png", package = "docorator"))
  png_obj2 <- png_path(path = system.file("extdata/test_image.png", package = "docorator"))

  ggplot1 <- ggplot2::ggplot(data = mtcars, ggplot2::aes(y=cyl, x=mpg)) +
    ggplot2::geom_point() +
    ggplot2::labs(title = "title1", subtitle = "subtitle1", tag = "tag1", caption = "footnote1")
  ggplot2 <- ggplot2::ggplot(data = mtcars, ggplot2::aes(x=cyl, y=mpg)) +
    ggplot2::geom_point() +
    ggplot2::labs(title = "title2", subtitle = "subtitle2", tag = "tag2", caption = "footnote2")


  withr::with_tempdir({

    # list of pngs
    docorator <- as_docorator(
      x = list(png_obj1, png_obj2),
      header = fancyhead(fancyrow(center = "first line header"), fancyrow(center = "second line header")),
      footer = NULL,
      display_name = "my_first_list",
      display_loc = NULL,
      save_object = FALSE
    )

    # list of ggplots
    docorator2 <- as_docorator(
      x = list(ggplot1, ggplot2),
      header = fancyhead(fancyrow(center = "first line header"), fancyrow(center = "second line header")),
      footer = NULL,
      display_name = "my_first_ggplot_list",
      display_loc = NULL,
      save_object = FALSE
    )

    # warnings as gt cannot handle rtf figures yet
    res <- suppressWarnings(suppressMessages( docorator |> render_rtf()
    ))
    res2 <- suppressWarnings(suppressMessages( docorator2 |> render_rtf()
    ))

    expect_true(file.exists("my_first_list.rtf"))
    expect_true(file.exists("my_first_ggplot_list.rtf"))

  })

})