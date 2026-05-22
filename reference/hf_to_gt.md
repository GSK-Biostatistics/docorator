# Apply headers and footnotes to gt object

Pulls headers and footnotes from the docorator object and applies them
to the gt object Note: this function is only for use by downstream tools
and is not intended for general users

## Usage

``` r
hf_to_gt(x)
```

## Arguments

- x:

  a docorator object

## Value

gt object (either tbl or group)

## Examples

``` r
docorator <- gt::exibble |>
  gt::gt()|>
  as_docorator(
  display_name = "my_tbl",
  header = fancyhead(
  fancyrow(left = "Protocol: 12345", right = doc_pagenum()),
  fancyrow(center = "Demographic Summary")
  ),
  footer = NULL,
  save_object = FALSE)

hf_to_gt(docorator)


  













Demographic Summary
```
