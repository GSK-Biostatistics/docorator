# Prepare table, listing, figure object for inclusion in the template Rmd

Prepare table, listing, figure object for inclusion in the template Rmd

## Usage

``` r
prep_obj_tex(x, transform = NULL, ...)

# Default S3 method
prep_obj_tex(x, transform = NULL, ...)

# S3 method for class 'character'
prep_obj_tex(x, transform = NULL, ...)

# S3 method for class 'PNG'
prep_obj_tex(x, transform = NULL, ...)

# S3 method for class 'gt_tbl'
prep_obj_tex(x, transform = NULL, ...)

# S3 method for class 'gt_group'
prep_obj_tex(x, transform = NULL, ...)
```

## Arguments

- x:

  docorator object containing info about the table, listing or figure

- transform:

  optional latex transformation function to apply to a gt latex string

- ...:

  additional args

## Value

object to be included as-is in render engine

## Examples

``` r
docorator <- gt::exibble |>
gt::gt() |>
as_docorator(
display_name = "mytbl", footer = NULL,
save_object = FALSE)

prepared_obj <- prep_obj_tex(docorator)
#> \begingroup
#> \setlength\LTleft{0\linewidth}
#> \setlength\LTright{0\linewidth}\fontsize{10.0pt}{12.0pt}\selectfont
#> \begin{longtable}{@{\extracolsep{\fill}}>{\raggedleft\arraybackslash}p{\dimexpr 0.11\linewidth -2\tabcolsep-1.5\arrayrulewidth}>{\raggedright\arraybackslash}p{\dimexpr 0.11\linewidth -2\tabcolsep-1.5\arrayrulewidth}>{\centering\arraybackslash}p{\dimexpr 0.11\linewidth -2\tabcolsep-1.5\arrayrulewidth}>{\raggedleft\arraybackslash}p{\dimexpr 0.11\linewidth -2\tabcolsep-1.5\arrayrulewidth}>{\raggedleft\arraybackslash}p{\dimexpr 0.11\linewidth -2\tabcolsep-1.5\arrayrulewidth}>{\raggedleft\arraybackslash}p{\dimexpr 0.11\linewidth -2\tabcolsep-1.5\arrayrulewidth}>{\raggedleft\arraybackslash}p{\dimexpr 0.11\linewidth -2\tabcolsep-1.5\arrayrulewidth}>{\raggedright\arraybackslash}p{\dimexpr 0.11\linewidth -2\tabcolsep-1.5\arrayrulewidth}>{\raggedright\arraybackslash}p{\dimexpr 0.11\linewidth -2\tabcolsep-1.5\arrayrulewidth}}
#> \toprule
#> num & char & fctr & date & time & datetime & currency & row & group \\ 
#> \midrule\endhead\addlinespace[2.5pt]
#> 1.111e-01 & apricot & one & 2015-01-15 & 13:35 & 2018-01-01 02:22 & 49.950 & row\_1 & grp\_a \\ 
#> 2.222e+00 & banana & two & 2015-02-15 & 14:40 & 2018-02-02 14:33 & 17.950 & row\_2 & grp\_a \\ 
#> 3.333e+01 & coconut & three & 2015-03-15 & 15:45 & 2018-03-03 03:44 & 1.390 & row\_3 & grp\_a \\ 
#> 4.444e+02 & durian & four & 2015-04-15 & 16:50 & 2018-04-04 15:55 & 65100.000 & row\_4 & grp\_a \\ 
#> 5.550e+03 & NA & five & 2015-05-15 & 17:55 & 2018-05-05 04:00 & 1325.810 & row\_5 & grp\_b \\ 
#> NA & fig & six & 2015-06-15 & NA & 2018-06-06 16:11 & 13.255 & row\_6 & grp\_b \\ 
#> 7.770e+05 & grapefruit & seven & NA & 19:10 & 2018-07-07 05:22 & NA & row\_7 & grp\_b \\ 
#> 8.880e+06 & honeydew & eight & 2015-08-15 & 20:20 & NA & 0.440 & row\_8 & grp\_b \\ 
#> \bottomrule
#> \end{longtable}
#> \endgroup
```
