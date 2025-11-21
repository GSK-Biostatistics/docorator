# Display Sizing

``` r
library(docorator)
```

## Table sizing

Users can take advantage of {docorator}’s built-in scaling or opt to
instead specify column widths via {gt}. Both techniques are described
below.

### Dynamic scaling

For {tfrmt} and {gt} tables, {docorator} will make its best attempt to
fit the display to the allotted area. Specifically, using the default
setting of `tbl_scale = TRUE` will adjust all of the columns to fit the
allotted display. This option will first size the stub column(s)
(i.e. those columns on the left-hand side containing row group/label
information) according to `tbl_stub_pct` option, then make the remaining
columns equal width.

{docorator} uses the function
[`scale_gt()`](https://GSK-Biostatistics.github.io/docorator/reference/scale_gt.md)
to apply table sizing under the hood. There is no need to call this
function directly for the pdf creation but it is used to illustrate the
examples below.

Let’s say we have a table with 1 stub column and 4 other columns, like
so:

``` r
library(gt)
mytbl <- gtcars |>
   dplyr::slice_head(n = 10) |>
   dplyr::select(mfr, model, year, msrp, ctry_origin) |>
   gt(rowname_col = "mfr") |>
   tab_style(
     style = cell_borders(c("left","right")),
     locations = list(cells_body(), cells_stub(), cells_column_labels())
   )

mytbl
```

|         | model         | year | msrp    | ctry_origin   |
|---------|---------------|------|---------|---------------|
| Ford    | GT            | 2017 | 447000  | United States |
| Ferrari | 458 Speciale  | 2015 | 291744  | Italy         |
| Ferrari | 458 Spider    | 2015 | 263553  | Italy         |
| Ferrari | 458 Italia    | 2014 | 233509  | Italy         |
| Ferrari | 488 GTB       | 2016 | 245400  | Italy         |
| Ferrari | California    | 2015 | 198973  | Italy         |
| Ferrari | GTC4Lusso     | 2017 | 298000  | Italy         |
| Ferrari | FF            | 2015 | 295000  | Italy         |
| Ferrari | F12Berlinetta | 2015 | 319995  | Italy         |
| Ferrari | LaFerrari     | 2015 | 1416362 | Italy         |

If we set `tbl_stub_pct=0.4`, the stub column will occupy 40% of the
full width, and the 4 data columns will each occupy 15% of the full
width, totaling 100% width.

``` r
mytbl |>
  scale_gt(tbl_stub_pct = 0.4)
```

|         | model         | year | msrp    | ctry_origin   |
|---------|---------------|------|---------|---------------|
| Ford    | GT            | 2017 | 447000  | United States |
| Ferrari | 458 Speciale  | 2015 | 291744  | Italy         |
| Ferrari | 458 Spider    | 2015 | 263553  | Italy         |
| Ferrari | 458 Italia    | 2014 | 233509  | Italy         |
| Ferrari | 488 GTB       | 2016 | 245400  | Italy         |
| Ferrari | California    | 2015 | 198973  | Italy         |
| Ferrari | GTC4Lusso     | 2017 | 298000  | Italy         |
| Ferrari | FF            | 2015 | 295000  | Italy         |
| Ferrari | F12Berlinetta | 2015 | 319995  | Italy         |
| Ferrari | LaFerrari     | 2015 | 1416362 | Italy         |

For a table with 2 stub columns, like the one below, settings
`tbl_stub_pct=0.4` will result 20% width for each stub column, resulting
in 40% total for both stubs.

``` r
mytbl <- gtcars |>
   dplyr::slice_head(n = 10) |>
   dplyr::select(mfr, model, year, msrp, ctry_origin) |>
   gt(
      groupname_col = "ctry_origin", 
      rowname_col = "mfr",
      row_group_as_column = TRUE) |>
   tab_style(
     style = cell_borders(c("left","right")),
     locations = list(cells_body(), cells_stub(), cells_column_labels())
   )

mytbl
```

|               |         | model         | year | msrp    |
|---------------|---------|---------------|------|---------|
| United States | Ford    | GT            | 2017 | 447000  |
| Italy         | Ferrari | 458 Speciale  | 2015 | 291744  |
|               | Ferrari | 458 Spider    | 2015 | 263553  |
|               | Ferrari | 458 Italia    | 2014 | 233509  |
|               | Ferrari | 488 GTB       | 2016 | 245400  |
|               | Ferrari | California    | 2015 | 198973  |
|               | Ferrari | GTC4Lusso     | 2017 | 298000  |
|               | Ferrari | FF            | 2015 | 295000  |
|               | Ferrari | F12Berlinetta | 2015 | 319995  |
|               | Ferrari | LaFerrari     | 2015 | 1416362 |

``` r
mytbl |>
  scale_gt(tbl_stub_pct = 0.4)
```

|               |         | model         | year | msrp    |
|---------------|---------|---------------|------|---------|
| United States | Ford    | GT            | 2017 | 447000  |
| Italy         | Ferrari | 458 Speciale  | 2015 | 291744  |
|               | Ferrari | 458 Spider    | 2015 | 263553  |
|               | Ferrari | 458 Italia    | 2014 | 233509  |
|               | Ferrari | 488 GTB       | 2016 | 245400  |
|               | Ferrari | California    | 2015 | 198973  |
|               | Ferrari | GTC4Lusso     | 2017 | 298000  |
|               | Ferrari | FF            | 2015 | 295000  |
|               | Ferrari | F12Berlinetta | 2015 | 319995  |
|               | Ferrari | LaFerrari     | 2015 | 1416362 |

### Manual scaling

For full control over column widths, it is recommended to use
[`gt::cols_width()`](https://gt.rstudio.com/reference/cols_width.html)
on the table prior to {docorator}. By default, {docorator}’s dynamic
scaling will override these widths, so it is important to set
`tbl_scale = FALSE`. Note: only widths specified in % (i.e using either
“5%” or pct(5)) are accepted. If widths are specified in px then a
warning will be issued and dynamic scaling will apply. Widths should
also total no more than 100%.

If only a subset of the columns are covered in the
[`cols_width()`](https://gt.rstudio.com/reference/cols_width.html),
{docorator} will expand the remaining columns to fit the allotted width
of the display area.

``` r
mytbl |> 
  gt::cols_width(
    msrp ~ pct(50)
  ) |> 
  as_docorator(tbl_scale = FALSE)
```

Alternatively, if all columns are covered in the
[`cols_width()`](https://gt.rstudio.com/reference/cols_width.html),
{docorator} will not apply *any* resizing to fit the allotted area.

``` r
mytbl |> 
  gt::cols_width(
    ctry_origin ~ pct(15),
    mfr ~ pct(10),
    model ~ pct(7),
    year ~ pct(9),
    msrp ~ pct(15)
  ) |> 
  as_docorator(tbl_scale = FALSE)
```

## Figure sizing

Figure sizes can be adjusted via the `fig_dim` argument of
[`as_docorator()`](https://GSK-Biostatistics.github.io/docorator/reference/as_docorator.md).
This argument expects a numeric vector of length 2, where the first and
second elements are the height and width in inches, respectively. For
example, the default `c(5,8)` translates to a height of 5 inches and
width of 8 inches.

## Future developments

More customization options will be offered in future releases. If you
have a need to customize something that is not currently offered, please
file an [issue](https://github.com/GSK-Biostatistics/docorator/issues).
