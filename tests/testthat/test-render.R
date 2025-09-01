test_that("render to pdf works", {

  skip_if_not(interactive())

  my_gt <- gt::exibble |>
    gt::gt(
      rowname_col = "row",
      groupname_col = "group"
    )

  temp_dir_path <- file.path(rprojroot::is_testthat$find_file(), "tempdir")
  if (!dir.exists(temp_dir_path)){
    dir.create(file.path(rprojroot::is_testthat$find_file(), "tempdir"))
  }

  docorator <- as_docorator(
    x = my_gt,
    header = fancyhead(fancyrow("first line header"), fancyrow("second line header")),
    footer = NULL,
    display_name = "my_first_gt",
    display_loc = temp_dir_path,
    save_object = FALSE
  )

  res <- suppressMessages( docorator |> render_pdf()
  )

  expect_true(file.exists(file.path(temp_dir_path, "my_first_gt.pdf")))

  # with path supplied
  temp_dir_path2 <- file.path(rprojroot::is_testthat$find_file(), "tempdir2")

  res <- suppressMessages(docorator |> render_pdf(
    display_loc = temp_dir_path2
  )
  )

  expect_true(file.exists(file.path(temp_dir_path2, "my_first_gt.pdf")))

  unlink(temp_dir_path, recursive = TRUE)
  unlink(temp_dir_path2, recursive = TRUE)

})

test_that("render to pdf, lists", {

  skip_if_not(interactive())

  png_obj1 <- png_path(path = system.file("extdata/test_image.png", package = "docorator"))
  png_obj2 <- png_path(path = system.file("extdata/test_image.png", package = "docorator"))

  ggplot1 <- ggplot2::ggplot(data = mtcars, ggplot2::aes(y=cyl, x=mpg)) +
    ggplot2::geom_point()
  ggplot2 <- ggplot2::ggplot(data = mtcars, ggplot2::aes(x=cyl, y=mpg)) +
    ggplot2::geom_point()

  temp_dir_path <- file.path(rprojroot::is_testthat$find_file(), "tempdir")
  if (!dir.exists(temp_dir_path)){
    dir.create(file.path(rprojroot::is_testthat$find_file(), "tempdir"))
  }

  # list of pngs
  docorator <- as_docorator(
    x = list(png_obj1, png_obj2),
    header = fancyhead(fancyrow("first line header"), fancyrow("second line header")),
    footer = NULL,
    display_name = "my_first_list",
    display_loc = temp_dir_path,
    save_object = FALSE
  )

  # list of ggplots
  docorator2 <- as_docorator(
    x = list(ggplot1, ggplot2),
    header = fancyhead(fancyrow("first line header"), fancyrow("second line header")),
    footer = NULL,
    display_name = "my_first_ggplot_list",
    display_loc = temp_dir_path,
    save_object = FALSE
  )


  res <- suppressMessages( docorator |> render_pdf()
  )
  res2 <- suppressMessages( docorator2 |> render_pdf()
  )

  expect_true(file.exists(file.path(temp_dir_path, "my_first_list.pdf")))
  expect_true(file.exists(file.path(temp_dir_path, "my_first_ggplot_list.pdf")))

  # 2 pages
  expect_equal(pdftools::pdf_info(file.path(temp_dir_path, "my_first_list.pdf"))$pages,2)
  expect_equal(pdftools::pdf_info(file.path(temp_dir_path, "my_first_ggplot_list.pdf"))$pages,2)

  unlink(temp_dir_path, recursive = TRUE)
})

