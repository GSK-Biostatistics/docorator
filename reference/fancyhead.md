# Construct document header

Define document header through a series of `fancyrow`s. Each row
represents a new line in the header with options for positioning text at
left, center, and/or right positions.

## Usage

``` r
fancyhead(...)
```

## Arguments

- ...:

  Series of objects of class `fancyrow`. Each entry represents a new row
  in the document header.

## Value

Character string containing latex code for the `fancyhead` entries as
part of the `fancyhdr` latex framework

## Examples

``` r
fancyhead(
 fancyrow(left = "Protocol: 12345", right = doc_pagenum()),
 fancyrow(center = "Demographic Summary")
)
#> [[1]]
#> $left
#> [1] "Protocol: 12345"
#> 
#> $center
#> [1] NA
#> 
#> $right
#> [1] "Page \\thepage\\ of \\pageref*{LastPage}"
#> 
#> attr(,"class")
#> [1] "fancyrow"
#> 
#> [[2]]
#> $left
#> [1] NA
#> 
#> $center
#> [1] "Demographic Summary"
#> 
#> $right
#> [1] NA
#> 
#> attr(,"class")
#> [1] "fancyrow"
#> 
#> attr(,"class")
#> [1] "fancyhead" "fancyhdr" 
```
