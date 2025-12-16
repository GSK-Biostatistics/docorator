
test_that("gt to latex conversion preserves formatting",{
  ard <- tfrmt::data_efficacy
  tf <- tfrmt::json_to_tfrmt(system.file("json_examples/tfrmt_efficacy.json", package = "tfrmt"))
  tbl <- tfrmt::print_to_gt(tf, ard)

  # table header
  preamble <- gt_to_tex(tbl) |>
              strsplit("\n") |>
    unlist()

  expect_snapshot(
    preamble[1:6]
  )
})

test_that("gt to latex conversion works with additional transformation function",{
  ard <- tfrmt::data_efficacy
  tf <- tfrmt::json_to_tfrmt(system.file("json_examples/tfrmt_efficacy.json", package = "tfrmt"))
  tbl <- tfrmt::print_to_gt(tf, ard)
  transform <- function(x){stringr::str_replace_all(x,"Placebo", "PLACEBO")}

  # table header no transform
  preamble <- gt_to_tex(tbl) |>
    strsplit("\n") |>
    unlist()


  # table header transform
  preamble2 <- gt_to_tex(tbl, transform = transform) |>
    strsplit("\n") |>
    unlist()

  expect_true(stringr::str_detect(preamble[5], "Placebo"))
  expect_false(stringr::str_detect(preamble[5], "PLACEBO"))
  expect_true(stringr::str_detect(preamble2[5], "PLACEBO"))
  expect_false(stringr::str_detect(preamble2[5], "Placebo"))

})

test_that("png objects are prepared correctly ",{
  png <- png_path(path = system.file("extdata/test_image.png", package = "docorator"))
  docorator <- as_docorator(png, display_name = "myfig", save_object = FALSE)
  knit_png <- prep_obj_tex(docorator)
  expect_true(inherits(knit_png,c("knit_image_paths", "knit_asis")))
})


test_that("ggplot objects are prepared correctly when ggplot2 not loaded", {

  # import previous docorator obj
  doc <- readRDS(system.file("extdata/docorator_ggplot.RDS", package = "docorator"))

  display <- prep_obj_tex(doc$display)

  expect_s3_class(display, "ggplot")
})
