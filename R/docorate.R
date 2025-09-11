#' Decorate and output a table, listing, or figure to a file
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' This function was deprecated and replaced with `as_docorator` and a corresponding render function
#' i.e `render_pdf`
#'
#' @param x object containing the display. See @details for more information.
#' @param filename name of file including extension (note: only PDF supported currently)
#' @param path optional path to save the output pdf to
#' @param header Document header. Accepts a `fancyhead` object. If `NULL`, no header will be displayed.
#' @param footer Document footer Accepts a `fancyfoot` object. If `NULL`, no footer will be displayed.
#' @param ... These dots are for future extensions and must be empty.
#' @param fontsize Font size (pt). Defaults to `10`. Accepted values: 10, 11, 12.
#' @param geometry Document sizing options based on the `geometry` latex
#'   package. Accepts a named list. Default is `geom_set()`.
#' @param fig_dim vector containing figure height and width in inches. Defaults
#'   to `c(5,8)`
#' @param tbl_scale Boolean for whether or not to automatically scale table columns to fit display area. Defaults to TRUE. Note that this will overwrite scaling set in the table directly unless set to FALSE.
#' @param tbl_stub_pct percent of total width that should be dedicated to stub column(s). If more than 1 stub column then this is the total for both.
#'
#' @details
#' While the `x` argument flexibly accepts many different R objects, the
#' following classes/types are recommended:
#'
#'  - `gt`
#'  - `gt_group` (list of `gt` objects)
#'  - `ggplot`
#'  - list of `ggplot`s
#'  - path to PNG file created via `png_path()`
#'  - list of paths to PNG files created via `png_path()`
#'
#' @return This function is called for its side effects
#' @export
#'
#' @examples
#' \dontrun{
#' gt::gtcars |>
#'   dplyr::slice_head(n = 10) |>
#'   dplyr::select(mfr, model, year, msrp) |>
#'   gt::gt(groupname_col = "mfr",
#'          row_group_as_column = TRUE) |>
#'   docorate(
#'    header = fancyhead(fancyrow("Header 1"), fancyrow("Header 2")),
#'    filename = "mytbl.pdf")
#'  }
#'
docorate <- function(x,
                     filename = NULL,
                     path = NULL,
                     header = fancyhead(fancyrow(right = doc_pagenum())),
                     footer = fancyfoot(fancyrow(left = doc_path(filename, path),
                                                 right = doc_datetime())),
                     ...,
                     fontsize = 10,
                     geometry = geom_set(),
                     fig_dim = c(5,8),
                     tbl_scale = TRUE,
                     tbl_stub_pct = 0.3){

  lifecycle::deprecate_warn(
    when = "0.3.0",
    what = "docorate()",
    details = "Please use `as_docorator()` and the required render function, i.e `render_pdf()`",
    env = rlang::caller_env(),
    always = TRUE
  )

  as_docorator(x,
               display_name =  tools::file_path_sans_ext(filename),
               display_loc = path,
               header = header,
               footer = footer,
               save_object = FALSE,
               object_loc = path,
               ...,
               fontsize = fontsize,
               geometry = geometry,
               fig_dim = fig_dim,
               tbl_scale = tbl_scale,
               tbl_stub_pct = tbl_stub_pct) |>
    render_pdf()

}

#' Create docorator object
#'
#' @param x object containing the display. See @details for more information.
#' @param display_name name of file (excluding extension)
#' @param display_loc optional path to save the output file to
#' @param header Document header. Accepts a `fancyhead` object. If `NULL`, no header will be displayed.
#' @param footer Document footer Accepts a `fancyfoot` object. If `NULL`, no footer will be displayed.
#' @param save_object Boolean indicating if a docorator object should be saved.
#' @param object_loc path for the docorator object -  defaults to display_loc argument.
#' @param ... These dots are for future extensions and must be empty.
#' @param fontsize Font size (pt). Defaults to `10`. Accepted values: 10, 11, 12.
#' @param geometry Document sizing options based on the `geometry` latex
#'   package. Accepts a named list. Default is `geom_set()`.
#' @param fig_dim vector containing figure height and width in inches. Defaults
#'   to `c(5,8)`
#' @param tbl_scale Boolean for whether or not to automatically scale table columns to fit display area. Defaults to TRUE. Note that this will overwrite scaling set in the table directly unless set to FALSE.
#' @param tbl_stub_pct percent of total width that should be dedicated to stub column(s). If more than 1 stub column then this is the total for both.
#'
#' @details
#' While the `x` argument flexibly accepts many different R objects, the
#' following classes/types are recommended:
#'
#'  - `gt`
#'  - `gt_group` (list of `gt` objects)
#'  - `ggplot`
#'  - list of `ggplot`s
#'  - path to PNG file created via `png_path()`
#'  - list of paths to PNG files created via `png_path()`
#'
#' @return docorator object
#' @export
#'
#' @examples
#'
#' \dontrun{
#' gt::gtcars |>
#'   dplyr::slice_head(n = 10) |>
#'   dplyr::select(mfr, model, year, msrp) |>
#'   gt::gt(groupname_col = "mfr",
#'          row_group_as_column = TRUE) |>
#'   as_docorator(
#'    header = fancyhead(fancyrow("Header 1"), fancyrow("Header 2")),
#'    display_name = "mytbl",
#'    footer = NULL)
#' }
#'
as_docorator <- function(x,
                     display_name = "docorator",
                     display_loc = NULL,
                     header = fancyhead(fancyrow(right = doc_pagenum())),
                     footer = fancyfoot(fancyrow(left = doc_path(display_name, display_loc),
                                                 right = doc_datetime())),
                     save_object = TRUE,
                     object_loc = display_loc,
                     ...,
                     fontsize = 10,
                     geometry = geom_set(),
                     fig_dim = c(5,8),
                     tbl_scale = TRUE,
                     tbl_stub_pct = 0.3){

  if (inherits(header,"character")) {
    lifecycle::deprecate_warn("0.1.0",
                   what = I("Support of character vectors as input to the `header` argument of `as_docorator()`"),
                   details = "Please provide a `fancyhdr` object instead.",
                   env = rlang::caller_env())
  }

  # check inputs
  check_fancyhdr(header, chr_ok = TRUE)
  check_fancyhdr(footer)

  # notify user about any possible scaling issues
  x <- apply_scale(x, fontsize = fontsize, tbl_scale = tbl_scale, tbl_stub_pct = tbl_stub_pct)

  docorator_obj <- structure(
    list(
      display = x,
      display_name = display_name,
      display_loc = display_loc,
      header = header,
      footer = footer,
      fontsize = fontsize,
      geometry = geometry,
      fig_dim = fig_dim
    ),
    class = "docorator"
  )

  # save docorator object
  if(save_object){
    object_filename <- paste0(display_name,".RDS")
    object_loc <- file.path(object_loc, object_filename)
    saveRDS(object = docorator_obj, file = object_loc)
  }

  docorator_obj

}

