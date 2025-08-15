
#' Prepare table, listing, figure object for inclusion in the template Rmd
#'
#' @param x table, listing, or figure object
#' @param transform optional latex transformation function to apply to a gt latex string
#' @param ... additional args
#'
#' @return object to be included as-is in knitted rmd
#' @export
#' @keywords internal
prep_obj <- function (x, transform = NULL, ...) {
  UseMethod("prep_obj", x)
}

#' default
#' @export
#' @keywords internal
prep_obj.default <- function(x, transform = NULL, ...) {
  x
}

#' prep object that is a character string (presumably latex code)
#' @export
#' @keywords internal
prep_obj.character <- function(x, transform = NULL, ...) {
  cat(x)
}

#' prep object that is a path to a PNG
#' @export
#' @keywords internal
prep_obj.PNG <- function(x, transform = NULL, ... ) {

  if (Sys.getenv("DOCORATOR_RENDER_ENGINE")=="qmd"){
    tmpdir <- getwd()
  } else {
    tmpdir <- tempdir()
  }
  # temporarily store png
  temp <- tempfile(fileext = ".png", tmpdir = tmpdir)
  png::writePNG(x$png, temp)
  knitr::include_graphics(path = temp)
}

#' prep gt_tbl object
#' @export
#' @keywords internal
prep_obj.gt_tbl <- function(x, transform = NULL, ...) {

  gt_to_tex(x, transform) |>
    cat()
}

#' prep gt_group object
#' @export
#' @keywords internal
prep_obj.gt_group <- function(x, transform = NULL, ...) {
  res <- lapply(seq_len(nrow(x$gt_tbls)), function(idx) {
    tbl <- gt::grp_pull(x, idx)

    gt_to_tex(tbl, transform)
  })
  cat(unlist(res), sep = '\\pagebreak')
}

#' convert gt_tbl object to latex
#' @noRd
gt_to_tex <- function(x, transform = NULL){

  if (Sys.getenv("DOCORATOR_RENDER_ENGINE")=="qmd"){

    if ("latex_use_longtable" %in% x$`_options`$parameter){
      x <- x |>
        gt::tab_options(
          latex.use_longtable = FALSE,
          latex.tbl.pos = "H"
        )
    }

    tbl_tex <- x |>
      gt::as_latex() |> as.character()

  } else {

    if ("latex_use_longtable" %in% x$`_options`$parameter){
      x <- x |>
        gt::tab_options(
          latex.use_longtable = TRUE
        )
    }

    tbl_tex <- x |>
      gt::as_latex() |> as.character()

    # add line for repeated headers if table breaks on multiple pages
    #  longtable only
    tbl_tex <- sub("\\\\midrule","\\\\midrule\\\\endhead",tbl_tex)
  }

  # apply optional latex transform
  if(!is.null(transform)){
    tbl_tex |> transform()
  }else{
    tbl_tex
  }
}
