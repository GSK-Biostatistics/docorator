# Calculate desired header or footer height for the document

Calculate desired header or footer height for the document

## Usage

``` r
hf_height(x, fontsize)

# Default S3 method
hf_height(x, fontsize)

# S3 method for class 'fancyhdr'
hf_height(x, fontsize)
```

## Arguments

- x:

  header or footer

- fontsize:

  Document font size (pt)

## Value

Numeric value

## Examples

``` r
header <- fancyhead(
fancyrow(left = "Protocol: 12345", right = doc_pagenum()),
fancyrow(center = "Demographic Summary"))

hf_height(header, 10)
#> [1] 24
```
