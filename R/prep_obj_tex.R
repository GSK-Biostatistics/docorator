#' Prepare table, listing, figure object for inclusion in the template Rmd
#'
#' @param x docorator object containing info about the table, listing or figure
#' @param transform optional latex transformation function to apply to a gt latex string
#' @param ... additional args
#'
#' @return object to be included as-is in render engine
#' @export
#' @keywords internal
#'
#' @examples
#' docorator <- gt::exibble |>
#' gt::gt() |>
#' as_docorator(footer = NULL,
#' save_object = FALSE)
#'
#' prepared_obj <- prep_obj_tex(docorator)
prep_obj_tex <- function (x, transform = NULL, ...) {
  UseMethod("prep_obj_tex", x$display)
}

#' @rdname prep_obj_tex
#' @export
#' @keywords internal
prep_obj_tex.default <- function(x, transform = NULL, ...) {
  x$display
}

#' @rdname prep_obj_tex
#' @export
#' @keywords internal
prep_obj_tex.character <- function(x, transform = NULL, ...) {
  cat(x$display)
}

#' @rdname prep_obj_tex
#' @export
#' @keywords internal
prep_obj_tex.PNG <- function(x, transform = NULL, ... ) {

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

#' @rdname prep_obj_tex
#' @export
#' @keywords internal
prep_obj_tex.gt_tbl <- function(x, transform = NULL, ...) {

  gt_to_tex(x$display, transform) |>
    cat()
}

#' @rdname prep_obj_tex
#' @export
#' @keywords internal
prep_obj_tex.gt_group <- function(x, transform = NULL, ...) {
  res <- lapply(seq_len(nrow(x$display$gt_tbls)), function(idx) {
    tbl <- gt::grp_pull(x$display, idx)

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
