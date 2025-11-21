# Render to rtf

**\[experimental\]**

## Usage

``` r
render_rtf(
  x,
  display_loc = NULL,
  remove_unicode_ws = TRUE,
  use_page_header = FALSE
)
```

## Arguments

- x:

  `docorator` object

- display_loc:

  path to save the output rtf to

- remove_unicode_ws:

  Option to remove unicode white space from text.

- use_page_header:

  If `TRUE` then all table headings will be migrated to the page header.
  See
  https://gt.rstudio.com/reference/tab_options.html#arg-page-header-use-tbl-headings

## Value

This function saves an rtf to a specified location

## Details

Option `remove_unicode_ws` serves as a workaround for this
[issue](https://github.com/rstudio/gt/issues/1437) in gt

## Examples

    gt::gtcars |>
      dplyr::slice_head(n = 10) |>
      dplyr::select(mfr, model, year, msrp) |>
      gt::gt(groupname_col = "mfr",
             row_group_as_column = TRUE) |>
      as_docorator(
       header = fancyhead(fancyrow("Header 1"), fancyrow("Header 2")),
       display_name = "mytbl") |>
     render_rtf()
