# Create docorator object

Create docorator object

## Usage

``` r
as_docorator(
  x,
  display_name,
  display_loc = NULL,
  header = fancyhead(fancyrow(right = doc_pagenum())),
  footer = fancyfoot(fancyrow(left = doc_path(display_name, display_loc), right =
    doc_datetime())),
  save_object = TRUE,
  object_loc = display_loc,
  ...,
  fontsize = 10,
  geometry = geom_set(),
  fig_dim = c(5, 8),
  tbl_scale = TRUE,
  tbl_stub_pct = 0.3
)
```

## Arguments

- x:

  object containing the display. See @details for more information.

- display_name:

  required name of file (excluding extension)

- display_loc:

  optional path to save the output file to

- header:

  Document header. Accepts a `fancyhead` object. If `NULL`, no header
  will be displayed.

- footer:

  Document footer Accepts a `fancyfoot` object. If `NULL`, no footer
  will be displayed.

- save_object:

  Boolean indicating if a docorator object should be saved.

- object_loc:

  path for the docorator object - defaults to display_loc argument.

- ...:

  These dots are for future extensions and must be empty.

- fontsize:

  Font size (pt). Defaults to `10`. Accepted values: 10, 11, 12.

- geometry:

  Document sizing options based on the `geometry` latex package. Accepts
  a named list. Default is
  [`geom_set()`](https://GSK-Biostatistics.github.io/docorator/reference/geom_set.md).

- fig_dim:

  vector containing figure height and width in inches. Defaults to
  `c(5,8)`

- tbl_scale:

  Boolean for whether or not to automatically scale table columns to fit
  display area. Defaults to TRUE. Note that this will overwrite scaling
  set in the table directly unless set to FALSE.

- tbl_stub_pct:

  percent of total width that should be dedicated to stub column(s). If
  more than 1 stub column then this is the total for both.

## Value

docorator object

## Details

While the `x` argument flexibly accepts many different R objects, the
following classes/types are recommended:

- `gt`

- `gt_group` (list of `gt` objects)

- `ggplot`

- list of `ggplot`s

- path to PNG file created via
  [`png_path()`](https://GSK-Biostatistics.github.io/docorator/reference/png_path.md)

- list of paths to PNG files created via
  [`png_path()`](https://GSK-Biostatistics.github.io/docorator/reference/png_path.md)

## Examples

``` r
if (FALSE) { # \dontrun{
gt::gtcars |>
  dplyr::slice_head(n = 10) |>
  dplyr::select(mfr, model, year, msrp) |>
  gt::gt(groupname_col = "mfr",
         row_group_as_column = TRUE) |>
  as_docorator(
   header = fancyhead(fancyrow("Header 1"), fancyrow("Header 2")),
   display_name = "mytbl",
   footer = NULL)
} # }
```
