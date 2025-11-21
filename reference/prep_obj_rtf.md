# Prepare table, listing, figure object for output to rtf

Prepare table, listing, figure object for output to rtf

## Usage

``` r
prep_obj_rtf(x, ...)

# Default S3 method
prep_obj_rtf(x, ...)

# S3 method for class 'character'
prep_obj_rtf(x, ...)

# S3 method for class 'PNG'
prep_obj_rtf(x, ...)

# S3 method for class 'ggplot'
prep_obj_rtf(x, ...)

# S3 method for class 'gt_tbl'
prep_obj_rtf(x, ...)

# S3 method for class 'gt_group'
prep_obj_rtf(x, ...)

# S3 method for class 'list'
prep_obj_rtf(x, ...)
```

## Arguments

- x:

  docorator object containing display information

- ...:

  additional args

## Value

gt object to be included as-is to render engine

## Examples

``` r
docorator <- gt::exibble |>
gt::gt() |>
as_docorator(
display_name = "my_tbl",
footer=NULL,
save_object = FALSE)

prepared_obj <- prep_obj_rtf(docorator)
```
