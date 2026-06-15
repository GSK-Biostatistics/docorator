# Render to docx

**\[experimental\]**

## Usage

``` r
render_docx(x, display_loc = NULL, version_check = TRUE)
```

## Arguments

- x:

  `docorator` object

- display_loc:

  optional path to save the output docx to

- version_check:

  Boolean indicating whether to print a note if gt or ggplot versions
  dont match between the original docorator object and the one being
  used for rendering

## Value

This function saves a docx to a specified location

## Examples

    gt::gtcars |>
      dplyr::slice_head(n = 10) |>
      dplyr::select(mfr, model, year, msrp) |>
      gt::gt(groupname_col = "mfr",
             row_group_as_column = TRUE) |>
      as_docorator(
       header = fancyhead(fancyrow("Header 1"), fancyrow("Header 2")),
       display_name = "mytbl") |>
     render_docx()
