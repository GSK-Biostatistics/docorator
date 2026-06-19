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
  polish::polish_content_word(x$display)
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
  gt_to_word(x$display)
}

#' @rdname prep_obj_docx
#' @export
#' @keywords internal
prep_obj_docx.gt_group <- function(x, ...) {
  # list of ooxml - one for each table in the gt_group
  lapply(x$display$gt_tbls$gt_tbl, function(i) {
    gt_to_word(i)
  })
}

#' @rdname prep_obj_docx
#' @export
#' @keywords internal
prep_obj_docx.list <- function(x, ...) {
  # TODO: handle lists of and flatten gt_groups to lists
}

#' convert gt_tbl object to ooxml
#' @noRd
gt_to_word <- function(x) {
  # replace empty mds with a string
  x <- replace_empty_md_labels(x)

  # apply options to the gt
  # Arial font
  font <- "Arial"
  x <- x |>
    gt::tab_style(
      style = gt::cell_text(font = c(font)), ## size is in half points
      locations = list(
        gt::cells_title(),
        gt::cells_column_labels(),
        gt::cells_column_spanners(),
        gt::cells_stubhead(),
        gt::cells_stub(),
        gt::cells_body(),
        gt::cells_row_groups(),
        gt::cells_footnotes()
      )
    ) |>
    gt::tab_options(
      table.font.names = c(font)
    )

  # get ooxml from gt
  ooxml <- polish::polish_content_word(
    x,
    autonum = FALSE,
    keep_with_next = FALSE
  )

  # as_word from gt returns multiple ooxml elements
  # wrap these elements together so that they can be read in as xml for officer
  paste0(
    "<tablecontainer>",
    paste0(ooxml, collapse = ""),
    "</tablecontainer>"
  ) |>
    xml2::read_xml() |>
    xml2::xml_children() |>
    suppressWarnings()
}
