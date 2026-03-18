# Create code chunks

Create code chunks

## Usage

``` r
create_chunks_all(x, transform)
```

## Arguments

- x:

  docorator object

- transform:

  optional latex transformation function to apply to a gt latex string

## Value

printed code chunk(s) to be included as-is in the render engine

## Examples

``` r
if (FALSE) { # \dontrun{
docorator <- gt::exibble |>
  gt::gt() |>
  as_docorator(save_object = FALSE)
create_chunks_all(docorator, transform = NULL)
} # }
```
