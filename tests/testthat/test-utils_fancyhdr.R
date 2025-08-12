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

