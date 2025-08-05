test_that("save docorator object works", {

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

  res <- suppressMessages(as_docorator(
    x = my_gt,
    header = fancyhead(
      fancyrow("first line header"),
      fancyrow("second line header")
    ),
    footer = NULL,
    display_name = "my_first_gt",
    display_loc = temp_dir_path
  )
  )

  expect_true(file.exists(file.path(temp_dir_path, "my_first_gt.RDS")))

  # read object back in and check it matchess
  docorator_obj <- readRDS(file.path(temp_dir_path, "my_first_gt.RDS"))

  expect_equal(docorator_obj, res)

  unlink(temp_dir_path, recursive = TRUE)
})

test_that("deprecated - docorate works", {

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

  expect_warning(suppressMessages(docorate(
    x = my_gt,
    header = fancyhead(
      fancyrow("first line header"),
      fancyrow("second line header")
    ),
    footer = NULL,
    filename = "my_first_gt.pdf",
    path = temp_dir_path
  )))

  expect_true(file.exists(file.path(temp_dir_path, "my_first_gt.pdf")))

  unlink(temp_dir_path, recursive = TRUE)
})
