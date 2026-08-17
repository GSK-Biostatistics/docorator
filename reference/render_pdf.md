# Render to pdf

Render to pdf

## Usage

``` r
render_pdf(
  x,
  display_loc = NULL,
  engine = c("latex"),
  version_check = TRUE,
  fancywrap = TRUE,
  ...
)
```

## Arguments

- x:

  `docorator` object

- display_loc:

  optional path to save the output pdf to

- engine:

  character vector of rendering engines to use. Options are "latex"
  (default).

- version_check:

  Boolean indicating whether to print a note if gt or ggplot versions
  dont match between the original docorator object and the one being
  used for rendering

- fancywrap:

  Boolean indicating if headers and footers should be split to fit the
  page. Defaults to `TRUE`. Note that only fancyrows with one `left`,
  `right` OR `center` element will be wrapped. **\[experimental\]**

- ...:

  Additional arguments passed to the engine-specific render function.

  For `engine = "latex"`, see
  [`render_pdf_latex()`](https://GSK-Biostatistics.github.io/docorator/reference/render_pdf_latex.md)
  for supported arguments.

## Value

This function saves a pdf to a specified location

## Examples

    gt::gtcars |>
      dplyr::slice_head(n = 10) |>
      dplyr::select(mfr, model, year, msrp) |>
      gt::gt(groupname_col = "mfr",
             row_group_as_column = TRUE) |>
      as_docorator(
       header = fancyhead(fancyrow("Header 1"), fancyrow("Header 2")),
       display_name = "mytbl") |>
     render_pdf()
