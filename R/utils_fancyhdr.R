#'  Construct document header
#'
#'  Define document header through a series of `fancyrow`s. Each row represents
#'  a new line in the header with options for positioning text at left, center,
#'  and/or right positions.
#'
#' @param ... Series of objects of class `fancyrow`. Each entry represents a new
#'   row in the document header.
#'
#' @return Character string containing latex code for the `fancyhead` entries as
#'   part of the `fancyhdr` latex framework
#'
#' @export
#' @examples
#' fancyhead(
#'  fancyrow(left = "Protocol: 12345", right = doc_pagenum()),
#'  fancyrow(center = "Demographic Summary")
#' )
#'
fancyhead <- function(...){

  dots <- list(...)
  if (rlang::is_empty(dots)) return(NULL)
  check_fancyrows(dots)

  structure(
    dots,
    class = c("fancyhead","fancyhdr")
  )
}

#'  Construct document footer
#'
#'  Define document footer through a series of `fancyrow`s. Each row represents
#'  a new line in the footer with options for positioning text at left, center,
#'  and/or right positions.
#'
#' @param ... Series of objects of class `fancyrow`. Each entry represents a new
#'   row in the document footer.
#'
#' @return Character string containing latex code for the `fancyfoot` entries as
#'   part of the `fancyhdr` latex framework
#'
#' @export
#' @examples
#' fancyfoot(
#'  fancyrow(left = "My first footnote", right = doc_datetime())
#' )
#'
fancyfoot <- function(...){

  dots <- list(...)
  if (rlang::is_empty(dots)) return(NULL)
  check_fancyrows(dots)

  structure(
    dots,
    class = c("fancyfoot","fancyhdr")
  )
}

#'  Construct document header row
#'
#'  Define a single row in the document header/footer. Each row represents
#'  a single line of text, with options for positioning text at left, center,
#'  and/or right.
#'
#' @param left Character string to be aligned to the left side of the row.
#' @param center Character string to be aligned to the center of the row.
#' @param right Character string to be aligned to the right side of the row.
#'
#' @return Object of class `fancyrow`
#' @export
#' @examples
#' fancyrow(left = "Left most text", right = "Right most text")
#'
#' fancyrow(center = "Just text in the center")
#'
#' fancyrow(left = "All", center = "Three", right = "Positions filled")
fancyrow <- function(left = NA,
                     center = NA,
                     right = NA){

  # Check that all arguments are single strings
  check_fancyrow_string(left = left, center = center, right = right)

  structure(
    list(left = left,
         center = center,
         right = right),
    class = "fancyrow"
  )

}

#' Check that all arguments in fancyrow() are single strings or NA
#' @param left Character string to be aligned to the left side of the row.
#' @param center Character string to be aligned to the center of the row.
#' @param right Character string to be aligned to the right side of the row.
#' @noRd
#' @keywords internal
#'
check_fancyrow_string <- function(left = NA,
                                  center = NA,
                                  right = NA){
  
  # Create list of arguments for iteration
  args <- list(left = left, center = center, right = right)
  errors <- character(0)
  
  for (name in names(args)) {
    value <- args[[name]]
    # Check if arguments are a vector of size greater than 1
    if (length(value) > 1) {
      errors <- c(
        errors,
        cli::format_message("{.arg {name}} must be a single value, but has a length of {length(value)}.")
      )
      next
    }
    
    # Check if arguments contain any non-string values if not NA
    if (!is.na(value) && !is.character(value)) {
      errors <- c(
        errors,
        cli::format_message("{.arg {name}} must be a character string or NA, but is {class(value)}.")
      )
    }
  }    
  
  if (length(errors) > 0) {
    cli::cli_abort(c("Invalid input in fancyrow():", errors))
  }
  
  invisible(TRUE)
}

#' Check that header and footer args are of class `fancyhdr`
#' @param x object passed to `as_docorator`
#' @param chr_ok Whether to accept character vectors as input
#' @noRd
#'
check_fancyhdr <- function(x, chr_ok = FALSE){

  if (rlang::is_empty(x)) {
    return(invisible(x))
  }

  class_ok <- "fancyhdr"
  if (chr_ok){
    class_ok <- c("fancyhdr","character")
  }

  if (!inherits(x, class_ok)) {
    cli::cli_abort("The {.arg {caller_arg(x)}} argument must be class {.cls {class_ok}} or empty, not {.obj_type_friendly {x}}.",
              call = rlang::caller_env())
  }
  invisible(x)
}

