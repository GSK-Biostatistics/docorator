# Construct document footer

Define document footer through a series of `fancyrow`s. Each row
represents a new line in the footer with options for positioning text at
left, center, and/or right positions.

## Usage

``` r
fancyfoot(...)
```

## Arguments

- ...:

  Series of objects of class `fancyrow`. Each entry represents a new row
  in the document footer.

## Value

Character string containing latex code for the `fancyfoot` entries as
part of the `fancyhdr` latex framework

## Examples

``` r
fancyfoot(
 fancyrow(left = "My first footnote", right = doc_datetime())
)
#> [[1]]
#> $left
#> [1] "My first footnote"
#> 
#> $center
#> [1] NA
#> 
#> $right
#> [1] "25November2025 15:25"
#> 
#> attr(,"class")
#> [1] "fancyrow"
#> 
#> attr(,"class")
#> [1] "fancyfoot" "fancyhdr" 
```
