# Render

``` r
library(docorator)
```

Running
[`as_docorator()`](https://GSK-Biostatistics.github.io/docorator/reference/as_docorator.md)
does not render your display - it creates a `docorator` object to store
all your display information. For rendering, an explicit call to a
render function is needed. A display can be output to PDF, RTF, or both
via a combination of the
[`render_pdf()`](https://GSK-Biostatistics.github.io/docorator/reference/render_pdf.md)
and
[`render_rtf()`](https://GSK-Biostatistics.github.io/docorator/reference/render_rtf.md)
functions.

Further, with
[`render_pdf()`](https://GSK-Biostatistics.github.io/docorator/reference/render_pdf.md),
users have a choice of R Markdown or Quarto engines via the `quarto`
option. Currently, the result is nearly identical, except for {gt}
tables, where `quarto = FALSE` renders the `gt` via the `longtable`
LaTeX library and `quarto = TRUE` via the `tabular` LaTeX library.
Please note the Quarto engine is currently experimental and can take
longer to render.

## Render to PDF

    as_docorator(
      mytbl,
      display_name = "mytbl"
    ) |> 
    render_pdf()

If you understand the underlying LaTeX involved in going from a display
object to PDF, `render_pdf` has a few arguments which could be of use.

- The `transform` argument allows you to pass a function to manipulate
  the LaTeX string of the object before it goes to PDF.
- The `header_latex` argument allows additional LaTeX to be added to the
  header-includes section of the template.Rmd used for PDF generation.
  For example, you can pass additional LaTeX libraries here. This should
  be passed as a .tex file.
- The `escape_latex` argument controls escaping for special characters
  in headers and footers. This can be set to `FALSE` to disable the
  escaping if manual escaping is preferred, i.e. if results are not as
  expected.

## Render to RTF

    as_docorator(
      mytbl,
      display_name = "mytbl"
    ) |> 
    render_rtf()

Due to the limitations of the RTF file format, some arguments specified
in your
[`as_docorator()`](https://GSK-Biostatistics.github.io/docorator/reference/as_docorator.md)
call are not preserved, such as certain formatting or table styling.
Document decoration headers are also not preserved, only titles
specified as ‘center’ will be applied.

## Multi-render

    as_docorator(
      mytbl,
      display_name = "mytbl"
    ) |>
    render_pdf() |>
    render_rtf()

Both
[`render_pdf()`](https://GSK-Biostatistics.github.io/docorator/reference/render_pdf.md)
and
[`render_rtf()`](https://GSK-Biostatistics.github.io/docorator/reference/render_rtf.md)
return the original object created with
[`as_docorator()`](https://GSK-Biostatistics.github.io/docorator/reference/as_docorator.md),
and as such, can be piped one after another as shown in the example
above.
