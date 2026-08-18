test_that("render to pdf works", {

  skip_on_cran()
  skip_on_ci()

  my_gt <- gt::exibble |>
    gt::gt(
      rowname_col = "row",
      groupname_col = "group"
    )

  docorator <- as_docorator(
    x = my_gt,
    header = fancyhead(fancyrow("first line header"), fancyrow("second line header")),
    footer = NULL,
    display_name = "my_first_gt",
    display_loc = NULL,
    save_object = FALSE
  )

  # path set to NULL
  withr::with_tempdir({
    res <- suppressMessages( docorator |> render_pdf()
    )

    expect_true(file.exists("my_first_gt.pdf"))
  })

  # with path supplied
  withr::with_tempdir({
    dir.create("tempdir2")
    res <- suppressMessages(docorator |> render_pdf(
      display_loc = "tempdir2"
    )
    )

    expect_true(file.exists(file.path("tempdir2", "my_first_gt.pdf")))
  })

  # quarto render with path supplied
  withr::with_tempdir({

    rlang::local_options(lifecycle_verbosity = "quiet")
    dir.create("tempdir3")

    res <- suppressMessages( docorator |> render_pdf(
      quarto = TRUE,
      display_loc = "tempdir3"
    )
    )
    expect_true(file.exists(file.path("tempdir3", "my_first_gt.pdf")))
  })

  # quarto render with no path supplied
  withr::with_tempdir({
    rlang::local_options(lifecycle_verbosity = "quiet")
    docorator <- as_docorator(
      x = my_gt,
      header = fancyhead(fancyrow("first line header"), fancyrow("second line header")),
      footer = NULL,
      display_name = "my_first_gt",
      save_object = FALSE
    )
    res <- suppressMessages( docorator |> render_pdf(
      quarto = TRUE
    )
    )

    expect_true(file.exists("my_first_gt.pdf"))

  })

  # html engine render with no path supplied
  withr::with_tempdir({
    
    res <- suppressMessages(docorator |> render_pdf(engine = "html"))

    expect_true(file.exists("my_first_gt.pdf"))
  })

  # html engine render with path supplied
  withr::with_tempdir({
    dir.create("tempdir4")
    res <- suppressMessages(docorator |> render_pdf(
      engine = "html",
      display_loc = "tempdir4"
    ))

    expect_true(file.exists(file.path("tempdir4", "my_first_gt.pdf")))
  })
})

test_that("render to pdf, lists", {

  skip_on_cran()
  skip_on_ci()

  png_obj1 <- png_path(path = system.file("extdata/test_image.png", package = "docorator"))
  png_obj2 <- png_path(path = system.file("extdata/test_image.png", package = "docorator"))

  ggplot1 <- ggplot2::ggplot(data = mtcars, ggplot2::aes(y=cyl, x=mpg)) +
    ggplot2::geom_point()
  ggplot2 <- ggplot2::ggplot(data = mtcars, ggplot2::aes(x=cyl, y=mpg)) +
    ggplot2::geom_point()


  withr::with_tempdir({

    # list of pngs
    docorator <- as_docorator(
      x = list(png_obj1, png_obj2),
      header = fancyhead(fancyrow("first line header"), fancyrow("second line header")),
      footer = NULL,
      display_name = "my_first_list",
      display_loc = NULL,
      save_object = FALSE
    )

    # list of ggplots
    docorator2 <- as_docorator(
      x = list(ggplot1, ggplot2),
      header = fancyhead(fancyrow("first line header"), fancyrow("second line header")),
      footer = NULL,
      display_name = "my_first_ggplot_list",
      display_loc = NULL,
      save_object = FALSE
    )


    res <- suppressMessages( docorator |> render_pdf()
    )
    res2 <- suppressMessages( docorator2 |> render_pdf()
    )

    expect_true(file.exists("my_first_list.pdf"))
    expect_true(file.exists("my_first_ggplot_list.pdf"))

    # 2 pages
    expect_equal(pdftools::pdf_info("my_first_list.pdf")$pages,2)
    expect_equal(pdftools::pdf_info("my_first_ggplot_list.pdf")$pages,2)

    # html engine
    docorator$display_name <- "my_first_list_html"
    docorator2$display_name <- "my_first_ggplot_list_html"
    res <- suppressMessages( docorator |> render_pdf(engine = "html"))
    res2 <- suppressMessages( docorator2 |> render_pdf(engine = "html"))

    expect_true(file.exists("my_first_list_html.pdf"))
    expect_true(file.exists("my_first_ggplot_list_html.pdf"))

    # 2 pages
    expect_equal(pdftools::pdf_info("my_first_list_html.pdf")$pages,2)
    expect_equal(pdftools::pdf_info("my_first_ggplot_list_html.pdf")$pages,2)
  })

})

