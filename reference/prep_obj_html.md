# Prepare table, listing, figure object for inclusion in HTML

Prepare table, listing, figure object for inclusion in HTML

## Usage

``` r
prep_obj_html(x, ...)

# Default S3 method
prep_obj_html(x, ...)

# S3 method for class 'character'
prep_obj_html(x, ...)

# S3 method for class 'gt_tbl'
prep_obj_html(x, ...)

# S3 method for class 'gg'
prep_obj_html(x, ...)

# S3 method for class 'PNG'
prep_obj_html(x, ...)

# S3 method for class 'list'
prep_obj_html(x, ...)
```

## Arguments

- x:

  docorator object containing info about the table, listing or figure

- ...:

  additional args

## Value

object to be included as html in render

## Examples

``` r
docorator <- gt::exibble |>
gt::gt() |>
as_docorator(
display_name = "mytbl", footer = NULL,
save_object = FALSE)

prepared_obj <- prep_obj_html(docorator)
```
