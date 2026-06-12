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
prep_obj_html.gt_tbl <- function(x, ...) {
  gt::as_raw_html(x$display) 
}

#' @rdname prep_obj_html
#' @export
#' @keywords internal
prep_obj_html.gt_group <- function(x, ...) {

  n <- nrow(x$display$gt_tbls)

  sapply(seq_len(n), function(idx) {

    tbl <- gt::grp_pull(x$display, idx)
    style <- if (idx < n) ' style="break-after: page;"' else ""
    paste0("<div", style, ">", gt::as_raw_html(tbl), "</div>")
    
  })
}

#' @rdname prep_obj_html
#' @export
#' @keywords internal
prep_obj_html.gg <- function(x, ...) {

  temp <- tempfile(fileext = ".png", tmpdir = tempdir())

  png_success <- tryCatch(
    ggplot2::ggsave(temp, plot = x$display, device = "png"),
    error = function(e) {
      stop("Failed to create PNG: ", e$message)
    }
  )

  if (!is.null(png_success)) {
    paste0('<img src="', knitr::image_uri(temp), '" style="max-width:100%;" />')
  } 
}

#' @rdname prep_obj_html
#' @export
#' @keywords internal
prep_obj_html.PNG <- function(x, ...) {
  # save the png to a temp location 
  temp <- tempfile(fileext = ".png", tmpdir = tempdir())
  png::writePNG(x$display$png, temp)
  paste0('<img src="', knitr::image_uri(temp), '" style="max-width:100%;" />')

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

  #TODO figure out why this is not resulting in page breaks in pdf

}

