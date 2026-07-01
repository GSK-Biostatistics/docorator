#' Path of program
#'
#' @param filename Name of output file
#' @param path program path
#'
#' @return character string
#' @export
#' @examples
#' \dontrun{
#'  doc_path(filename = "my_tbl.pdf", path = NULL)
#'}
doc_path <- function(filename = NULL, path = NULL){
  path <- path %||% "."
  doc_path <- thisfile(filename, path)
  if(length(doc_path)==0){
    return(NA)
  }
  doc_path
}

#' Date and time of program run
#'
#' @return character string
#' @export
#' @examples
#' \donttest{
#'  doc_datetime()
#'}
doc_datetime <- function(){
  as.POSIXct(Sys.time(), tz = "UTC") |>
    format("%d%B%Y %H:%M")
}

#' Automatic page numbering
#'
#' @return character string containing latex code
#' @export
#' @examples
#' doc_pagenum()
#'
doc_pagenum <- function(){
  "_DOCORATOR_PAGE_PLACEHOLDER_"
}


#' Functions adapted from whereami package, formerly in rprojroot
#' https://github.com/yonicd/whereami/blob/master/R/thisfile.R
#'
#' @noRd
thisfile <- function(filename, path) {
  if (!is.null(res <- thisfile_source())) {
    res
  } else if (!is.null(res <- thisfile_r())) {
    res
  } else if (!is.null(res <- thisfile_rscript())) {
    res
  } else if (Sys.getenv("RSTUDIO") == "1" &&
             !is.null(rstudioapi::getSourceEditorContext()$path) &&
             !rstudioapi::getSourceEditorContext()$path==""){
    normalizePath(rstudioapi::getSourceEditorContext()$path, winslash = "/")
  } else if (!is.null(filename)){
    paste0(
      normalizePath(path, winslash = "/"), "/", tools::file_path_sans_ext(filename), ".R"
    )
  } else {
    NULL
  }
}

#' @noRd
thisfile_source <- function() {
  for (i in -(1:sys.nframe())) {
    if (identical(args(sys.function(i)), args(base::source))) {
      return(normalizePath(sys.frame(i)$ofile,winslash = '/'))
    }
  }

  NULL
}

#' @noRd
thisfile_r <- function() {
  cmd_args <- commandArgs(trailingOnly = FALSE)
  if (!grepl("^R(?:|term)(?:|[.]exe)$", basename(cmd_args[[1L]]), ignore.case = TRUE)) {
    return(NULL)
  }

  cmd_args_trailing <- commandArgs(trailingOnly = TRUE)
  leading_idx <-
    seq.int(from = 1, length.out = length(cmd_args) - length(cmd_args_trailing))
  cmd_args <- cmd_args[leading_idx]
  file_idx <- c(which(cmd_args == "-f") + 1, which(grepl("^--file=", cmd_args)))
  res <- gsub("^(?:|--file=)(.*)$", "\\1", cmd_args[file_idx])

  # If multiple --file arguments are given, R uses the last one
  res <- utils::tail(res[res != ""], 1)
  if (length(res) > 0) {
    return(res)
  }

  NULL
}

#' @noRd
thisfile_rscript <- function() {
  cmd_args <- commandArgs(trailingOnly = FALSE)
  if (!grepl("^R(?:term|script)(?:|[.]exe)$", basename(cmd_args[[1L]]), ignore.case = TRUE)) {
    return(NULL)
  }

  cmd_args_trailing <- commandArgs(trailingOnly = TRUE)
  leading_idx <-
    seq.int(from = 1, length.out = length(cmd_args) - length(cmd_args_trailing))
  cmd_args <- cmd_args[leading_idx]
  res <- gsub("^(?:--file=(.*)|.*)$", "\\1", cmd_args)

  # If multiple --file arguments are given, R uses the last one
  res <- utils::tail(res[res != ""], 1)
  if (length(res) > 0) {
    return(res)
  }

  NULL
}

#' Path of png file
#'
#' @param path path to png
#'
#' @return object with png attribute
#' @export
#' @examples
#' \dontrun{
#' png_path <- png_path(path = "path_to_my_png.png")
#' }
png_path <- function(path = NULL){
  # path provided, is valid, is png
  if(is.null(path) | !file.exists(path) | toupper(tools::file_ext(path)) != "PNG"){
    cli::cli_abort("Please provide a valid path to a PNG file.",
              call = rlang::caller_env())
  }

  png <- png::readPNG(path)

  structure(list(
    png = png),
    class = "PNG")

}

