#' Prepare table, listing, figure object for inclusion in the template Rmd
#'
#' @param x docorator object containing info about the table, listing or figure
#'
#' @return xml to be inserted into word document
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
#' prepared_obj <- prep_obj_docx(docorator)
prep_obj_docx <- function(x, ...) {
  UseMethod("prep_obj_docx", x$display)
}

#' @rdname prep_obj_docx
#' @export
#' @keywords internal
prep_obj_docx.default <- function(x, ...) {
  xml <- polish::polish_content_word(x$display)
  xml
}

#' @rdname prep_obj_docx
#' @export
#' @keywords internal
prep_obj_docx.PNG <- function(x, ...) {
  # save the png to a temp location and then read in with as_file from polish to get the xml
  # temporarily store png
  temp <- tempfile(fileext = ".png", tmpdir = tempdir())
  png::writePNG(x$display$png, temp)
  polish::polish_content_word(polish::as_file(temp))
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
  # list of ooxml - one for each table in the gt_group
  xml <- lapply(x$display$gt_tbls$gt_tbl, function(i) {
    # new docorator object with gt_tbl as display
    gt_to_word(i)
  })
  xml
}

#' convert gt_tbl object to ooxml
#' @noRd
gt_to_word <- function(x) {
  # get ooxml from gt
  ooxml <- polish::polish_content_word(x, autonum = FALSE)

  tbl_nodes <- paste0(
    "<tablecontainer>",
    paste0(ooxml, collapse = ""),
    "</tablecontainer>"
  ) |>
    xml2::read_xml() |>
    xml2::xml_children() |>
    suppressWarnings()

  tbl_nodes
}
