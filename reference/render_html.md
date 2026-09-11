# Render to HTML

**\[experimental\]**

## Usage

``` r
render_html(x, display_loc = NULL)
```

## Arguments

- x:

  `docorator` object

- display_loc:

  optional path to save the output html to

## Value

Invisibly returns docorator object.

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
      render_html()
