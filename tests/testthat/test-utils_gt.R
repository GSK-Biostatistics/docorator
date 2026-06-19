test_that("add footnotes and headers", {
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
      fancyrow(right = "timestamp")
    ),
    display_name = "my_first_gt",
    save_object = FALSE
  )

  head_foot_gt <- hf_to_gt(docorator)

  # footnote
  expect_equal(
    unlist(head_foot_gt$`_footnotes`$footnotes),
    c("footnote 1", "footnote 2")
  )
  # title
  expect_equal(head_foot_gt$`_heading`$title, "first line header")
  # subtitle
  expect_equal(
    head_foot_gt$`_heading`$subtitle,
    gt::md("second line header<br>third line header")
  )
})

test_that("add footnotes and headers - gt_group", {
  # create docorator object
  gt_group <- gt::gt_group(gt::gt(head(mtcars)), gt::gt(tail(mtcars)))

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
      fancyrow(right = "timestamp")
    ),
    display_name = "my_first_gt",
    save_object = FALSE
  )

  head_foot_gt_group <- hf_to_gt(docorator)

  # separate out the two tables
  tab1 <- gt::grp_pull(head_foot_gt_group, 1)
  tab2 <- gt::grp_pull(head_foot_gt_group, 2)

  # footnote
  expect_equal(
    unlist(tab1$`_footnotes`$footnotes),
    c("footnote 1", "footnote 2")
  )
  # title
  expect_equal(tab1$`_heading`$title, "first line header")
  # subtitle
  expect_equal(
    tab1$`_heading`$subtitle,
    gt::md("second line header<br>third line header")
  )

  # footnote
  expect_equal(
    unlist(tab2$`_footnotes`$footnotes),
    c("footnote 1", "footnote 2")
  )
  # title
  expect_equal(tab2$`_heading`$title, "first line header")
  # subtitle
  expect_equal(
    tab2$`_heading`$subtitle,
    gt::md("second line header<br>third line header")
  )
})

test_that("add footnotes and headers - existing subtitle info", {
  # create docorator object
  my_gt <- gt::exibble |>
    gt::gt(
      rowname_col = "row",
      groupname_col = "group"
    ) |>
    gt::tab_header(title = "", subtitle = "TRT = Placebo, <br>X = Y")

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
      fancyrow(right = "timestamp")
    ),
    display_name = "my_first_gt",
    save_object = FALSE
  )

  head_foot_gt <- hf_to_gt(docorator)

  # subtitle
  expect_equal(
    head_foot_gt$`_heading`$subtitle,
    gt::md(
      "second line header<br>third line header<br>TRT = Placebo, <br>X = Y"
    )
  )

  # no additional subtitles
  docorator2 <- as_docorator(
    x = my_gt,
    display_name = "my_first_gt",
    save_object = FALSE
  )

  head_foot_gt2 <- hf_to_gt(docorator2)

  # subtitle
  expect_equal(
    head_foot_gt2$`_heading`$subtitle,
    gt::md("TRT = Placebo, <br>X = Y")
  )
})

test_that("add footnotes and headers - existing title info, no subtitle", {
  # create docorator object
  my_gt <- gt::exibble |>
    gt::gt(
      rowname_col = "row",
      groupname_col = "group"
    ) |>
    gt::tab_header(title = "existing title")

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
      fancyrow(right = "timestamp")
    ),
    display_name = "my_first_gt",
    save_object = FALSE
  )

  head_foot_gt <- hf_to_gt(docorator)

  # subtitle
  expect_equal(
    head_foot_gt$`_heading`$subtitle,
    gt::md("second line header<br>third line header<br>existing title")
  )

  # no additional subtitles
  docorator2 <- as_docorator(
    x = my_gt,
    display_name = "my_first_gt",
    save_object = FALSE
  )

  head_foot_gt2 <- hf_to_gt(docorator2)

  # subtitle
  expect_equal(head_foot_gt2$`_heading`$subtitle, gt::md("existing title"))
})

