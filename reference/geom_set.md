# Set document geometry defaults

Set document geometry defaults

## Usage

``` r
geom_set(...)
```

## Arguments

- ...:

  Series of named value pairs for latex geometry options

## Value

Named list

## Details

Type geom_set() in console to view package defaults. Use of the function
will add to the defaults and/or override included defaults of the same
name. For values that are `NULL`, such as for `headheight` and
`footskip`, the values will be calculated automatically based on the
number of header and/or footer lines. For all geometry settings,
reference the documentation here:
https://texdoc.org/serve/geometry.pdf/0

## Examples

``` r
# view defaults
geom_set()
#> $paperheight
#> [1] "8.5in"
#> 
#> $paperwidth
#> [1] "11in"
#> 
#> $left
#> [1] "1in"
#> 
#> $right
#> [1] "1in"
#> 
#> $top
#> [1] "1.25in"
#> 
#> $bottom
#> [1] "1.25in"
#> 
#> $headsep
#> [1] "10pt"
#> 
#> $includehead
#> [1] TRUE
#> 
#> $includefoot
#> [1] TRUE
#> 
#> $headheight
#> NULL
#> 
#> $footskip
#> NULL
#> 

# Update the defaults
geom_set(left="0.5in", right="0.5in")
#> $paperheight
#> [1] "8.5in"
#> 
#> $paperwidth
#> [1] "11in"
#> 
#> $top
#> [1] "1.25in"
#> 
#> $bottom
#> [1] "1.25in"
#> 
#> $headsep
#> [1] "10pt"
#> 
#> $includehead
#> [1] TRUE
#> 
#> $includefoot
#> [1] TRUE
#> 
#> $headheight
#> NULL
#> 
#> $footskip
#> NULL
#> 
#> $left
#> [1] "0.5in"
#> 
#> $right
#> [1] "0.5in"
#> 

# add new defaults
geom_set(paper = "legalpaper")
#> $paperheight
#> [1] "8.5in"
#> 
#> $paperwidth
#> [1] "11in"
#> 
#> $left
#> [1] "1in"
#> 
#> $right
#> [1] "1in"
#> 
#> $top
#> [1] "1.25in"
#> 
#> $bottom
#> [1] "1.25in"
#> 
#> $headsep
#> [1] "10pt"
#> 
#> $includehead
#> [1] TRUE
#> 
#> $includefoot
#> [1] TRUE
#> 
#> $headheight
#> NULL
#> 
#> $footskip
#> NULL
#> 
#> $paper
#> [1] "legalpaper"
#> 
```
