# Construct document header row

Define a single row in the document header/footer. Each row represents a
single line of text, with options for positioning text at left, center,
and/or right.

## Usage

``` r
fancyrow(left = NA, center = NA, right = NA)
```

## Arguments

- left:

  Character string to be aligned to the left side of the row.

- center:

  Character string to be aligned to the center of the row.

- right:

  Character string to be aligned to the right side of the row.

## Value

Object of class `fancyrow`

## Examples

``` r
fancyrow(left = "Left most text", right = "Right most text")
#> $left
#> [1] "Left most text"
#> 
#> $center
#> [1] NA
#> 
#> $right
#> [1] "Right most text"
#> 
#> attr(,"class")
#> [1] "fancyrow"

fancyrow(center = "Just text in the center")
#> $left
#> [1] NA
#> 
#> $center
#> [1] "Just text in the center"
#> 
#> $right
#> [1] NA
#> 
#> attr(,"class")
#> [1] "fancyrow"

fancyrow(left = "All", center = "Three", right = "Positions filled")
#> $left
#> [1] "All"
#> 
#> $center
#> [1] "Three"
#> 
#> $right
#> [1] "Positions filled"
#> 
#> attr(,"class")
#> [1] "fancyrow"
```
