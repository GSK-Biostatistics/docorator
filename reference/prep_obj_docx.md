# Prepare table, listing, figure object for inclusion in the template Rmd

Prepare table, listing, figure object for inclusion in the template Rmd

## Usage

``` r
prep_obj_docx(x, ...)

# Default S3 method
prep_obj_docx(x, ...)

# S3 method for class 'PNG'
prep_obj_docx(x, ...)

# S3 method for class 'gt_tbl'
prep_obj_docx(x, ...)

# S3 method for class 'list'
prep_obj_docx(x, ...)
```

## Arguments

- x:

  docorator object containing info about the table, listing or figure

## Value

xml to be inserted into word document

## Examples

``` r
docorator <- gt::exibble |>
gt::gt() |>
as_docorator(
display_name = "mytbl", footer = NULL,
save_object = FALSE)

prepared_obj <- prep_obj_docx(docorator)
```
