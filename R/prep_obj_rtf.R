
#' Prepare table, listing, figure object for output to rtf
#'
#' @param x docorator object containing display information
#' @param ... additional args
#'
#' @return object to be included as-is render engine
#' @export
#' @keywords internal
prep_obj_rtf <- function (x, ...) {
  UseMethod("prep_obj_rtf", x$display)
}

#' default
#' @export
#' @keywords internal
prep_obj_rtf.default <- function(x,  ...) {
  display<- x$display
  cli::cli_abort("For RTF render the display must be class character, gt_tbl, gt_group, PNG, or ggplot, not {.obj_type_friendly {display}}.",
                   call = rlang::caller_env())
}

#' prep object that is a character string (presumably latex code)
#' @export
#' @keywords internal
prep_obj_rtf.character <- function(x,  ...) {
  dplyr::tibble(character = x) |>
    gt::gt() |>
    gt::cols_label(character = "")
}

#' prep object that is a path to a PNG
#' @export
#' @keywords internal
prep_obj_rtf.PNG <- function(x,  ... ) {

  x$display <- png_to_gt(x)
  hf_to_gt(x)

}

#' prep ggplot object
#' @export
#' @keywords internal
prep_obj_rtf.ggplot <- function(x,  ... ) {
  x$display <- gg_to_gt(x)
  hf_to_gt(x)

}

#' prep gt_tbl object
#' @export
#' @keywords internal
prep_obj_rtf.gt_tbl <- function(x,  ...) {

  hf_to_gt(x)

}

#' prep gt_group object
#' @export
#' @keywords internal
prep_obj_rtf.gt_group <- function(x,  ...) {

  hf_to_gt(x)

}

#' prep list object
#' @export
#' @keywords internal
prep_obj_rtf.list <- function(x,  ...) {
  prepped_list <-lapply(x$display, function(j){
    x$display <- j
    prep_obj_rtf(x)
  })

  gt::gt_group(.list = prepped_list)

}
