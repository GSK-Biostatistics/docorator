test_that("save docorator object works", {

  skip_on_cran()
  skip_on_ci()

  my_gt <- gt::exibble |>
    gt::gt(
      rowname_col = "row",
      groupname_col = "group"
    )

  withr::with_tempdir({
    res <- suppressMessages(as_docorator(
      x = my_gt,
      header = fancyhead(
        fancyrow("first line header"),
        fancyrow("second line header")
      ),
      footer = NULL,
      display_name = "my_first_gt",
      display_loc = NULL
    )
    )

    expect_true(file.exists("my_first_gt.RDS"))

    # read object back in and check it matches
    docorator_obj <- readRDS("my_first_gt.RDS")

    expect_equal(docorator_obj, res)

  })
})

test_that("deprecated - docorate works", {

  skip_on_cran()
  skip_on_ci()

  my_gt <- gt::exibble |>
    gt::gt(
      rowname_col = "row",
      groupname_col = "group"
    )

  withr::with_tempdir({

    expect_error(
      docorate(
        x = my_gt,
        header = fancyhead(
          fancyrow("first line header"),
          fancyrow("second line header")
        ),
        footer = NULL,
        filename = "my_first_gt.pdf",
        path = NULL
      ))

    expect_false(file.exists("my_first_gt.pdf"))

  })
})

test_that("Create docorator object without display_name errors",{

  skip_on_cran()
  skip_on_ci()

  my_gt <- gt::exibble |>
    gt::gt(
      rowname_col = "row",
      groupname_col = "group"
    )

  expect_error(
    suppressMessages(
      as_docorator(
      x = my_gt,
      header = fancyhead(
        fancyrow("first line header")
      ),
      footer = NULL,
      save_object = FALSE
    )
    ),
    "The `display_name` argument must be specified"
  )



})

test_that("Create docorator object with invalid display errors",{

  expect_error(as_docorator(
    x = list(),
    display_name = "empty_list",
    save_object = FALSE
  ),
  "The `x` argument cannot be empty or NULL. Please provide a valid display object.")

  expect_error(as_docorator(
    x = NULL,
    display_name = "null_object",
    save_object = FALSE
  ),
  "The `x` argument cannot be empty or NULL. Please provide a valid display object.")

})

test_that("NULL elements in a list of displays error with a cleanup hint", {

  tbl <- gt::gt(gt::exibble)

  # NULL in the middle used to silently duplicate the following element
  expect_error(
    as_docorator(
      x = list(tbl, NULL, tbl),
      display_name = "null_in_list",
      save_object = FALSE
    ),
    "contains NULL .* 2"
  )

  # all NULL positions are reported, and the message shows how to fix it
  expect_error(
    as_docorator(
      x = list(NULL, tbl, NULL),
      display_name = "null_in_list",
      save_object = FALSE
    ),
    "1 and 3"
  )
  expect_error(
    as_docorator(
      x = list(tbl, NULL),
      display_name = "null_in_list",
      save_object = FALSE
    ),
    "Filter(Negate(is.null)",
    fixed = TRUE
  )

  # lists without NULL elements are unaffected
  expect_no_error(
    as_docorator(
      x = list(tbl, tbl),
      display_name = "no_null_in_list",
      save_object = FALSE
    )
  )

  # NA is a valid element and is not flagged
  expect_no_error(
    as_docorator(
      x = list(tbl, NA, tbl),
      display_name = "na_in_list",
      save_object = FALSE
    )
  )

})
