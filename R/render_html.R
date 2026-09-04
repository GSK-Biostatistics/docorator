#' Render to HTML
#'
#' `r lifecycle::badge("experimental")`
#'
#' @param x `docorator` object
#' @param display_loc optional path to save the output pdf to
#'
#' @returns Invisibly returns docorator object. 
#'
#' @export
#'
#' @section Examples:
#'
#' ```r
#' gt::gtcars |>
#'   dplyr::slice_head(n = 10) |>
#'   dplyr::select(mfr, model, year, msrp) |>
#'   gt::gt() |>
#'   as_docorator(
#'      display_name = "output",
#'      header = fancyhead(
#'        fancyrow(left = "Study ABC-123", right = "Draft"),
#'        fancyrow(center = "Table 1: Vehicle Summary")
#'      ),
#'      footer = fancyfoot(
#'        fancyrow(left = "Source: gtcars"),
#'        fancyrow(left = "program.R", right = format(Sys.Date(), "%d%b%Y"))
#'      )
#'   ) |> 
#'   render_html()
#' ```
#'
render_html <- function(x, display_loc = NULL) {
 
    if (!inherits(x, "docorator")) {
      cli::cli_abort(
        "The {.arg {rlang::caller_arg(x)}} argument must be class docorator, not {.obj_type_friendly {x}}. See documentation for `as_docorator`.",
        call = rlang::caller_env()
      )
    }

  # if no path is given, use docorator path
  if (is.null(display_loc)) {
    display_loc <- x$display_loc %||% "."
  }

   # set filename
  filename <- file.path(display_loc, paste0(x$display_name,".html"))
  
  # build html for contents - header, body, footer
  layout_html <- paste0(
    '<table class="page-layout">',
    '<thead><tr><td>',
    hf_process(x$header, engine = "html"),
    '</td></tr></thead>',
    '<tbody><tr><td>', 
    prep_obj_html(x) |> paste(collapse = ""), 
    '</td></tr></tbody>',
    '<tfoot><tr><td>',
    hf_process(x$footer, engine = "html"),
    '</td></tr></tfoot>',
    '</table>'
  )

  css <- system.file("www", "styles.css", package = "docorator") |>
    readLines(warn = FALSE) |>
    paste(collapse = "\n")

  fontsize_css <- paste0("body * { font-size: ", x$fontsize, "pt; }")

  htmltools::save_html(
    htmltools::tagList(
      htmltools::tags$head(htmltools::HTML(paste0(
        "<style>", css, "\n", fontsize_css, "</style>"
      ))),
      htmltools::HTML(layout_html)
    ),
    file = filename
  )


  cli::cli_alert_success("Document created at: {.path {normalizePath(filename, winslash = '/')}}")

  invisible(x)
  }