#' Render to docx
#'
#' @param x `docorator` object
#' @param display_loc optional path to save the output docx to
#' @param version_check Boolean indicating whether to print a note if gt or ggplot versions dont match between the original docorator object and the one being used for rendering
#'
#' @returns This function saves a docx to a specified location
#' @export
#'
#' @section Examples:
#'
#' ```r
#' gt::gtcars |>
#'   dplyr::slice_head(n = 10) |>
#'   dplyr::select(mfr, model, year, msrp) |>
#'   gt::gt(groupname_col = "mfr",
#'          row_group_as_column = TRUE) |>
#'   as_docorator(
#'    header = fancyhead(fancyrow("Header 1"), fancyrow("Header 2")),
#'    display_name = "mytbl") |>
#'  render_docx()
#' ```
#'
render_docx <- function(x, display_loc = NULL, version_check = TRUE) {
  if (!inherits(x, "docorator")) {
    cli::cli_abort(
      "The {.arg {rlang::caller_arg(x)}} argument must be class docorator, not {.obj_type_friendly {x}}. See documentation for `as_docorator`.",
      call = rlang::caller_env()
    )
  }

  # check package versions
  if (isTRUE(version_check)) {
    check_pkg_version(x)
  }

  engine = "docx"

  # initialize empty docx file
  doc <- officer::read_docx()

  # page properties
  page_margins <- officer::page_mar(
    header = 1.25,
    footer = 1.25,
    left = 1,
    right = 1,
    gutter = 0
  )

  page_size <- officer::page_size(
    orient = "landscape",
    width = 11,
    height = 8.5
  )

  section_args <- list(
    page_margins = page_margins,
    page_size = page_size
  )

  # process headers and footers
  fpar_head_list <- hf_process(x$header, engine = engine)
  fpar_foot_list <- hf_process(x$footer, engine = engine)

  if (length(fpar_head_list) > 0) {
    section_args$header_default <- do.call(officer::block_list, fpar_head_list)
  }
  if (length(fpar_foot_list) > 0) {
    section_args$footer_default <- do.call(officer::block_list, fpar_foot_list)
  }

  ps <- do.call(officer::prop_section, section_args)

  # insert the body content
  xml <- prep_obj_docx(x)

  # # ensure that xml is a list
  if (!identical(class(xml), "list")) {
    xml <- list(xml)
  }

  # for every element in the list add to the body of the document, separate by page breaks
  for (i in seq_along(xml)) {
    if (i > 1) {
      doc <- officer::body_add_break(doc, pos = "after")
    }
    xml_element <- xml[[i]]
    for (j in seq_along(xml_element)) {
      doc <- officer::body_add_xml(doc, str = xml_element[[j]])
    }
  }

  doc <- officer::body_set_default_section(doc, value = ps)

  print(doc, target = paste0(x$display_name, ".docx"))

  if (!is.null(doc)) {
    cli::cli_alert_success("Document created at: {x$display_name}.docx")
  }
}
