# Apply scaling to gt objects

Apply scaling to gt objects

## Usage

``` r
apply_scale(x, fontsize, tbl_scale, tbl_stub_pct)

# Default S3 method
apply_scale(x, fontsize, tbl_scale, tbl_stub_pct)

# S3 method for class 'gt_tbl'
apply_scale(x, fontsize, tbl_scale, tbl_stub_pct)

# S3 method for class 'gt_group'
apply_scale(x, fontsize, tbl_scale, tbl_stub_pct)

# S3 method for class 'list'
apply_scale(x, fontsize, tbl_scale, tbl_stub_pct)
```

## Arguments

- x:

  gt object

- fontsize:

  document font size

- tbl_scale:

  Boolean for whether or not to automatically scale table columns to fit
  display area. Defaults to TRUE. Note that this will overwrite scaling
  set in the table directly unless set to FALSE.

- tbl_stub_pct:

  percent of total width that should be dedicated to stub column(s). If
  more than 1 stub column then this is the total for both.

## Value

scaled gt object

## Examples

``` r
gt <- gt::exibble |>
gt::gt()

apply_scale(gt, fontsize = 10, tbl_scale = FALSE, tbl_stub_pct = "20%")


  

num
```
