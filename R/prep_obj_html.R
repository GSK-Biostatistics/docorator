#' Prepare table, listing, figure object for inclusion in HTML
#'
#' @param x docorator object containing info about the table, listing or figure
#' @param ... additional args
#'
#' @return object to be included as html in render
#' @export
#' @keywords internal
#'
#' @examples
#' docorator <- gt::exibble |>
#' gt::gt() |>
#' as_docorator(
#' display_name = "mytbl", footer = NULL,
#' save_object = FALSE)
#'
#' prepared_obj <- prep_obj_html(docorator)
#' 
prep_obj_html <- function (x, ...) {
  UseMethod("prep_obj_html", x$display)
}

#' @rdname prep_obj_html
#' @export
#' @keywords internal
prep_obj_html.default <- function(x, ...) {
  x$display
}

#' @rdname prep_obj_html
#' @export
#' @keywords internal
prep_obj_html.character <- function(x, ...) {
  lines <- paste0('<p style="text-align:center;">', x$display, '</p>', collapse = "\n")
  paste0('<div style="text-align:center;">', "\n", lines, "\n", "</div>")
}

#' @rdname prep_obj_html
#' @export
#' @keywords internal
prep_obj_html.gt_tbl <- function(x, ...) {
  gt::as_raw_html(x$display) 
}

#' @rdname prep_obj_html
#' @export
#' @keywords internal
prep_obj_html.gg <- function(x, ...) {
  cli::cli_abort("ggplot objects are not supported for HTML output. Please ensure `convert_ggplot` is set to TRUE in `as_docorator()` for conversion to PNG instead.")
}

#' @rdname prep_obj_html
#' @export
#' @keywords internal
prep_obj_html.PNG <- function(x, ...) {
  # save the png to a temp location 
  temp <- tempfile(fileext = ".png", tmpdir = tempdir())
  png::writePNG(x$display$png, temp)
  img_style <- paste0("width:", x$fig_dim[2], "in;height:", x$fig_dim[1], "in;")
  img_tag <- paste0('<img src="', knitr::image_uri(temp), '" style="', img_style, '" />')
  paste0('<div style="text-align:center;">', img_tag, '</div>')
}

#' @rdname prep_obj_html
#' @export
#' @keywords internal
prep_obj_html.list <- function(x, ...){

  n <- length(x$display)

  sapply(seq_len(n), function(idx) {

    x$display <- x$display[[idx]]

    style <- if (idx < n) ' style="break-after: page;"' else ""
    paste0("<div", style, ">", prep_obj_html(x), "</div>")
  })

}