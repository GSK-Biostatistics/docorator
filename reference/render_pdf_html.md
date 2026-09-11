# Render to PDF (HTML)

**\[experimental\]**

## Usage

``` r
render_pdf_html(x, display_loc = NULL, keep_html = FALSE, wait = 3)
```

## Arguments

- x:

  `docorator` object

- display_loc:

  optional path to save the output pdf to

- keep_html:

  Whether to keep the intermediate HTML file. If `TRUE` the HTML is
  saved alongside the PDF with the same base name. If `FALSE` (default),
  HTML is deleted after conversion.

- wait:

  Number of seconds to wait after page navigation before printing.
  Increase if the table takes time to render. Defaults to `3`.

## Value

Invisibly returns docorator object

## Examples

    gt::gtcars |>
      dplyr::slice_head(n = 10) |>
      dplyr::select(mfr, model, year, msrp) |>
      gt::gt() |>
      as_docorator(
         display_name = "output",
         header = fancyhead(
           fancyrow(left = "Study ABC-123", right = "Draft"),
           fancyrow(center = "Table 1: Vehicle Summary")
         ),
         footer = fancyfoot(
           fancyrow(left = "Source: gtcars"),
           fancyrow(left = "program.R", right = format(Sys.Date(), "%d%b%Y"))
         )
      ) |>
      render_pdf_html()
