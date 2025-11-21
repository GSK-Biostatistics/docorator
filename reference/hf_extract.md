# extract header footer info from docorator object

extract header footer info from docorator object

## Usage

``` r
hf_extract(x)
```

## Arguments

- x:

  a docorator object

## Value

list of header footer info

## Examples

``` r
docorator <- gt::exibble |>
  gt::gt()|>
  as_docorator(
  display_name = "mytbl",
  header = fancyhead(
  fancyrow(left = "Protocol: 12345", right = doc_pagenum()),
  fancyrow(center = "Demographic Summary")
  ),
  footer = NULL,
  save_object = FALSE)

hf_extract(docorator)
#> $head_data
#> [1] "Demographic Summary"
#> 
#> $subhead_data
#> NULL
#> 
#> $foot_data
#> NULL
#> 
```
