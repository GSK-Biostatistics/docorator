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

  # TODO figure out how to display this properly in the scrollable container
  sapply(seq_len(nrow(x$display$gt_tbls)), function(idx) {
    tbl <- gt::grp_pull(x$display, idx)

    gt::as_raw_html(tbl) 
  })  
}

#' @rdname prep_obj_html
#' @export
#' @keywords internal
prep_obj_html.gg <- function(x, ...) {
  temp <- tempfile(fileext = ".png")
  on.exit(unlink(temp), add = TRUE)

  png_success <- tryCatch(
    ggplot2::ggsave(temp, plot = x$display, device = "png"),
    error = function(e) {
      stop("Failed to create PNG: ", e$message)
      return(NULL)
    }
  )

  if (!is.null(png_success)) {
    paste0('<img src="', knitr::image_uri(temp), '" style="max-width:100%;" />')
  } else {
    NULL
  }
}


