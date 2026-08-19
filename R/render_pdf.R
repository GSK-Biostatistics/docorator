#' Render to pdf
#'
#' @param x `docorator` object
#' @param display_loc optional path to save the output pdf to
#' @param engine character vector of rendering engines to use. Options are "latex" (default) and "html".
#' @param version_check Boolean indicating whether to print a note if gt or ggplot versions dont match between the original docorator object and the one being used for rendering
#' @param fancywrap Boolean indicating if headers and footers should be split to fit the page. Defaults to `TRUE`. Note that only fancyrows with one `left`, `right` OR `center` element will be wrapped. `r lifecycle::badge("experimental")`
#' @param ... Additional arguments passed to the engine-specific render function.
#'
#'   For `engine = "latex"`, see [render_pdf_latex()] for supported arguments.
#'   For `engine = "html"`, see [render_pdf_html()] for supported arguments.
#'
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
render_pdf <- function(
  x,
  display_loc = NULL,
  engine = c("latex", "html"),
  version_check = TRUE,
  fancywrap = TRUE,
  ...
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

  if (isTRUE(fancywrap)) {
    x <- fancywrap(x)
  }

  # get the pdf engine and switch to the appropriate render function
  engine <- match.arg(engine, c("latex", "html"))

  switch(
    engine,
    latex = render_pdf_latex(
      x,
      display_loc = display_loc,
      ...
    ),
    html = render_pdf_html(
      x,
      display_loc = display_loc,
      ...
    )
  )

}

