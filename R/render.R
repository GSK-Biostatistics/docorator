#' Render to pdf
#'
#' @param x `docorator` object
#' @param display_loc optional path to save the output pdf to
#' @param transform optional latex transformation function to apply to a gt latex string
#' @param header_latex optional .tex file of header latex
#' @param keep_tex Boolean indicating if to keep resulting .tex file from latex conversion. Defaults to FALSE.
#' @param escape_latex Boolean indicating if headers and footers of a gt table should be escaped with gt::escape_latex
#' @param quarto Boolean indicating whether to use Quarto as the rendering
#' @param version_check Boolean indicating whether to print a note if gt or ggplot versions dont match between the original docorator object and the one being used for rendering
#'   engine. Defaults to `FALSE`, which uses Rmarkdown to render. `r lifecycle::badge("experimental")`
#'
#' @returns This function saves a pdf to a specified location
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
#'  render_pdf()
#' ```
#'
render_pdf <- function(x,
                       display_loc = NULL,
                       transform = NULL,
                       header_latex = NULL,
                       keep_tex = FALSE,
                       escape_latex = TRUE,
                       quarto = FALSE,
                       version_check = TRUE){

  if (!inherits(x, "docorator")) {
    cli::cli_abort("The {.arg {rlang::caller_arg(x)}} argument must be class docorator, not {.obj_type_friendly {x}}. See documentation for `as_docorator`.",
              call = rlang::caller_env())
  }

  # check package versions
  if(isTRUE(version_check)){
    check_pkg_version(x)
  }

  # check transform is a function if not convert to NULL
  if (!is.null(transform) & !inherits(transform, "function")) {
    cli::cli_warn("The transform argument must be a function, not {.obj_type_friendly {transform}}. No transform applied.",
             call = rlang::caller_env())
    transform <- NULL
  }

  # copy template rmd to a temp directory
  template <- system.file("template", package = "docorator")
  temp_dir <- tempdir()
  file.copy(template, temp_dir, overwrite = TRUE, recursive = TRUE)
  template_folder <- file.path(temp_dir,"template")

  # copy tex header to temp directory and rename if one exists
  if(!is.null(header_latex)){
    if(file.exists(header_latex) && tools::file_ext(header_latex) == "tex"){
      file_name <- basename(header_latex)
      file.copy(header_latex, template_folder, overwrite = TRUE, recursive = TRUE)
      file.rename(file.path(template_folder, file_name),file.path(template_folder,"header.tex"))
    }else{
      cli::cli_warn("The header_latex argument must point to a valid .tex file. No header options applied.",
               call = rlang::caller_env())
    }
  }

  # if no path is given, use docorator path
  if(is.null(display_loc)){
    display_loc <- x$display_loc %||% "."
  }

  # set filename
  filename <- paste0(x$display_name,".pdf")

  if(quarto){
    withr::with_envvar(
      new = c("DOCORATOR_RENDER_ENGINE" = "qmd"),
      render_pdf_qmd(x, display_loc, transform, header_latex, clean=!keep_tex)
    )
  } else {

    # render rmd -> pdf
    doc <- rmarkdown::render(file.path(temp_dir, "template", "template.Rmd"),
                             output_file = filename,
                             output_dir = display_loc,
                             output_options = list(keep_tex = keep_tex),
                             params = list(x = x,
                                           header = hf_process(x$header, escape_latex = escape_latex),
                                           footer = hf_process(x$footer, escape_latex = escape_latex),
                                           geometry = geom_process(
                                             x$header,
                                             x$footer,
                                             x$fontsize,
                                             x$geometry
                                           ),
                                           transform = transform
                             ),
                             quiet = TRUE)

    if (!is.null(doc)){
      cli::cli_alert_success("Document created at: {doc}")
    }

    # clean up temp files
    unlink(file.path(temp_dir, "template"), recursive = TRUE)

    # return docorator object for further renders
    invisible(x)
  }
}