test_that("render to rtf works", {

  skip_if_not(interactive())

  my_gt <- gt::exibble |>
    gt::gt(
      rowname_col = "row",
      groupname_col = "group"
    )

  temp_dir_path <- file.path(rprojroot::is_testthat$find_file(), "tempdir")
  if (!dir.exists(temp_dir_path)){
    dir.create(file.path(rprojroot::is_testthat$find_file(), "tempdir"))
  }

  docorator <- as_docorator(
    x = my_gt,
    header = fancyhead(fancyrow(left = "first line header"), fancyrow(center = "second line header")),
    footer = NULL,
    display_name = "my_first_gt",
    display_loc = temp_dir_path,
    save_object = FALSE
  )

  res <- suppressMessages( docorator |> render_rtf()
  )

  expect_true(file.exists(file.path(temp_dir_path, "my_first_gt.rtf")))

  # with path supplied
  temp_dir_path2 <- file.path(rprojroot::is_testthat$find_file(), "tempdir2")
  if (!dir.exists(temp_dir_path2)){
    dir.create(file.path(rprojroot::is_testthat$find_file(), "tempdir2"))
  }

  res <- suppressMessages(docorator |> render_rtf(
    display_loc = temp_dir_path2
  )
  )

  expect_true(file.exists(file.path(temp_dir_path2, "my_first_gt.rtf")))

  unlink(temp_dir_path, recursive = TRUE)
  unlink(temp_dir_path2, recursive = TRUE)

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

  temp_dir_path <- file.path(rprojroot::is_testthat$find_file(), "tempdir")
  if (!dir.exists(temp_dir_path)){
    dir.create(file.path(rprojroot::is_testthat$find_file(), "tempdir"))
  }

  docorator <- as_docorator(
    x = my_gt,
    display_name = "my_gt_with_spaces",
    display_loc = temp_dir_path,
    save_object = FALSE
  )

  # unicode spaces have been replaced with actual spaces
  res <- suppressMessages( docorator |> render_rtf())
  doc <- readLines(file.path(temp_dir_path, "my_gt_with_spaces.rtf"))|> paste0(collapse = "")
  expect_false(grepl("\u00A0", doc, perl = TRUE))

  # unicode spaces are still present
  res <- suppressMessages( docorator |> render_rtf(remove_unicode_ws = FALSE))
  doc <- readLines(file.path(temp_dir_path, "my_gt_with_spaces.rtf")) |> paste0(collapse = "")
  expect_true(grepl("\u00A0", doc, perl = TRUE))

  unlink(temp_dir_path, recursive = TRUE)
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

  temp_dir_path <- file.path(rprojroot::is_testthat$find_file(), "tempdir")
  if (!dir.exists(temp_dir_path)){
    dir.create(file.path(rprojroot::is_testthat$find_file(), "tempdir"))
  }

  docorator <- as_docorator(
    x = my_gt,
    display_name = "my_gt_header",
    display_loc = temp_dir_path,
    save_object = FALSE,
    header = fancyhead(fancyrow(center = "Header 1")),
    footer = fancyfoot(fancyrow("test footnote"))
  )

  res <- suppressMessages( docorator |> render_rtf())
  doc <- readLines(file.path(temp_dir_path, "my_gt_header.rtf")) |> paste0(collapse="")
  expect_false(grepl("\\{\\\\header",doc))
  res2 <- suppressMessages( docorator |> render_rtf(use_page_header = TRUE))
  doc2 <- readLines(file.path(temp_dir_path, "my_gt_header.rtf"))|> paste0(collapse="")
  expect_true(grepl("\\{\\\\header",doc2))

  unlink(temp_dir_path, recursive = TRUE)
})

test_that("render to rtf, lists of figures", {

  skip_if_not(interactive())

  png_obj1 <- png_path(path = system.file("extdata/test_image.png", package = "docorator"))
  png_obj2 <- png_path(path = system.file("extdata/test_image.png", package = "docorator"))

  ggplot1 <- ggplot2::ggplot(data = mtcars, ggplot2::aes(y=cyl, x=mpg)) +
    ggplot2::geom_point() +
    ggplot2::labs(title = "title1", subtitle = "subtitle1", tag = "tag1", caption = "footnote1")
  ggplot2 <- ggplot2::ggplot(data = mtcars, ggplot2::aes(x=cyl, y=mpg)) +
    ggplot2::geom_point() +
    ggplot2::labs(title = "title2", subtitle = "subtitle2", tag = "tag2", caption = "footnote2")

  temp_dir_path <- file.path(rprojroot::is_testthat$find_file(), "tempdir")
  if (!dir.exists(temp_dir_path)){
    dir.create(file.path(rprojroot::is_testthat$find_file(), "tempdir"))
  }

  # list of pngs
  docorator <- as_docorator(
    x = list(png_obj1, png_obj2),
    header = fancyhead(fancyrow(center = "first line header"), fancyrow(center = "second line header")),
    footer = NULL,
    display_name = "my_first_list",
    display_loc = temp_dir_path,
    save_object = FALSE
  )

  # list of ggplots
  docorator2 <- as_docorator(
    x = list(ggplot1, ggplot2),
    header = fancyhead(fancyrow(center = "first line header"), fancyrow(center = "second line header")),
    footer = NULL,
    display_name = "my_first_ggplot_list",
    display_loc = temp_dir_path,
    save_object = FALSE
  )

  # warnings as gt cannot handle rtf figures yet
  res <- suppressWarnings(suppressMessages( docorator |> render_rtf()
  ))
  res2 <- suppressWarnings(suppressMessages( docorator2 |> render_rtf()
  ))

  expect_true(file.exists(file.path(temp_dir_path, "my_first_list.rtf")))
  expect_true(file.exists(file.path(temp_dir_path, "my_first_ggplot_list.rtf")))

  unlink(temp_dir_path, recursive = TRUE)
})

test_that("pipe together renders",{

  skip_if_not(interactive())

  my_gt <- gt::exibble |>
    gt::gt(
      rowname_col = "row",
      groupname_col = "group"
    )

  temp_dir_path <- file.path(rprojroot::is_testthat$find_file(), "tempdir")
  if (!dir.exists(temp_dir_path)){
    dir.create(file.path(rprojroot::is_testthat$find_file(), "tempdir"))
  }

  docorator <- as_docorator(
    x = my_gt,
    header = fancyhead(fancyrow(left = "first line header"), fancyrow(center = "second line header")),
    footer = NULL,
    display_name = "my_first_gt",
    display_loc = temp_dir_path,
    save_object = FALSE
  )

  res <- suppressMessages( docorator |> render_rtf() |> render_pdf()
  )

  expect_true(file.exists(file.path(temp_dir_path, "my_first_gt.rtf")))
  expect_true(file.exists(file.path(temp_dir_path, "my_first_gt.pdf")))

  unlink(temp_dir_path, recursive = TRUE)
})