#' Create prep_obj_tex code chunks
#' Taken from https://gist.github.com/MichaelJW/b4a3dd999a47b137d12f42a8f7562b11
#'
#' @param x docorator object
#' @param id id number for the chunk
#' @param transform optional latex transformation function to apply to a gt latex string
#'
#' @return printed code chunk to be included as-is in the render engine
#' @noRd
#' @examples
#' \dontrun{
#' docorator <- gt::exibble |>
#'   gt::gt() |>
#'   as_docorator(save_object = FALSE)
#' create_chunk(docorator, transform = NULL)
#' }
create_chunk <- function(x, id = 1, transform) {
  deparsed <- paste0(deparse(
    function() {
      prep_obj_tex(x, transform)
    }
  ), collapse = '')

  new_chunk <- paste0("
  `","``{r new_chunk", id, ", fig.height=", x$fig_dim[1], ", fig.width=", x$fig_dim[2], ", echo=FALSE, results='asis', output='asis', out.height='", x$fig_dim[1], "in', out.width='", x$fig_dim[2], "in'}",
                      "\n(",
                      deparsed
                      , ")()",
                      "\n  `","``
  ")

  cat(knitr::knit(text = knitr::knit_expand(text = new_chunk), quiet = TRUE))
}

#' Create code chunks
#'
#' @param x docorator object
#' @param transform optional latex transformation function to apply to a gt latex string
#'
#' @return printed code chunk(s) to be included as-is in the render engine
#' @export
#' @keywords internal
#' @examples
#' \dontrun{
#' docorator <- gt::exibble |>
#'   gt::gt() |>
#'   as_docorator(save_object = FALSE)
#' create_chunks_all(docorator, transform = NULL)
#' }
create_chunks_all <- function(x, transform) {
  if (!inherits(x, "docorator")) {
    cli::cli_abort("The {.arg {rlang::caller_arg(x)}} argument must be class docorator, not {.obj_type_friendly {x}}. See documentation for `as_docorator`.",
                   call = rlang::caller_env())
  }

  display <- x$display

  if(identical(class(display), "list")) {
    for (i in 1:length(display)) {
      new_docorator <- x
      new_docorator$display <- display[[i]]
      create_chunk(new_docorator,i,transform)
      # no pagebreak for the last chunk, otherwise it will create an extra blank page at the end of the document
      if (i != length(display)) {
        cat("\\pagebreak\n")
      }
    }
  }  else {
    create_chunk(x, 1, transform)
  }
}

#' Check package versions for docorator object are the same as loaded
#'
#' @param x docorator object
#' @keywords internal
check_pkg_version <- function(x) {

  if (rlang::inherits_any(x$display, c("gt_tbl", "gt_group"))) {
    pkg <- "gt"
  }else if (inherits(x$display,"ggplot")) {
    pkg <- "ggplot2"
  }else{
    return()
  }

 package_list <- append(x$session_info$otherPkgs,x$session_info$loadedOnly)
 pkg_version <- package_list[[pkg]][["Version"]]

 # get current version if it exists
 current_version = as.character(utils::packageVersion(pkg))

 if(utils::compareVersion(current_version, pkg_version)!= 0){
   cli::cli_text("Note: docorator object was created with {.pkg {pkg} {pkg_version}}. You are now running {.pkg {pkg} {current_version}}. There may be issues rendering your document.")}
}

#' Convert ggplot2 to png to preserve scaling for all render engines
#' @param x display object
#' @param fig_dim figure dimensions
#' @return display object
#' @noRd
#' @keywords internal
convert_ggplot <- function(x, fig_dim = c(5, 8)) {
  # convert to list if not already
  if (!identical(class(x), "list")) {
    x <- list(x)
  }

  x <- lapply(x, function(i) {
    if (inherits(i, "ggplot")) {
      # convert ggplot2 to png
      tmpfile <- tempfile(fileext = ".png")
      ggplot2::ggsave(
        tmpfile,
        plot = i,
        width = fig_dim[2],
        height = fig_dim[1],
        units = "in"
      )
      i <- png_path(tmpfile)
    }
    i
  })

  if (length(x) == 1) {
    x <- x[[1]]
  }
  x
}

# convert any gt_groups to a list, flatten any lists containing gt_groups to a list of gt_tbls
#' @param x object containing the display.
#' @return object containing the display, converted to list if appropriate
#' @noRd
#' @keywords internal
convert_list_displays <- function(x) {
  if (inherits(x, "gt_group")) {
    x <- lapply(seq_len(nrow(x$gt_tbls)), function(i) {
      gt::grp_pull(x, i)
    })
  }

  # if a list contains gt_group, flatten to gt_tbls
  if (identical(class(x), "list")) {
    x <- lapply(x, function(j) {
      if (inherits(j, "gt_group")) {
        lapply(seq_len(nrow(j$gt_tbls)), function(i) {
          gt::grp_pull(j, i)
        })
        # lists of lists etc not supported
      } else if (identical(class(j), "list")) {
        cli::cli_abort(
          "Nested lists are not supported. See documentation for supported display types.",
          call = rlang::caller_env()
        )
      } else {
        list(j)
      }
    })
    x <- unlist(x, recursive = FALSE)
  }
  x
}