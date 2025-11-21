# Document Sizing

``` r
library(docorator)
```

Document-level sizing can be customized via the `geometry` argument.
This argument accepts a named list of options that are used by the
underlying [`geometry`](https://texdoc.org/serve/geometry.pdf/0) latex
package.

## Default sizing options

The default for the `geometry` package is
[`geom_set()`](https://GSK-Biostatistics.github.io/docorator/reference/geom_set.md),
which includes the following settings:

``` r
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
```

Users can optionally override any defaults by passing new values as
such:

``` r
geom_set(top = "0.5in", bottom = "0.5in")
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
#> $top
#> [1] "0.5in"
#> 
#> $bottom
#> [1] "0.5in"
```

For values set to `NULL`, {docorator} will perform automatic size
calculations. These can be overridden by hardcoded size values.

``` r
geom_set(headheight = "20pt")
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
#> $footskip
#> NULL
#> 
#> $headheight
#> [1] "20pt"
```

## Advanced use

Advanced users can pass additional geometry settings/values that are not
covered by the defaults. These additional settings will be appended to
the default list. Reference the `geometry` documentation for more
information: <https://texdoc.org/serve/geometry.pdf/0>.
