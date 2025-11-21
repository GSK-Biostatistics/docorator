# Render to pdf

Render to pdf

## Usage

``` r
render_pdf(
  x,
  display_loc = NULL,
  transform = NULL,
  header_latex = NULL,
  keep_tex = FALSE,
  escape_latex = TRUE,
  quarto = FALSE
)
```

## Arguments

- x:

  `docorator` object

- display_loc:

  optional path to save the output pdf to

- transform:

  optional latex transformation function to apply to a gt latex string

- header_latex:

  optional .tex file of header latex

- keep_tex:

  Boolean indicating if to keep resulting .tex file from latex
  conversion. Defaults to FALSE.

- escape_latex:

  Boolean indicating if headers and footers of a gt table should be
  escaped with gt::escape_latex

- quarto:

  Boolean indicating whether to use Quarto as the rendering engine.
  Defaults to `FALSE`, which uses Rmarkdown to render.
  **\[experimental\]**

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
