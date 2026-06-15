test_that("Set geometry defaults", {
  defaults <- list(
    paperheight = "8.5in",
    paperwidth = "11in",
    left = "1in",
    right = "1in",
    top = "1.25in",
    bottom = "1.25in",
    headsep = "10pt",
    includehead = TRUE,
    includefoot = TRUE,
    headheight = NULL,
    footskip = NULL
  )

  expect_equal(defaults, geom_set())

  expect_equal(
    geom_set(headheight = "20pt", footskip = "10pt"),
    list(
      paperheight = "8.5in",
      paperwidth = "11in",
      left = "1in",
      right = "1in",
      top = "1.25in",
      bottom = "1.25in",
      headsep = "10pt",
      includehead = TRUE,
      includefoot = TRUE,
      headheight = "20pt",
      footskip = "10pt"
    )
  )

  expect_equal(
    geom_set(left = "2in", paper = "legalpaper"),
    list(
      paperheight = "8.5in",
      paperwidth = "11in",
      right = "1in",
      top = "1.25in",
      bottom = "1.25in",
      headsep = "10pt",
      includehead = TRUE,
      includefoot = TRUE,
      headheight = NULL,
      footskip = NULL,
      left = "2in",
      paper = "legalpaper"
    )
  )
})

test_that("geometry processing with headers, footers, and fontsize - pdf", {
  fontsize <- 12
  my_header <- fancyhead(fancyrow("one"), fancyrow("two"))
  my_footer <- fancyfoot(fancyrow("one"), fancyrow("two"), fancyrow("three"))

  # auto heights
  expect_equal(
    geom_process(
      my_header,
      my_footer,
      fontsize,
      geom_set(headheight = NULL, footskip = NULL)
    ),
    paste0(
      "paperheight=8.5in, paperwidth=11in, left=1in, right=1in, top=1.25in, ",
      "bottom=1.25in, headsep=10pt, includehead=TRUE, includefoot=TRUE, headheight=29pt, footskip=44pt"
    )
  )

  # fixed heights
  expect_equal(
    geom_process(
      my_header,
      my_footer,
      fontsize,
      geom_set(headheight = "20pt", footskip = "30pt")
    ),
    paste0(
      "paperheight=8.5in, paperwidth=11in, left=1in, right=1in, top=1.25in, ",
      "bottom=1.25in, headsep=10pt, includehead=TRUE, includefoot=TRUE, headheight=20pt, footskip=30pt"
    )
  )
})

test_that("geometry processing - docx", {
  expect_equal(
    geom_process(
      geometry = geom_set(left = "0.5in", right = "0.5in"),
      engine = "docx"
    ),
    list(
      left = 0.5,
      right = 0.5,
      top = 1.25,
      bottom = 1.25
    )
  )

  # units in cm
  expect_equal(
    suppressMessages(geom_process(
      geometry = geom_set(left = "1.27cm", right = "1.27cm"),
      engine = "docx"
    )),
    list(
      left = 1.27,
      right = 1.27,
      top = 1.25,
      bottom = 1.25
    )
  )

  expect_snapshot(
    geom <- geom_process(
      geometry = geom_set(left = "1.27cm"),
      engine = "docx"
    )
  )

  # no units
  expect_equal(
    geom_process(
      geometry = geom_set(left = "1.27", right = "1.27"),
      engine = "docx"
    ),
    list(
      left = 1.27,
      right = 1.27,
      top = 1.25,
      bottom = 1.25
    )
  )

  # some values are missing
  expect_equal(
    suppressMessages(geom_process(
      geometry = list(left = "1.27in"),
      engine = "docx"
    )),
    list(
      left = 1.27,
      right = 1,
      top = 1.25,
      bottom = 1.25
    )
  )
  # test cli_text message for missing values
  expect_snapshot(
    geom <- geom_process(
      geometry = list(left = "1.27in"),
      engine = "docx"
    )
  )
})