test_that("add footnotes and headers - existing title + subtitle info", {
  # create docorator object
  my_gt <- gt::exibble |>
    gt::gt(
      rowname_col = "row",
      groupname_col = "group"
    ) |>
    gt::tab_header(
      title = "existing title",
      subtitle = "TRT = Placebo, <br>X = Y"
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
      fancyrow(right = "timestamp")
    ),
    display_name = "my_first_gt",
    save_object = FALSE
  )

  head_foot_gt <- hf_to_gt(docorator)

  # subtitle
  expect_equal(
    head_foot_gt$`_heading`$subtitle,
    gt::md(
      "second line header<br>third line header<br>existing title<br>TRT = Placebo, <br>X = Y"
    )
  )

  # no additional subtitles
  docorator2 <- as_docorator(
    x = my_gt,
    display_name = "my_first_gt",
    save_object = FALSE
  )

  head_foot_gt2 <- hf_to_gt(docorator2)

  # subtitle
  expect_equal(
    head_foot_gt2$`_heading`$subtitle,
    gt::md("existing title<br>TRT = Placebo, <br>X = Y")
  )
})


test_that("no footnotes or headers", {
  my_gt <- gt::exibble |>
    gt::gt(
      rowname_col = "row",
      groupname_col = "group"
    )

  docorator <- as_docorator(
    x = my_gt,
    header = NULL,
    footer = NULL,
    display_loc = "test",
    display_name = "my_first_gt",
    save_object = FALSE
  )

  head_foot_gt <- hf_to_gt(docorator)

  # footnote
  expect_equal(unlist(head_foot_gt$`_footnotes`$footnotes), NULL)
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
    display_loc = "test",
    display_name = "my_first_gt",
    save_object = FALSE
  )

  head_foot_gt2 <- hf_to_gt(docorator2)

  # footnote
  expect_equal(unlist(head_foot_gt2$`_footnotes`$footnotes), NULL)
  # title
  expect_equal(head_foot_gt2$`_heading`$title, "first line header")
  # subtitle
  expect_equal(head_foot_gt2$`_heading`$subtitle, NULL)
})

test_that("apply_to_gt_group works", {
  # create gt group example
  gt_tbl <- gt::exibble |> gt::gt()
  gt_group <- gt::gt_group(gt_tbl, gt_tbl)

  # bad object
  arg_list <- list(data = mtcars)
  expect_error(
    apply_to_gt_group(mtcars, gt::tab_options, arg_list),
    'First arg must be a gt_tbl or gt_group object, not a data frame'
  )

  # create arguments - cols_align function
  gt_group <- gt::gt_group(gt_tbl, gt_tbl)
  func <- gt::tab_options
  arg_list <- list(page.header.use_tbl_headings = c(TRUE))

  # aligned gt_tbl
  options_tbl <- gt_tbl |>
    gt::tab_options(
      page.header.use_tbl_headings = TRUE
    )

  # aligned group 2 ways: one via apply_to_group one via individual aligned tables
  options_group <- apply_to_gt_group(gt_group, func, arg_list)
  expect_identical(options_group, gt::gt_group(options_tbl, options_tbl))

  # check apply_to_gt_group works for gt_tbl
  expect_identical(options_tbl, apply_to_gt_group(gt_tbl, func, arg_list))
})

test_that("Create png from ggplot", {
  withr::with_tempdir({
    gg <- ggplot2::ggplot(mtcars) +
      ggplot2::aes(x = disp, y = mpg) +
      ggplot2::geom_point()

    image_paths <- gg_to_image(gg, path = getwd())

    expect_length(image_paths, 1)

    expect_equal(
      file.exists(image_paths),
      c(TRUE)
    )
  })
})

test_that("Create set of png from list of ggplots", {
  withr::with_tempdir({
    gg1 <- ggplot2::ggplot(mtcars) +
      ggplot2::aes(x = disp, y = mpg) +
      ggplot2::geom_point()

    gg2 <- ggplot2::ggplot(mtcars) +
      ggplot2::aes(x = hp, y = mpg) +
      ggplot2::geom_point()

    image_paths <- gg_to_image(list(gg1, gg2), path = getwd())

    expect_length(image_paths, 2)

    expect_equal(
      file.exists(image_paths),
      c(TRUE, TRUE)
    )
  })
})

