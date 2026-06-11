test_that("gt_to_word outputs the correct ooxml", {
  gt_tbl <- gt::exibble |>
    gt::gt() |>
    gt::tab_header("header") |>
    gt::tab_footnote("footnote")

  ooxml <- gt_to_word(gt_tbl)
  expect_equal(class(ooxml), "xml_nodeset")

  # should be length 2 - one for the caption and one for the main body
  expect_equal(length(ooxml), 2)

  # should be Arial for both the caption and the main body
  caption <- as.character(ooxml[[1]])
  main_body <- as.character(ooxml[[2]])
  expect_true(grepl("Arial", caption))
  expect_true(grepl("Arial", main_body))

  # should contain header body and footer text
  expect_true(grepl("header", caption))
  expect_true(grepl("honeydew", main_body))
  expect_true(grepl("footnote", main_body))
})

test_that("prep_obj_docx works correctly for gt_group", {
  gt_tbl <- gt::exibble |>
    gt::gt() |>
    gt::tab_header("header") |>
    gt::tab_footnote("footnote")

  gt_tbl2 <- gt::exibble |>
    gt::gt() |>
    gt::tab_header("heading2") |>
    gt::tab_footnote("footer2")

  gt_group <- gt::gt_group(gt_tbl, gt_tbl2)

  docorator <- as_docorator(
    gt_group,
    display_name = "mytbl",
    footer = NULL,
    save_object = FALSE
  )

  ooxml <- prep_obj_docx(docorator)

  # should be a list length 2 - one for each gt_tbl
  expect_equal(length(ooxml), 2)
  # should be class list
  expect_equal(class(ooxml), "list")

  # table 1
  ooxml_1 <- ooxml[[1]]
  # should be length 2 - one for the caption and one for the main body
  expect_equal(length(ooxml_1), 2)

  # should be Arial for both the caption and the main body
  caption <- as.character(ooxml_1[[1]])
  main_body <- as.character(ooxml_1[[2]])
  expect_true(grepl("Arial", caption))
  expect_true(grepl("Arial", main_body))

  # should contain header body and footer text
  expect_true(grepl("header", caption))
  expect_true(grepl("honeydew", main_body))
  expect_true(grepl("footnote", main_body))

  # table 2
  ooxml_2 <- ooxml[[2]]
  # should be length 2 - one for the caption and one for the main body
  expect_equal(length(ooxml_2), 2)
  # should contain header body and footer text
  caption <- as.character(ooxml_2[[1]])
  main_body <- as.character(ooxml_2[[2]])
  expect_true(grepl("heading2", caption))
  expect_true(grepl("honeydew", main_body))
  expect_true(grepl("footer2", main_body))
})