#' Render to pdf (LaTeX)
#'
#' @param x `docorator` object
#' @param display_loc optional path to save the output pdf to
#' @param transform optional latex transformation function to apply to a gt latex string - valid for latex engine only
#' @param header_latex optional .tex file of header latex - valid for latex engine only
#' @param keep_tex Boolean indicating if to keep resulting .tex file from latex conversion. Defaults to FALSE. - valid for latex engine only
#' @param escape_latex Boolean indicating if headers and footers of a gt table should be escaped with gt::escape_latex - valid for latex engine only
#' @param quarto Boolean indicating whether to use Quarto as the rendering engine. Defaults to `FALSE`, which uses Rmarkdown to render. `r lifecycle::badge("deprecated")`
#'
#'
#' @returns This function saves a pdf to a specified location
#' @keywords internal
#' @section Examples:
#' ```r
#' gt::gtcars |>
#'   dplyr::slice_head(n = 10) |>
#'   dplyr::select(mfr, model, year, msrp) |>
#'   gt::gt(groupname_col = "mfr",
#'          row_group_as_column = TRUE) |>
#'   as_docorator(
#'    header = fancyhead(fancyrow("Header 1"), fancyrow("Header 2")),
#'    display_name = "mytbl") |>
#'  render_pdf(engine = "latex")
#' ```
#'
render_pdf_latex <- function(
  x,
  display_loc = NULL,
  transform = NULL,
  header_latex = NULL,
  keep_tex = FALSE,
  escape_latex = TRUE,
  quarto = lifecycle::deprecated()
) {

  # check transform is a function if not convert to NULL
  if (!is.null(transform) & !inherits(transform, "function")) {
    cli::cli_warn(
      "The transform argument must be a function, not {.obj_type_friendly {transform}}. No transform applied.",
      call = rlang::caller_env()
    )
    transform <- NULL
  }

  # copy template rmd to a temp directory
  template <- system.file("template", package = "docorator")
  temp_dir <- tempdir()
  file.copy(template, temp_dir, overwrite = TRUE, recursive = TRUE)
  template_folder <- file.path(temp_dir, "template")

  # copy tex header to temp directory and rename if one exists
  if (!is.null(header_latex)) {
    if (file.exists(header_latex) && tools::file_ext(header_latex) == "tex") {
      file_name <- basename(header_latex)
      file.copy(
        header_latex,
        template_folder,
        overwrite = TRUE,
        recursive = TRUE
      )
      file.rename(
        file.path(template_folder, file_name),
        file.path(template_folder, "header.tex")
      )
    } else {
      cli::cli_warn(
        "The header_latex argument must point to a valid .tex file. No header options applied.",
        call = rlang::caller_env()
      )
    }
  }

  # if no path is given, use docorator path
  if (is.null(display_loc)) {
    display_loc <- x$display_loc %||% "."
  }

  # set filename
  filename <- paste0(x$display_name, ".pdf")
  
  if (lifecycle::is_present(quarto)) {
    lifecycle::deprecate_warn("0.7.1", "render_pdf(quarto = )", "render_pdf(engine = )")
    withr::with_envvar(
      new = c("DOCORATOR_RENDER_ENGINE" = "qmd"),
      render_pdf_qmd(x, display_loc, transform, header_latex, clean = !keep_tex)
    )
  } else {
    # render rmd -> pdf
    doc <- rmarkdown::render(
      file.path(temp_dir, "template", "template.Rmd"),
      output_file = filename,
      output_dir = display_loc,
      output_options = list(keep_tex = keep_tex),
      params = list(
        x = x,
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
      quiet = TRUE
    )

    if (!is.null(doc)) {
      cli::cli_alert_success("Document created at: {doc}")
    }

    # clean up temp files
    unlink(file.path(temp_dir, "template"), recursive = TRUE)

    # return docorator object for further renders
    invisible(x)
  }
}

#' Render to pdf (quarto)
#' 
#' `r lifecycle::badge("deprecated")`
#' 
#' @param x `docorator` object
#' @param display_loc path to save the output pdf to
#' @param transform optional latex transformation function to apply to a gt latex string
#' @param header_latex optional .tex file of header latex
#' @param clean whether to clean the temporary docorator files. Defaults to `TRUE`
#'
#' @returns This function saves a pdf to a specified location
#' @noRd
render_pdf_qmd <- function(
  x,
  display_loc = NULL,
  transform = NULL,
  header_latex = NULL,
  clean = TRUE
) {
  lifecycle::deprecate_warn("0.7.1", "render_pdf_qmd()", "render_pdf()")

  if (!is.null(transform)) {
    cli::cli_warn(
      "The {.arg {rlang::caller_arg(transform)}} argument is not currently available for quarto rendered documents. Try `quarto = FALSE`",
      call = rlang::caller_env()
    )
  }

  # create a full path
  if (!is.null(display_loc)) {
    display_loc <- normalizePath(display_loc, winslash = "/")
  }

  qmd_name <- paste0(x$display_name, ".qmd")
  pdf_name <- paste0(x$display_name, ".pdf")
  docorator_name <- paste0(x$display_name, "_docorator_obj.Rds")

  if (!is.null(display_loc)) {
    render_dir <- file.path(
      display_loc,
      paste0(x$display_name, "_docorator_files")
    )
  } else {
    render_dir <- file.path(paste0(x$display_name, "_docorator_files"))
  }
  if (!dir.exists(render_dir)) {
    dir.create(render_dir)
  }

  on.exit(
    {
      if (isTRUE(clean)) {
        unlink(render_dir, recursive = TRUE)
      }
    },
    add = TRUE
  )

  withr::with_dir(
    new = render_dir,
    code = {
      # copy template qmd to the render dir
      template <- system.file("template", "template.qmd", package = "docorator")
      file.copy(template, ".", overwrite = TRUE, recursive = TRUE)
      file.rename("template.qmd", qmd_name)

      # copy tex header to render dir and rename if one exists
      if (!is.null(header_latex)) {
        if (
          file.exists(header_latex) && tools::file_ext(header_latex) == "tex"
        ) {
          file_name <- basename(header_latex)
          file.copy(header_latex, ".", overwrite = TRUE, recursive = TRUE)
          file.rename(file_name, "header.tex")
        } else {
          cli::cli_warn(
            "The header_latex argument must point to a valid .tex file. No header options applied.",
            call = rlang::caller_env()
          )
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
          quiet = TRUE
        )
    }
  )

  if (file.exists(file.path(render_dir, pdf_name))) {
    if (!is.null(display_loc)) {
      out_path <- file.path(display_loc, pdf_name)
    } else {
      out_path <- pdf_name
    }
    file_ok <- file.copy(
      from = file.path(render_dir, pdf_name),
      to = out_path,
      overwrite = TRUE
    )

    if (file_ok) {
      cli::cli_alert_success("Document created at: {out_path}")
    }
  }

  # return docorator object for further renders
  invisible(x)
}

#' Render to PDF (HTML)
#'
#' `r lifecycle::badge("experimental")`
#'
#' @param keep_html Whether to keep the intermediate HTML file. If `TRUE`
#'   (default), the HTML is saved alongside the PDF with the same base name.
#'   If `FALSE`, HTML is deleted after conversion.
#' @param wait Number of seconds to wait after page navigation before printing.
#'   Increase if the table takes time to render. Defaults to `3`.
#' @inheritParams render_pdf
#' 
#' @returns Invisibly returns the path to the created PDF file.
#' @export
#'
#' @section Examples:
#'
#' ```r
#' gt::gtcars |>
#'   dplyr::slice_head(n = 10) |>
#'   dplyr::select(mfr, model, year, msrp) |>
#'   gt::gt() |>
#'   as_docorator(
#'      display_name = "output",
#'      header = fancyhead(
#'        fancyrow(left = "Study ABC-123", right = "Draft"),
#'        fancyrow(center = "Table 1: Vehicle Summary")
#'      ),
#'      footer = fancyfoot(
#'        fancyrow(left = "Source: gtcars"),
#'        fancyrow(left = "program.R", right = format(Sys.Date(), "%d%b%Y"))
#'      )
#'   ) |> 
#'   render_pdf_html()
#' ```
#'
render_pdf_html <- function(x,
                            display_loc = NULL,
                            keep_html = FALSE,
                            wait = 3) {

  if (!inherits(x, "docorator")) {
    cli::cli_abort("The {.arg {rlang::caller_arg(x)}} argument must be class docorator, not {.obj_type_friendly {x}}. See documentation for `as_docorator`.",
              call = rlang::caller_env())
  }

  # if no path is given, use docorator path
  if (is.null(display_loc)) {
    display_loc <- x$display_loc %||% "."
  }
  display_loc <- normalizePath(display_loc, winslash = "/")

  # set filename
  filename_html <- file.path(display_loc, paste0(x$display_name,".html"))
  filename_pdf <- file.path(display_loc, paste0(x$display_name,".pdf"))

  # determine intermediate html path and render
  if(isFALSE(keep_html)) {
    on.exit(unlink(filename_html), add = TRUE)
    suppressMessages(render_html(x, display_loc = display_loc))
  }else{
    render_html(x, display_loc = display_loc)
  }

  # convert to pdf via chromote
  b <- chromote::ChromoteSession$new()
  on.exit(b$close(), add = TRUE)

  url <- paste0("file://", normalizePath(filename_html))
  b$Page$navigate(url, wait_ = TRUE)
  Sys.sleep(wait)

  result <- b$Page$printToPDF(
    marginTop = 0,
    marginBottom = 0,
    marginLeft = 0,
    marginRight = 0,
    printBackground = TRUE,
    displayHeaderFooter = FALSE,
    preferCSSPageSize = TRUE,
    headerTemplate = '<div></div>',
    footerTemplate = '<div></div>',
    wait_ = TRUE
  )

  result$data |>
    base64enc::base64decode() |>
    writeBin(con = filename_pdf)

  cli::cli_alert_success("Document created at: {.path {normalizePath(filename_pdf, winslash = '/')}}")

  invisible(x)
}