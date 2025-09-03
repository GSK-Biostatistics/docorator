test_that("Header and footer processes into latex",{

  # character (headers)
  expect_snapshot(
    hf_process("My first line")
  )
  expect_snapshot(
    hf_process(c("Two","Lines"))
  )

  # fancyhead
  expect_snapshot(
    fancyhead(
      fancyrow(right = doc_pagenum()),
      fancyrow(left = "a", center = "b", right = "c"),
      fancyrow(left = "something very longgggggggggggggggggggg")
    ) |>
      hf_process()
  )

  # fancyfoot
  expect_snapshot(
    fancyfoot(
      fancyrow(left = "something very longgggggggggggggggggggg"),
      fancyrow(right = "something else"),
      fancyrow(center = "middle")
    ) |>
      hf_process()
  )
})

test_that("Header and footer heights are calculated correctly",{

  fontsize <- 12
  my_header <- fancyhead(fancyrow("one line"))

  expect_equal(
    hf_height(my_header, fontsize),
    ceiling(fontsize*1.2)
  )

  fontsize <- 14
  my_header <- fancyhead(fancyrow("one"), fancyrow("two"))

  expect_equal(
    hf_height(my_header, fontsize),
    ceiling(fontsize*1.2*2)
  )


  fontsize <- 9
  my_header <- fancyfoot(fancyrow("one"),
                         fancyrow("two"),
                         fancyrow("three"),
                         fancyrow("four"),
                         fancyrow("five"))

  expect_equal(
    hf_height(my_header, fontsize),
    ceiling(fontsize*1.2*5)
  )
})

test_that("Footnote characters are escaped correctly",{

  footnote_string <- hf_process(fancyfoot(fancyrow(file.path("path","to", "my_file.R"))))
  title_string <- hf_process(fancyhead(fancyrow("hello_world")))
  pagenum <- hf_process(fancyhead(fancyrow(doc_pagenum())))

  expect_true(stringr::str_detect(footnote_string, "\\\\_file"))
  expect_true(stringr::str_detect(title_string, "\\\\_world"))
  expect_snapshot(pagenum)

  # escape_latex false
  footnote_string <- hf_process(fancyfoot(fancyrow(file.path("path","to", "my_file.R"))), escape_latex = FALSE)
  title_string <- hf_process(fancyhead(fancyrow("hello_world")), escape_latex = FALSE)


  expect_true(stringr::str_detect(footnote_string, "path/to/my_file.R"))
  expect_true(stringr::str_detect(title_string, "hello_world"))
})

test_that("fancyrow() accepts valid arguments",{

  expect_silent(fancyrow(left = "Left text", center = "Center text"))
  expect_silent(fancyrow(left = NA, center = "Center text", right = NA))
  expect_invisible(check_fancyrow_string(left = NA, center = "Center text", right = NA), TRUE)
})

test_that("fancyrow() flags non-character arguments",{

  expect_error(fancyrow(left = 123, center = "Center text", right = "Right text"))
  expect_error(fancyrow(left = "Left text", center = list("Center"), right = "Right text"))
})

test_that("fancyrow() flags arguments with length > 1",{

  expect_error(fancyrow(left = c("Left1", "Left2"), center = "Center text", right = "Right text"))
  expect_error(fancyrow(left = 123, center = c("Center1", "Center2"), right = "Right text"))
  expect_error(fancyrow(left = 123, center = c("Center1", "Center2")))
})
