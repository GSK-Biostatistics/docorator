
test_that("Set geometry defaults",{

  defaults <- list(
    paperheight="8.5in",
    paperwidth="11in",
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

  expect_equal(geom_set(headheight="20pt", footskip="10pt"),
               list(
                 paperheight="8.5in",
                 paperwidth="11in",
                 left = "1in",
                 right = "1in",
                 top = "1.25in",
                 bottom = "1.25in",
                 headsep = "10pt",
                 includehead = TRUE,
                 includefoot = TRUE,
                 headheight = "20pt",
                 footskip = "10pt"
               ))

  expect_equal(geom_set(left="2in", paper="legalpaper"),
               list(
                 paperheight="8.5in",
                 paperwidth="11in",
                 right = "1in",
                 top = "1.25in",
                 bottom = "1.25in",
                 headsep = "10pt",
                 includehead = TRUE,
                 includefoot = TRUE,
                 headheight = NULL,
                 footskip = NULL,
                 left = "2in",
                 paper="legalpaper"
               ))

})

test_that("geometry processing with headers, footers, and fontsize",{

  fontsize <- 12
  my_header <- fancyhead(fancyrow("one"), fancyrow("two"))
  my_footer <- fancyfoot(fancyrow("one"),
                         fancyrow("two"),
                         fancyrow("three"))

  # auto heights
  expect_equal(
    geom_process(my_header, my_footer, fontsize, geom_set(headheight=NULL, footskip=NULL)),
    paste0("paperheight=8.5in, paperwidth=11in, left=1in, right=1in, top=1.25in, ",
           "bottom=1.25in, headsep=10pt, includehead=TRUE, includefoot=TRUE, headheight=29pt, footskip=44pt")
  )

  # fixed heights
  expect_equal(
    geom_process(my_header, my_footer, fontsize, geom_set(headheight="20pt",footskip="30pt")),
    paste0("paperheight=8.5in, paperwidth=11in, left=1in, right=1in, top=1.25in, ",
           "bottom=1.25in, headsep=10pt, includehead=TRUE, includefoot=TRUE, headheight=20pt, footskip=30pt")
  )
})