test_that("Extract header footer information from ggplot", {
  ggplot1 <- ggplot2::ggplot(data = mtcars, ggplot2::aes(y = cyl, x = mpg)) +
    ggplot2::geom_point() +
    ggplot2::labs(
      title = "title1",
      subtitle = "subtitle1",
      alt = "alt",
      tag = "tag1",
      caption = "footnote1"
    )

  stripped_ggplot <- ggplot2::ggplot(
    data = mtcars,
    ggplot2::aes(y = cyl, x = mpg)
  ) +
    ggplot2::geom_point() +
    ggplot2::labs(alt = "alt")

  hf_ggplot <- hf_strip(ggplot1)

  expect_equal(stripped_ggplot$labels, hf_ggplot$display$labels)

  expect_equal(hf_ggplot$head_data, "title1")
  expect_equal(hf_ggplot$subhead_data, c("subtitle1", "tag1"))
  expect_equal(hf_ggplot$foot_data, "footnote1")
})

test_that("replace empty md labels works", {
  gt_tbl <- gt::exibble |>
    gt::gt() |>
    gt::cols_label(
      num = gt::md(" "),
      char = gt::md("char")
    )

  # stubheader blank md()
  gt_with_stub <- gt::exibble |>
    gt::gt(rowname_col = "row") |>
    gt::tab_stubhead(gt::md(""))

  # stub md() not empty
  gt_with_char_stub <- gt::exibble |>
    gt::gt(rowname_col = "row") |>
    gt::tab_stubhead(gt::md("test"))

  # md in the body of the table
  gt_with_md_body <- gt::exibble |>
    dplyr::mutate(char = "") |>
    gt() |>
    fmt_markdown()

  expect_equal(
    lapply(gt_tbl$`_boxhead`$column_label, class),
    list(
      "from_markdown",
      "from_markdown",
      "character",
      "character",
      "character",
      "character",
      "character",
      "character",
      "character"
    )
  )

  cleaned_gt <- replace_empty_md(gt_tbl)

  expect_equal(
    lapply(cleaned_gt$`_boxhead`$column_label, class),
    list(
      "character",
      "from_markdown",
      "character",
      "character",
      "character",
      "character",
      "character",
      "character",
      "character"
    )
  )

  # no stub so cleaning shouldnt impact the stubhead
  expect_identical(
    gt_tbl$`_stubhead`,
    cleaned_gt$`_stubhead`
  )

  # with stub

  expect_equal(
    class(gt_with_stub$`_stubhead`$label),
    "from_markdown"
  )

  # stub isnt markdown in the boxhead
  expect_equal(
    lapply(gt_with_stub$`_boxhead`$column_label, class),
    list(
      "character",
      "character",
      "character",
      "character",
      "character",
      "character",
      "character",
      "character",
      "character"
    )
  )

  cleaned_gt_stub <- replace_empty_md(gt_with_stub)

  expect_equal(
    class(cleaned_gt_stub$`_stubhead`$label),
    "character"
  )

  expect_equal(
    lapply(cleaned_gt_stub$`_boxhead`$column_label, class),
    list(
      "character",
      "character",
      "character",
      "character",
      "character",
      "character",
      "character",
      "character",
      "character"
    )
  )

  # non empty stub md()

  cleaned_with_char_stub <- replace_empty_md(gt_with_char_stub)

  # shouldnt change the stubhead
  expect_equal(
    cleaned_with_char_stub$`_stubhead`,
    gt_with_char_stub$`_stubhead`
  )

  # empty md in the body of the table
  expect_equal(gt_with_md_body$`_data`$char, c("", "", "", "", "", "", "", ""))
  cleaned_md_body <- replace_empty_md(gt_with_md_body)
  expect_equal(
    cleaned_md_body$`_data`$char,
    c(
      "\u200B",
      "\u200B",
      "\u200B",
      "\u200B",
      "\u200B",
      "\u200B",
      "\u200B",
      "\u200B"
    )
  )
})
