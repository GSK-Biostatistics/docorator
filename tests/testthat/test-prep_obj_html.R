make_html_docorator <- function(gt_obj) {
  suppressMessages(
    as_docorator(
      gt_obj,
      display_name = "tbl",
      footer = NULL,
      save_object = FALSE
    )
  )
}

test_that("prep_obj_html drops gt's default outer top and bottom borders", {
  html <- prep_obj_html(make_html_docorator(gt::gt(gt::exibble[1:3, 1:2])))

  expect_match(html, "border-top-style: none", fixed = TRUE)
  expect_match(html, "border-bottom-style: none", fixed = TRUE)
})

test_that("prep_obj_html removes outer borders even if the user styled them", {
  my_gt <- gt::gt(gt::exibble[1:3, 1:2]) |>
    gt::tab_options(
      table.border.top.style = "solid",
      table.border.top.color = "black",
      table.border.bottom.style = "solid",
      table.border.bottom.color = "black"
    )
  html <- prep_obj_html(make_html_docorator(my_gt))

  expect_match(html, "border-top-style: none", fixed = TRUE)
  expect_match(html, "border-bottom-style: none", fixed = TRUE)
})
