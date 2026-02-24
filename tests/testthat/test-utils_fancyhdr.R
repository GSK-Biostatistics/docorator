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

  expect_error(fancyrow(left = 123, center = "Center text", right = "Right text"), "`left` must be a character string or NA, but is numeric.")
  expect_error(fancyrow(left = "Left text", center = list("Center"), right = "Right text"), "`center` must be a character string or NA, but is list.")
})

test_that("fancyrow() flags arguments with length > 1",{

  expect_error(fancyrow(left = c("Left1", "Left2"), center = "Center text", right = "Right text"), "`left` must be a single value, but has a length of 2.")
  expect_error(fancyrow(left = 123, center = c("Center1", "Center2"), right = "`left` must be a character string or NA, but is numeric.
`center` must be a single value, but has a length of 2."))
  expect_error(fancyrow(left = 123, center = c("Center1", "Center2", "Center3")),"`left` must be a character string or NA, but is numeric.
`center` must be a single value, but has a length of 3.")
})

test_that("fancyrows are split when required", {
  # 185 char fancyrow with only 1 element, should be split into 3
  fancyrow1 <- fancyrow(left = "The quick brown fox jumps over the lazy dog, showcasing a vibrant array of colors and swift movements across the tranquil, sun-drenched landscape. This idyllic scene unfolds gracefully.")
  fancywrap1 <- fancywrap(fancyrow1, chars = 70)
  expect_equal(fancywrap1,
               list(fancyrow(left = "The quick brown fox jumps over the lazy dog, showcasing a vibrant"),
                    fancyrow(left = "array of colors and swift movements across the tranquil, sun-drenched"),
                    fancyrow(left = "landscape. This idyllic scene unfolds gracefully.")))
  # right
  fancyrow2 <- fancyrow(right = "The quick brown fox jumps over the lazy dog, showcasing a vibrant array of colors and swift movements across the tranquil, sun-drenched landscape. This idyllic scene unfolds gracefully.")
  fancywrap2 <- fancywrap(fancyrow2, chars = 70)
  expect_equal(fancywrap2,
               list(fancyrow(right = "The quick brown fox jumps over the lazy dog, showcasing a vibrant"),
                    fancyrow(right = "array of colors and swift movements across the tranquil, sun-drenched"),
                    fancyrow(right = "landscape. This idyllic scene unfolds gracefully.")))

  # center
  fancyrow3 <- fancyrow(center = "The quick brown fox jumps over the lazy dog, showcasing a vibrant array of colors and swift movements across the tranquil, sun-drenched landscape. This idyllic scene unfolds gracefully.")
  fancywrap3 <- fancywrap(fancyrow3, chars = 70)
  expect_equal(fancywrap3,
               list(fancyrow(center = "The quick brown fox jumps over the lazy dog, showcasing a vibrant"),
                    fancyrow(center = "array of colors and swift movements across the tranquil, sun-drenched"),
                    fancyrow(center = "landscape. This idyllic scene unfolds gracefully.")))

  # 2 elements - no wrapping just adds to list, too long to fit
  fancyrow4 <- fancyrow(left = "The quick brown fox jumps over the lazy dog, showcasing a vibrant array of colors and swift movements across the tranquil, sun-drenched landscape. This idyllic scene unfolds gracefully.",
                        right = "second element which prevents wrapping")
  fancywrap4 <- suppressMessages(fancywrap(fancyrow4, chars = 70))
  # tells you it's too long and won't fit
  expect_message(fancywrap(fancyrow4, chars = 70))


  # 2 elements - no wrapping just adds to list, everything fits
  fancyrow5 <- fancyrow(left = "The quick brown fox",
                        right = "second element which prevents wrapping")
  fancywrap5 <- fancywrap(fancyrow5, chars = 70)
  expect_equal(list(fancyrow5), fancywrap5)


  # empty fancyrow - no change
  fancyrow6 <- fancyrow()
  fancywrap6 <- fancywrap(fancyrow6, chars = 10)
  expect_equal(list(fancyrow6), fancywrap6)


})

test_that("splitting of fancyhead and fancyfoot elements are handled correctly",{

  fancyhead1 <- fancyhead(
    # one element should be wrapped into 2
    fancyrow(left = "The quick brown fox jumps over the lazy dog, showcasing a vibrant array of colors and swift movements across the tranquil, sun-drenched landscape. This idyllic scene unfolds gracefully."),
    # two elements should be left as is
    fancyrow(center = "The quick brown fox jumps over the lazy dog, showcasing a vibrant array of colors and swift movements across the tranquil, sun-drenched landscape. This idyllic scene unfolds gracefully.",
             right = "second element that will prevent wrapping")
  )
  fancywrap1 <- suppressMessages(fancywrap(fancyhead1, chars = 70))

  # should still be a fancyheader
  expect_true(inherits(fancywrap1, "fancyhead"))
  expect_equal(
    # 4 fancyrows
    fancyhead(
      fancyrow(left = "The quick brown fox jumps over the lazy dog, showcasing a vibrant"),
      fancyrow(left = "array of colors and swift movements across the tranquil, sun-drenched"),
      fancyrow(left = "landscape. This idyllic scene unfolds gracefully."),
      fancyrow(center = "The quick brown fox jumps over the lazy dog, showcasing a vibrant array of colors and swift movements across the tranquil, sun-drenched landscape. This idyllic scene unfolds gracefully.", right = "second element that will prevent wrapping")
    ),
    fancywrap1
  )


  fancyfoot1 <- fancyfoot(
    # two elements should be left as is
    fancyrow(center = "The quick brown fox jumps over the lazy dog, showcasing a vibrant array of colors and swift movements across the tranquil, sun-drenched landscape. This idyllic scene unfolds gracefully.",
             right = "second element that will prevent wrapping"),
    # one element should be wrapped into 2
    fancyrow(left = "The quick brown fox jumps over the lazy dog, showcasing a vibrant array of colors and swift movements across the tranquil, sun-drenched landscape. This idyllic scene unfolds gracefully.")
  )
  fancywrap2 <- suppressMessages(fancywrap(fancyfoot1, chars = 70))

  # should still be a fancyheader
  expect_true(inherits(fancywrap2, "fancyfoot"))
  expect_equal(
    # 4 fancyrows
    fancyfoot(
      fancyrow(center = "The quick brown fox jumps over the lazy dog, showcasing a vibrant array of colors and swift movements across the tranquil, sun-drenched landscape. This idyllic scene unfolds gracefully.", right = "second element that will prevent wrapping"),
      fancyrow(left = "The quick brown fox jumps over the lazy dog, showcasing a vibrant"),
      fancyrow(left = "array of colors and swift movements across the tranquil, sun-drenched"),
      fancyrow(left = "landscape. This idyllic scene unfolds gracefully.")
    ),
    fancywrap2
  )

})

test_that("splitting of fancyhead and fancyfoot elements in a docorator object is handled correctly",{
  my_gt <- gt::exibble |>
    gt::gt(
      rowname_col = "row",
      groupname_col = "group"
    )

  # no headers and footers
  docorator1 <- as_docorator(
    x = my_gt,
    header = NULL,
    footer=NULL,
    display_name = "no_headers_or_footers",
    display_loc = NULL,
    save_object = FALSE
  )

  fancywrap1 <- fancywrap(docorator1)

  # no change
  expect_equal(fancywrap1, docorator1)

  docorator2 <- as_docorator(
    x = my_gt,
    header = fancyhead(
      fancyrow(left = "The quick brown fox jumps over the lazy dog, showcasing a vibrant array of colors and swift movements across the tranquil, sun-drenched landscape. This idyllic scene unfolds gracefully.")
    ),
    footer = fancyfoot(
      fancyrow(left = "The quick brown fox jumps over the lazy dog, showcasing a vibrant array of colors and swift movements across the tranquil, sun-drenched landscape. This idyllic scene unfolds gracefully.")
    ),
    display_name = "headers_and_footers",
    display_loc = NULL,
    save_object = FALSE
  )

  fancywrap2 <- fancywrap(docorator2)

  # for font size 10 the characters should be 126
  expect_equal(
    as_docorator(
      x = my_gt,
      header = fancywrap(fancyhead(
        fancyrow(left = "The quick brown fox jumps over the lazy dog, showcasing a vibrant array of colors and swift movements across the tranquil, sun-drenched landscape. This idyllic scene unfolds gracefully.")
      ), 126),
      footer = fancywrap(fancyfoot(
        fancyrow(left = "The quick brown fox jumps over the lazy dog, showcasing a vibrant array of colors and swift movements across the tranquil, sun-drenched landscape. This idyllic scene unfolds gracefully.")
      ), 126),
      display_name = "headers_and_footers",
      display_loc = NULL,
      save_object = FALSE
    ),
    fancywrap2
  )

})