test_that("render to pdf, lists - quarto", {

  skip_on_cran()
  skip_on_ci()

  png_obj1 <- png_path(path = system.file("extdata/test_image.png", package = "docorator"))
  png_obj2 <- png_path(path = system.file("extdata/test_image.png", package = "docorator"))

  ggplot1 <- ggplot2::ggplot(data = mtcars, ggplot2::aes(y=cyl, x=mpg)) +
    ggplot2::geom_point()
  ggplot2 <- ggplot2::ggplot(data = mtcars, ggplot2::aes(x=cyl, y=mpg)) +
    ggplot2::geom_point()

  withr::with_tempdir({
    rlang::local_options(lifecycle_verbosity = "quiet")
    docorator <- as_docorator(
      x = list(png_obj1, png_obj2),
      header = fancyhead(fancyrow("first line header"), fancyrow("second line header")),
      footer = NULL,
      display_name = "my_first_list",
      display_loc = NULL,
      save_object = FALSE
    )

    # list of ggplots
    docorator2 <- as_docorator(
      x = list(ggplot1, ggplot2),
      header = fancyhead(fancyrow("first line header"), fancyrow("second line header")),
      footer = NULL,
      display_name = "my_first_ggplot_list",
      display_loc = NULL,
      save_object = FALSE
    )


    res <- suppressMessages( docorator |> render_pdf(quarto = TRUE))

    res2 <- suppressMessages( docorator2 |> render_pdf(quarto = TRUE))


    expect_true(file.exists("my_first_list.pdf"))
    expect_true(file.exists("my_first_ggplot_list.pdf"))

    # 2 pages
    expect_equal(pdftools::pdf_info("my_first_list.pdf")$pages,2)
    expect_equal(pdftools::pdf_info("my_first_ggplot_list.pdf")$pages,2)
  }
  )

})

test_that("render to pdf - transform (latex)", {

  skip_on_cran()
  skip_on_ci()

  my_gt <- gt::exibble |>
    gt::gt(
      rowname_col = "row",
      groupname_col = "group"
    )

  transform <- function(x){stringr::str_replace_all(x,"num", "NUM")}

  withr::with_tempdir({

    docorator <- as_docorator(
      x = my_gt,
      header = fancyhead(fancyrow("first line header"), fancyrow("second line header")),
      footer = NULL,
      display_name = "my_first_gt",
      display_loc = NULL,
      save_object = FALSE
    )

    res <- suppressMessages( docorator |> render_pdf(transform = transform)
    )

    expect_true(file.exists("my_first_gt.pdf"))
    expect_true(stringr::str_detect(pdftools::pdf_text("my_first_gt.pdf"),"NUM"))
    expect_false(stringr::str_detect(pdftools::pdf_text("my_first_gt.pdf"),"num"))

  })

  # quarto render
  withr::with_tempdir({
    rlang::local_options(lifecycle_verbosity = "quiet")
    docorator <- as_docorator(
      x = my_gt,
      header = fancyhead(fancyrow("first line header"), fancyrow("second line header")),
      footer = NULL,
      display_name = "my_first_gt",
      save_object = FALSE
    )
    expect_warning(suppressMessages( docorator |> render_pdf(
      quarto = TRUE, transform = transform
    )))

    expect_true(file.exists("my_first_gt.pdf"))

   })
})

