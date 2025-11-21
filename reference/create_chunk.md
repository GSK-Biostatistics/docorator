# Create prep_obj_tex code chunks Taken from https://gist.github.com/MichaelJW/b4a3dd999a47b137d12f42a8f7562b11

Create prep_obj_tex code chunks Taken from
https://gist.github.com/MichaelJW/b4a3dd999a47b137d12f42a8f7562b11

## Usage

``` r
create_chunk(x, transform)
```

## Arguments

- x:

  docorator object

- transform:

  optional latex transformation function to apply to a gt latex string

## Value

printed code chunk to be included as-is in the render engine

## Examples

``` r
if (FALSE) { # \dontrun{
docorator <- gt::exibble |>
  gt::gt() |>
  as_docorator(save_object = FALSE)
create_chunk(docorator, transform = NULL)
} # }
```
