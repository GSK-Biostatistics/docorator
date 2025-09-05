#' Prepare table, listing, figure object for output to rtf
#'
#' @param x docorator object containing display information
#' @param ... additional args
#'
#' @return gt object to be included as-is to render engine
#' @export
#' @keywords internal
#'
#' @examples
#' docorator <- gt::exibble |>
#' gt::gt() |>
#' as_docorator(footer=NULL,
#' save_object = FALSE)
#'
#' prepared_obj <- prep_obj_rtf(docorator)
prep_obj_rtf <- function (x, ...) {
  UseMethod("prep_obj_rtf", x$display)
}

#' @rdname prep_obj_rtf
#' @export
#' @keywords internal
prep_obj_rtf.default <- function(x,  ...) {
  display<- x$display
  cli::cli_abort("For RTF render the display must be class character, gt_tbl, gt_group, PNG, or ggplot, not {.obj_type_friendly {display}}.",
                   call = rlang::caller_env())
}

#' @rdname prep_obj_rtf
#' @export
#' @keywords internal
prep_obj_rtf.character <- function(x,  ...) {
  x$display <- dplyr::tibble(character = x$display) |>
    gt::gt() |>
    gt::cols_label(character = "")
  hf_to_gt(x)
}

#' @rdname prep_obj_rtf
#' @export
#' @keywords internal
prep_obj_rtf.PNG <- function(x,  ... ) {

  x$display <- png_to_gt(x)
  hf_to_gt(x)

}

#' @rdname prep_obj_rtf
#' @export
#' @keywords internal
prep_obj_rtf.ggplot <- function(x,  ... ) {
  x$display <- gg_to_gt(x)
  hf_to_gt(x)

}

#' @rdname prep_obj_rtf
#' @export
#' @keywords internal
prep_obj_rtf.gt_tbl <- function(x,  ...) {

  hf_to_gt(x)

}

#' @rdname prep_obj_rtf
#' @export
#' @keywords internal
prep_obj_rtf.gt_group <- function(x,  ...) {

  hf_to_gt(x)

}

#' @rdname prep_obj_rtf
#' @export
#' @keywords internal
prep_obj_rtf.list <- function(x,  ...) {
  prepped_list <-lapply(x$display, function(j){
    x$display <- j
    prep_obj_rtf(x)
  })

  gt::gt_group(.list = prepped_list)

}
