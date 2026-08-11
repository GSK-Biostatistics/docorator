#' Render to rtf
#'
#' `r lifecycle::badge('experimental')`
#'
#' @param x `docorator` object
#' @param display_loc path to save the output rtf to
#' @param remove_unicode_ws Option to remove unicode white space from text.
#' @param use_page_header If `TRUE` then all table headings will be migrated to the page header. See https://gt.rstudio.com/reference/tab_options.html#arg-page-header-use-tbl-headings
#' @param version_check Boolean indicating whether to print a note if gt or ggplot versions dont match between the original docorator object and the one being used for rendering
#'
#' @details Option `remove_unicode_ws` serves as a workaround for this
#'   [issue](https://github.com/rstudio/gt/issues/1437) in gt
#'
#' @returns This function saves an rtf to a specified location
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
#'  render_rtf()
#' ```
#'
render_rtf <- function(
  x,
  display_loc = NULL,
  remove_unicode_ws = TRUE,
  use_page_header = FALSE,
  version_check = TRUE
) {
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

  # if no path is given, use docorator path
  if (is.null(display_loc)) {
    display_loc <- x$display_loc %||% "."
  }

  # set name
  filename <- paste0(x$display_name, ".rtf")

  # convert outputs to gt for rtf render
  gt <- prep_obj_rtf(x)

  # page headers
  gt <- apply_to_gt_group(
    gt,
    gt::tab_options,
    list(
      page.numbering = FALSE,
      page.header.use_tbl_headings = use_page_header
    )
  )

  # render rtf
  doc <- gt::gtsave(gt, filename = filename, path = display_loc)

  if (!is.null(doc)) {
    if (remove_unicode_ws) {
      doc_tmp <- readLines(doc)

      doc_tmp_new <- gsub("\u00A0", " ", doc_tmp, perl = TRUE)

      writeLines(
        doc_tmp_new,
        sep = "\n",
        file.path(display_loc, filename)
      )
    }
    cli::cli_alert_success(
      "Document created at: {normalizePath(doc, winslash = \"/\")}"
    )
  }

  # return docorator object for further renders
  invisible(x)
}