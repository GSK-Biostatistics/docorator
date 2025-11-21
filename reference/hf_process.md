# Process headers/footers

Process headers/footers

## Usage

``` r
hf_process(x, escape_latex = TRUE)

# Default S3 method
hf_process(x, escape_latex = TRUE)

# S3 method for class 'character'
hf_process(x, escape_latex = TRUE)

# S3 method for class 'fancyhead'
hf_process(x, escape_latex = TRUE)

# S3 method for class 'fancyfoot'
hf_process(x, escape_latex = TRUE)
```

## Arguments

- x:

  header or footer

- escape_latex:

  Boolean to escape latex in header/footer

## Value

character string containing headers and footers latex code

## Examples

``` r
header <- fancyhead(
fancyrow(left = "Protocol: 12345", right = doc_pagenum()),
fancyrow(center = "Demographic Summary"))

hf_process(header)
#> [1] "\\fancyhead[L]{\\begin{tabular}[b]{@{}l@{}}Protocol: 12345\\\\\\phantom{}\\end{tabular}}\\fancyhead[C]{\\begin{tabular}[b]{@{}c@{}}\\phantom{}\\\\Demographic Summary\\end{tabular}}\\fancyhead[R]{\\begin{tabular}[b]{@{}r@{}}Page \\thepage\\ of \\pageref*{LastPage}\\\\\\phantom{}\\end{tabular}}"
```
