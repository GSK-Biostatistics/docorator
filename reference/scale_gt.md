# Scale gt table contents for document

Scale gt table contents for document

## Usage

``` r
scale_gt(x, tbl_stub_pct = 0.3)
```

## Arguments

- x:

  table of class `gt_tbl`

- tbl_stub_pct:

  percent of total width that should be dedicated to stub column(s). If
  more than 1 stub column then this is the total for both.

## Value

Table with col_widths settings applied

## Examples

``` r
gt::gtcars |>
  dplyr::slice_head(n = 10) |>
  dplyr::select(mfr, model, year, msrp, ctry_origin) |>
  gt::gt(
      groupname_col = "ctry_origin",
      rowname_col = "mfr",
      row_group_as_column = TRUE) |>
  scale_gt(tbl_stub_pct = 0.4)


  







```

model

year

msrp

United States

Ford

GT

2017

447000

Italy

Ferrari

458 Speciale

2015

291744

Ferrari

458 Spider

2015

263553

Ferrari

458 Italia

2014

233509

Ferrari

488 GTB

2016

245400

Ferrari

California

2015

198973

Ferrari

GTC4Lusso

2017

298000

Ferrari

FF

2015

295000

Ferrari

F12Berlinetta

2015

319995

Ferrari

LaFerrari

2015

1416362
