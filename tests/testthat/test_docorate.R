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

    expect_warning(suppressMessages(
      docorate(
        x = my_gt,
        header = fancyhead(
          fancyrow("first line header"),
          fancyrow("second line header")
        ),
        footer = NULL,
        filename = "my_first_gt.pdf",
        path = NULL
      )))

    expect_true(file.exists("my_first_gt.pdf"))

  })
})