test_that("pipe together renders",{

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

    res <- suppressMessages( docorator |> render_rtf() |> render_pdf()
    )

    expect_true(file.exists("my_first_gt.rtf"))
    expect_true(file.exists("my_first_gt.pdf"))
  })
})

test_that("render non docorator object fails", {

  my_gt <- gt::exibble |>
    gt::gt(
      rowname_col = "row",
      groupname_col = "group"
    )

  expect_error(render_pdf(my_gt), "The `my_gt` argument must be class docorator, not a <gt_tbl> object. See documentation for `as_docorator`.")
})

test_that("render invalid transform", {
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
      header = fancyhead(fancyrow("first line header"), fancyrow("second line header")),
      footer = NULL,
      display_name = "my_first_gt",
      display_loc = NULL,
      save_object = FALSE
    )

    expect_warning(suppressMessages( docorator |> render_pdf(transform = "INVALID_TRANSFORM")), "The transform argument must be a function, not a string. No transform applied.")
    expect_true(file.exists("my_first_gt.pdf"))

  })
})

test_that("render invalid header_latex", {
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
      header = fancyhead(fancyrow("first line header"), fancyrow("second line header")),
      footer = NULL,
      display_name = "my_first_gt",
      display_loc = NULL,
      save_object = FALSE
    )

    expect_warning(suppressMessages( docorator |> render_pdf(header_latex = "INVALID_TRANSFORM.R")), "The header_latex argument must point to a valid .tex file. No header options applied.")
    expect_true(file.exists("my_first_gt.pdf"))

  })
})

test_that("render header_latex", {
  skip_on_cran()
  skip_on_ci()

  my_gt <- gt::exibble |>
    gt::gt(
      rowname_col = "row",
      groupname_col = "group"
    )

  withr::with_tempdir({

    # write .tex header file
    latex_commands <- c(
      "\\begin{document}",
      "This will be the only content in the document",
      "\\end{document}"
    )
    writeLines(latex_commands, "latex_header_file.tex")

    docorator <- as_docorator(
      x = my_gt,
      header = fancyhead(fancyrow("first line header"), fancyrow("second line header")),
      footer = NULL,
      display_name = "my_first_gt",
      display_loc = NULL,
      save_object = FALSE
    )

    res <- suppressMessages( docorator |> render_pdf(header_latex = "latex_header_file.tex")
    )

    expect_true(file.exists("my_first_gt.pdf"))

    pdf_text <- pdftools::pdf_text("my_first_gt.pdf")
    expect_true(stringr::str_detect(pdf_text,"This will be the only content in the document"))

  })
})


test_that("render keep tex file", {
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
      header = fancyhead(fancyrow("first line header"), fancyrow("second line header")),
      footer = NULL,
      display_name = "my_first_gt",
      display_loc = NULL,
      save_object = FALSE
    )

    res <- suppressMessages( docorator |> render_pdf()
    )

    expect_false(file.exists("my_first_gt.tex"))

    res <- suppressMessages( docorator |> render_pdf(keep_tex = TRUE)
    )

    expect_true(file.exists("my_first_gt.tex"))
  })

})


test_that("render to pdf works with brackets in headers/footers (latex)", {

  skip_on_cran()
  skip_on_ci()

  my_gt <- gt::exibble |>
    gt::gt(
    )

  docorator <- as_docorator(
    x = my_gt,
    header = fancyhead(fancyrow("[a] first line header"), fancyrow("[b] second line header")),
    footer = fancyfoot(fancyrow("[1] first line footer"), fancyrow("[2] second line footer")),
    display_name = "my_first_gt",
    display_loc = NULL,
    save_object = FALSE
  )

  # rmd render pdf
  withr::with_tempdir({
    res <- suppressMessages( docorator |> render_pdf()
    )

    expect_true(file.exists("my_first_gt.pdf"))
  })


})

