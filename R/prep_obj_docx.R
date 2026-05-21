#' Prepare table, listing, figure object for inclusion in the template Rmd
#'
#' @param x docorator object containing info about the table, listing or figure
#' @param doc docx object to which the content will be added
#'
#' @return object to be included as-is in render engine
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
#' prepared_obj <- prep_obj_docx(docorator, doc = read_docx())
prep_obj_docx <- function (x, ...) {
  UseMethod("prep_obj_docx", x$display)
}

#' @rdname prep_obj_docx
#' @export
#' @keywords internal
prep_obj_docx.default <- function(x, ...) {

  body_xml <- paste0(polish::polish_content_word(x$display), collapse = "")
  body_xml
}

#' @rdname prep_obj_docx
#' @export
#' @keywords internal
prep_obj_docx.character <- function(x, ...) {
  xml <- polish::polish_content_word(x$display)
  xml
}

#' @rdname prep_obj_docx
#' @export
#' @keywords internal
prep_obj_docx.PNG <- function(x, ... ) {

  if (Sys.getenv("DOCORATOR_RENDER_ENGINE")=="qmd"){
    tmpdir <- "."
  } else {
    tmpdir <- tempdir()
  }

  # temporarily store png
  temp <- tempfile(fileext = ".png", tmpdir = tmpdir)
  png::writePNG(x$display$png, temp)
  knitr::include_graphics(path = temp)
}

#' @rdname prep_obj_docx
#' @export
#' @keywords internal
prep_obj_docx.gt_tbl <- function(x, ...) {
  xml <- gt_to_word(x$display)
  xml
}

#' @rdname prep_obj_docx
#' @export
#' @keywords internal
prep_obj_docx.gt_group <- function(x, ...) {
  
  xml <- gt_to_word(x$display)
  xml
}

#' convert gt_tbl object to latex
#' @noRd
gt_to_word <- function(x){
  # get ooxml from gt
  ooxml <- polish::polish_content_word(x, autonum = FALSE)

  tbl_nodes <- paste0(
    "<tablecontainer>",
    paste0(ooxml, collapse = ""),
    "</tablecontainer>"
    ) %>%
    read_xml() %>%
    xml_children()  %>%
    suppressWarnings()

  tbl_nodes
}
