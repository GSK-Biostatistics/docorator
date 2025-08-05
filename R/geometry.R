
#' Process geometry for latex
#'
#' @param header Document header
#' @param footer Document footer
#' @param fontsize Font size for headers and footers
#' @param geometry Named list of geometry options
#'
#' @return Character string
#' @noRd
geom_process <- function(header, footer, fontsize, geometry){

  if (is.null(geometry$headheight)){
    geometry$headheight <- paste0(hf_height(header, fontsize), "pt")
  }
  if (is.null(geometry$footskip)){
    geometry$footskip <- paste0(hf_height(footer, fontsize), "pt")
  }

  paste(names(geometry), geometry, sep = "=", collapse = ", ")

}

#' Set document geometry defaults
#' @param ... Series of named value pairs for latex geometry options
#'
#' @details Type geom_set() in console to view package defaults. Use of the
#'   function will add to the defaults and/or override included defaults of the
#'   same name. For values that are `NULL`, such as for `headheight` and
#'   `footskip`, the values will be calculated automatically based on the number
#'   of header and/or footer lines. For all geometry settings, reference the
#'   documentation here: https://texdoc.org/serve/geometry.pdf/0
#'
#' @return Named list
#' @export
#'
#' @examples
#' # view defaults
#' geom_set()
#'
#' # Update the defaults
#' geom_set(left="0.5in", right="0.5in")
#'
#' # add new defaults
#' geom_set(paper = "legalpaper")
#'
geom_set <- function(...){

  args <- list(...)

 # args_keep <- args
  # default list
  geom_list <- list(
    paperheight="8.5in",
    paperwidth="11in",
    left = "1in",
    right = "1in",
    top = "1.25in",
    bottom = "1.25in",
    headsep = "10pt",
    includehead = TRUE,
    includefoot = TRUE,
    headheight = NULL,
    footskip = NULL
  )

  # overwrite any user-specified defaults
  idx_drop <- which(names(geom_list) %in% names(args))

  if(length(idx_drop)>0){
    geom_list <- geom_list[-idx_drop]
  }
  c(geom_list,
    args)
}


