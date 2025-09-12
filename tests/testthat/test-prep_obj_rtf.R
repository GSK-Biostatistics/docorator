test_that("prep_obj_rtf - ggplot", {

  ggplot1 <- ggplot2::ggplot(data = mtcars, ggplot2::aes(y=cyl, x=mpg)) +
    ggplot2::geom_point() +
    ggplot2::labs(title = "title1", subtitle = "subtitle1", tag = "tag1", caption = "footnote1")
  ggplot2 <- ggplot2::ggplot(data = mtcars, ggplot2::aes(x=cyl, y=mpg)) +
    ggplot2::geom_point() +
    ggplot2::labs(title = "title2", subtitle = "subtitle2", tag = "tag2", caption = "footnote2")

  # list of ggplots
  docorator <- as_docorator(
    x = list(ggplot1, ggplot2),
    header = fancyhead(fancyrow(center = "this is the title"),
                       fancyrow(center = "this is the subtitle1"),
                       fancyrow(center = "this is the subtitle2")),
    footer = fancyfoot(fancyrow(left = "this is the docorator footnote")),
    display_name = "mytbl",
    save_object = FALSE)

  gt_display <- prep_obj_rtf(docorator)

  # should be a gt_group object
  expect_equal(class(gt_display), "gt_group")

  gt_1 <- gt::grp_pull(gt_display, 1)
  gt_2 <- gt::grp_pull(gt_display, 2)

  # check headers and footers are added correctly for each

  # ggplot footnote first
  expect_equal(unlist(gt_1$`_footnotes`$footnotes), c("footnote1", "this is the docorator footnote"))
  expect_equal(unlist(gt_2$`_footnotes`$footnotes), c("footnote2", "this is the docorator footnote"))

  # title should be docorator title
  # subtitle should be docorator subtitles then ggplot subtitle then tag
  expect_equal(gt_1$`_heading`$title, "this is the title")
  expect_equal(as.character(gt_1$`_heading`$subtitle), "this is the subtitle1<br>this is the subtitle2<br>subtitle1<br>tag1")
  expect_equal(gt_2$`_heading`$title, "this is the title")
  expect_equal(as.character(gt_2$`_heading`$subtitle), "this is the subtitle1<br>this is the subtitle2<br>subtitle2<br>tag2")

})

test_that("prep_obj_rtf - png", {

  png_obj1 <- png_path(path = system.file("extdata/test_image.png", package = "docorator"))
  png_obj2 <- png_path(path = system.file("extdata/test_image.png", package = "docorator"))

  # list of pngs
  docorator <- as_docorator(
    x = list(png_obj1, png_obj2),
    header = fancyhead(fancyrow(center = "this is the title"),
                       fancyrow(center = "this is the subtitle1"),
                       fancyrow(center = "this is the subtitle2")),
    footer = fancyfoot(fancyrow(left = "this is the docorator footnote")),
    display_name = "mytbl",
    save_object = FALSE)

  gt_display <- prep_obj_rtf(docorator)

  # should be a gt_group object
  expect_equal(class(gt_display), "gt_group")

  gt_1 <- gt::grp_pull(gt_display, 1)
  gt_2 <- gt::grp_pull(gt_display, 2)

  # check headers and footers are added correctly for each
  expect_equal(unlist(gt_1$`_footnotes`$footnotes), "this is the docorator footnote")
  expect_equal(unlist(gt_2$`_footnotes`$footnotes), "this is the docorator footnote")

  # title should be docorator title
  # subtitle should be docorator subtitles
  expect_equal(gt_1$`_heading`$title, "this is the title")
  expect_equal(as.character(gt_1$`_heading`$subtitle), "this is the subtitle1<br>this is the subtitle2")
  expect_equal(gt_2$`_heading`$title, "this is the title")
  expect_equal(as.character(gt_2$`_heading`$subtitle), "this is the subtitle1<br>this is the subtitle2")

})

test_that("prep_obj_rtf - character", {
  character <- "No Data to Display"

  docorator <- as_docorator(
    x = character,
    header = fancyhead(fancyrow(center = "this is the title"),
                       fancyrow(center = "this is the subtitle1"),
                       fancyrow(center = "this is the subtitle2")),
    footer = fancyfoot(fancyrow(left = "this is the docorator footnote")),
    display_name = "mytbl",
    save_object = FALSE)

  gt_display <- prep_obj_rtf(docorator)

  # should be a gt_table object
  expect_equal(class(gt_display), c("gt_tbl","list"))


  # check headers and footers are added correctly

  expect_equal(unlist(gt_display$`_footnotes`$footnotes), "this is the docorator footnote")

  # title should be docorator title
  # subtitle should be docorator subtitle
  expect_equal(gt_display$`_heading`$title, "this is the title")
  expect_equal(as.character(gt_display$`_heading`$subtitle), "this is the subtitle1<br>this is the subtitle2")
 })

test_that("prep_obj_rtf - invalid", {
  numeric <- 1

  docorator <- as_docorator(
    x = numeric,
    header = fancyhead(fancyrow(center = "this is the title"),
                       fancyrow(center = "this is the subtitle1"),
                       fancyrow(center = "this is the subtitle2")),
    footer = fancyfoot(fancyrow(left = "this is the docorator footnote")),
    display_name = "mytbl",
    save_object = FALSE)

  expect_error(prep_obj_rtf(docorator), "For RTF render the display must be class character, gt_tbl, gt_group, PNG, or ggplot, not a number.")
})