test_that("render non docorator object fails", {

  skip_if_not(interactive())

  my_gt <- gt::exibble |>
    gt::gt(
      rowname_col = "row",
      groupname_col = "group"
    )

  expect_error(render_pdf(my_gt), "The `my_gt` argument must be class docorator, not a <gt_tbl> object. See documentation for `as_docorator`.")
})

test_that("render invalid transform", {
  skip_if_not(interactive())

  my_gt <- gt::exibble |>
    gt::gt(
      rowname_col = "row",
      groupname_col = "group"
    )

  temp_dir_path <- file.path(rprojroot::is_testthat$find_file(), "tempdir")
  if (!dir.exists(temp_dir_path)){
    dir.create(file.path(rprojroot::is_testthat$find_file(), "tempdir"))
  }

  docorator <- as_docorator(
    x = my_gt,
    header = fancyhead(fancyrow("first line header"), fancyrow("second line header")),
    footer = NULL,
    display_name = "my_first_gt",
    display_loc = temp_dir_path,
    save_object = FALSE
  )

  expect_warning(suppressMessages( docorator |> render_pdf(transform = "INVALID_TRANSFORM")), "The transform argument must be a function, not a string. No transform applied.")
  expect_true(file.exists(file.path(temp_dir_path, "my_first_gt.pdf")))

  unlink(temp_dir_path, recursive = TRUE)
})

test_that("render invalid header_latex", {
  skip_if_not(interactive())

  my_gt <- gt::exibble |>
    gt::gt(
      rowname_col = "row",
      groupname_col = "group"
    )

  temp_dir_path <- file.path(rprojroot::is_testthat$find_file(), "tempdir")
  if (!dir.exists(temp_dir_path)){
    dir.create(file.path(rprojroot::is_testthat$find_file(), "tempdir"))
  }

  docorator <- as_docorator(
    x = my_gt,
    header = fancyhead(fancyrow("first line header"), fancyrow("second line header")),
    footer = NULL,
    display_name = "my_first_gt",
    display_loc = temp_dir_path,
    save_object = FALSE
  )

  expect_warning(suppressMessages( docorator |> render_pdf(header_latex = "INVALID_TRANSFORM.R")), "The header_latex argument must point to a valid .tex file. No header options applied.")
  expect_true(file.exists(file.path(temp_dir_path, "my_first_gt.pdf")))

  unlink(temp_dir_path, recursive = TRUE)
})

test_that("render header_latex", {
  skip_if_not(interactive())

  my_gt <- gt::exibble |>
    gt::gt(
      rowname_col = "row",
      groupname_col = "group"
    )

  temp_dir_path <- file.path(rprojroot::is_testthat$find_file(), "tempdir")
  if (!dir.exists(temp_dir_path)){
    dir.create(file.path(rprojroot::is_testthat$find_file(), "tempdir"))
  }

  # write .tex header file
  latex_commands <- c(
    "\\begin{document}",
    "This will be the only content in the document",
    "\\end{document}"
  )
  writeLines(latex_commands, file.path(temp_dir_path,"latex_header_file.tex"))

  docorator <- as_docorator(
    x = my_gt,
    header = fancyhead(fancyrow("first line header"), fancyrow("second line header")),
    footer = NULL,
    display_name = "my_first_gt",
    display_loc = temp_dir_path,
    save_object = FALSE
  )

  res <- suppressMessages( docorator |> render_pdf(header_latex = file.path(temp_dir_path,"latex_header_file.tex"))
  )

  expect_true(file.exists(file.path(temp_dir_path, "my_first_gt.pdf")))

  pdf_text <- pdftools::pdf_text(file.path(temp_dir_path, "my_first_gt.pdf"))
  expect_true(stringr::str_detect(pdf_text,"This will be the only content in the document"))

  unlink(temp_dir_path, recursive = TRUE)
})


test_that("render keep tex file", {
  skip_if_not(interactive())

  my_gt <- gt::exibble |>
    gt::gt(
      rowname_col = "row",
      groupname_col = "group"
    )

  temp_dir_path <- file.path(rprojroot::is_testthat$find_file(), "tempdir")
  if (!dir.exists(temp_dir_path)){
    dir.create(file.path(rprojroot::is_testthat$find_file(), "tempdir"))
  }

  docorator <- as_docorator(
    x = my_gt,
    header = fancyhead(fancyrow("first line header"), fancyrow("second line header")),
    footer = NULL,
    display_name = "my_first_gt",
    display_loc = temp_dir_path,
    save_object = FALSE
  )

  res <- suppressMessages( docorator |> render_pdf()
  )

  expect_false(file.exists(file.path(temp_dir_path, "my_first_gt.tex")))

  res <- suppressMessages( docorator |> render_pdf(keep_tex = TRUE)
  )

  expect_true(file.exists(file.path(temp_dir_path, "my_first_gt.tex")))

  unlink(temp_dir_path, recursive = TRUE)
})




