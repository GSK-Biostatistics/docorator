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

  tbl_divs <- sapply(seq_len(n), function(idx) {

    tbl <- gt::grp_pull(x$display, idx)
    style <- if (idx < n) ' style="break-after: page;"' else ""
    paste0("<div", style, ">", gt::as_raw_html(tbl), "</div>")
    
  })

  paste(tbl_divs, collapse = "")
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
    }
  )

  if (!is.null(png_success)) {
    paste0('<img src="', knitr::image_uri(temp), '" style="max-width:100%;" />')
  } 
}