#' Check that all entries are class `fancyrow`
#'
#' @param x List of entries passed to `fancyheader` or `fancyfooter`
#'
#' @noRd
check_fancyrows <- function(x){
  for(idx in seq_along(x)){
    if(!inherits(x[[idx]], "fancyrow")){
      cli::cli_abort("Entry number {idx} is not an object of class `fancyrow`.",
                call = rlang::caller_env())
    }
  }
}

#' Convert `fancyrow` to tibble
#'
#' @param x Object of class `fancyrow`
#'
#' @return tibble
#' @noRd
as_tibble_fancyrow <- function(x, ...){
  dplyr::tibble(left = x$left,
         center = x$center,
         right = x$right)
}

#' Process headers/footers
#' @export
#' @keywords internal
hf_process <- function(x, escape_latex = TRUE){
  UseMethod("hf_process", x)
}

#' @export
#' @rdname hf_process
#' @keywords internal
hf_process.default <- function(x, escape_latex = TRUE){
  if(is.null(x)){
    return(NULL)
  }
  x
}

#' @export
#' @rdname hf_process
#' @keywords internal
hf_process.character <- function(x, escape_latex = TRUE){
  cli::cli_alert_info("Coercing `header` from {.cls {'character'}} to {.cls {'fancyhead'}} with {length(x)} row{?s}")
  lapply(x, fancyrow) |>
    process_rows(type = "head", escape_latex = escape_latex)
}

#' @export
#' @rdname hf_process
#' @keywords internal
hf_process.fancyhead <- function(x, escape_latex = TRUE){
  process_rows(x, type = "head", escape_latex = escape_latex)
}

#' @export
#' @rdname hf_process
#' @keywords internal
hf_process.fancyfoot <- function(x, escape_latex = TRUE){
  process_rows(x, type = "foot", escape_latex = escape_latex)
}


#' Process list of `fancyrow` objects into character string containing latex code
#'
#' @param x list of `fancyrow` objects
#' @param type Text positioning in the header (`head`) or footer (`foot`) of
#'   document. Defaults to `head`.
#'
#' @return Character string
#' @noRd
process_rows <- function(x, type = c("head","foot"), escape_latex = TRUE){

  type <- match.arg(type)

  x_df <- purrr::map_dfr(x, as_tibble_fancyrow)

  if(isTRUE(escape_latex)){
    x_df <- x_df |>
      dplyr::mutate(
        # escape latex characters
        dplyr::across(dplyr::everything(), hf_escape))
  }

  x_df <- x_df |>
    dplyr::mutate(
      dplyr::across(dplyr::everything(), \(x) as.character(x) |>
               tidyr::replace_na("\\phantom{}"))
    ) |>
  dplyr::summarise(dplyr::across(dplyr::everything(), \(x) paste(x, collapse = "\\\\")))

  paste0("\\fancy", type, "[L]{\\begin{tabular}[b]{@{}l@{}}", x_df$left, "\\end{tabular}}",
         "\\fancy", type, "[C]{\\begin{tabular}[b]{@{}c@{}}", x_df$center, "\\end{tabular}}",
         "\\fancy", type, "[R]{\\begin{tabular}[b]{@{}r@{}}", x_df$right, "\\end{tabular}}")
}

#' Calculate desired header or footer height for the document

#' @param x header or footer
#' @param fontsize Document font size (pt)
#'
#' @return Numeric value
#' @keywords internal
hf_height <- function(x, fontsize){
  UseMethod("hf_height", x)
}

#' @export
#' @rdname hf_height
#' @keywords internal
hf_height.default <- function(x, fontsize){
  ceiling(fontsize*1.2)
}

#' @export
#' @rdname hf_height
#' @keywords internal
hf_height.fancyhdr <- function(x, fontsize){
  if (is.null(x)) return(0)

  # find # of rows
  num_rows <- purrr::map_dfr(x, as_tibble_fancyrow) |> nrow()

  # rough estimate but should be sufficient to avoid the fancyhdr warning
  ceiling(num_rows*fontsize*1.2)
}

#' escape the latex characters, but keep the output of doc_pagenum unescaped
#' @param x text string to be escaped
hf_escape <- function(x) {

  latex_text <- gt::escape_latex(x)

  # keep the display page number unescaped
  page_num_pattern <- c(
    "\\\\textbackslash\\{\\}thepage\\\\textbackslash\\{\\}" = "\\\\thepage\\\\",
    "\\\\textbackslash\\{\\}pageref\\*\\\\\\{LastPage\\\\\\}" = "\\\\pageref*{LastPage}"
  )
  escaped_full <- latex_text |>
    stringr::str_replace_all(page_num_pattern)

}