#' Render to rtf
#'
#' `r lifecycle::badge('experimental')`
#'
#' @param x `docorator` object
#' @param display_loc path to save the output rtf to
#' @param remove_unicode_ws Option to remove unicode white space from text.
#' @param use_page_header If `TRUE` then all table headings will be migrated to the page header. See https://gt.rstudio.com/reference/tab_options.html#arg-page-header-use-tbl-headings
#' @param version_check Boolean indicating whether to print a note if gt or ggplot versions dont match between the original docorator object and the one being used for rendering
#'   engine. Defaults to `FALSE`, which uses Rmarkdown to render. `r lifecycle::badge("experimental")`
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
render_rtf <- function(x, display_loc = NULL, remove_unicode_ws = TRUE, use_page_header = FALSE, version_check = TRUE){

  if (!inherits(x, "docorator")) {
    cli::cli_abort("The {.arg {rlang::caller_arg(x)}} argument must be class docorator, not {.obj_type_friendly {x}}. See documentation for `as_docorator`.",
              call = rlang::caller_env())
  }

  # check package versions
  if(isTRUE(version_check)){
    check_pkg_version(x)
  }

  # if version of gt is <= 1.0.0
  if(!inherits(x$display, "gt_tbl") & !inherits(x$display, "gt_group") & utils::compareVersion(as.character(utils::packageVersion("gt")), "1.0.0")>0) {
    cli::cli_warn("RTF render is only enabled for objects of class `gt_tbl` or `gt_group`, not {.obj_type_friendly {x$display}}. See documentation for `render_rtf`.",
              call = rlang::caller_env())
  }

  # if no path is given, use docorator path
  if(is.null(display_loc)){
    display_loc <- x$display_loc %||% "."
  }

  # set name
  filename <- paste0(x$display_name,".rtf")

  # convert outputs to gt for rtf render
  gt <- prep_obj_rtf(x)

  # page headers
  gt <- apply_to_grp(
    gt::tab_options,
    list(
      data = gt,
      page.numbering = FALSE,
      page.header.use_tbl_headings = use_page_header
    )
  )

  # render rtf
  doc <- gt::gtsave(gt,
                filename = filename,
                path = display_loc)

  if (!is.null(doc)){

    if (remove_unicode_ws){
      doc_tmp <- readLines(doc)

      doc_tmp_new <- gsub("\u00A0", " ", doc_tmp, perl = TRUE)

      writeLines(
        doc_tmp_new,
        sep = "\n",
        file.path(display_loc, filename)
      )
    }
    cli::cli_alert_success("Document created at: {normalizePath(doc, winslash = \"/\")}")
  }

  # return docorator object for further renders
  invisible(x)

}


#' Render to pdf (quarto)
#'
#' @param x `docorator` object
#' @param display_loc path to save the output pdf to
#' @param transform optional latex transformation function to apply to a gt latex string
#' @param header_latex optional .tex file of header latex
#' @param clean whether to clean the temporary docorator files. Defaults to `TRUE`
#'
#' @returns This function saves a pdf to a specified location
#' @noRd
render_pdf_qmd <- function(x,
                           display_loc = NULL,
                           transform = NULL,
                           header_latex = NULL,
                           clean = TRUE){

  if (!is.null(transform)) {
    cli::cli_warn("The {.arg {rlang::caller_arg(transform)}} argument is not currently available for quarto rendered documents. Try `quarto = FALSE`",
                  call = rlang::caller_env())
  }

  # create a full path
  if (!is.null(display_loc)){
    display_loc <- normalizePath(display_loc, winslash = "/")
  }

  qmd_name <- paste0(x$display_name,".qmd")
  pdf_name <- paste0(x$display_name, ".pdf")
  docorator_name <- paste0(x$display_name, "_docorator_obj.Rds")

  if (!is.null(display_loc)){
    render_dir <- file.path(display_loc, paste0(x$display_name, "_docorator_files"))
  } else {
    render_dir <- file.path(paste0(x$display_name, "_docorator_files"))
  }
  if(!dir.exists(render_dir)){
    dir.create(render_dir)
  }

  on.exit({
    if(isTRUE(clean)){
      unlink(render_dir, recursive = TRUE)
    }
  },
  add = TRUE)

  withr::with_dir(
    new = render_dir,
    code = {
      # copy template qmd to the render dir
      template <- system.file("template", "template.qmd", package = "docorator")
      file.copy(template, ".", overwrite = TRUE, recursive = TRUE)
      file.rename("template.qmd", qmd_name)

      # copy tex header to render dir and rename if one exists
      if(!is.null(header_latex)){
        if(file.exists(header_latex) && tools::file_ext(header_latex) == "tex"){
          file_name <- basename(header_latex)
          file.copy(header_latex, ".", overwrite = TRUE, recursive = TRUE)
          file.rename(file_name, "header.tex")
        }else{
          cli::cli_warn("The header_latex argument must point to a valid .tex file. No header options applied.",
                        call = rlang::caller_env())
        }
      }

      # save docorator obj to render dir
      saveRDS(x, docorator_name)

      # render pdf
      doc <-
        quarto::quarto_render(
          input = qmd_name,
          output_format = "pdf",
          output_file = pdf_name,
          execute_params = list(
            display_name = x$display_name,
            pkg_path = "", #set to cur_dir in development
            transform = NULL # disabled for quarto
          ),
          quiet = TRUE)
    })

  if (file.exists(file.path(render_dir, pdf_name))){
    if (!is.null(display_loc)){
      out_path <- file.path(display_loc, pdf_name)
    } else {
      out_path <- pdf_name
    }
    file_ok <- file.copy(from = file.path(render_dir, pdf_name),
                         to = out_path,
                         overwrite = TRUE)

    if (file_ok){
      cli::cli_alert_success("Document created at: {out_path}")
    }
  }

  # return docorator object for further renders
  invisible(x)
}
