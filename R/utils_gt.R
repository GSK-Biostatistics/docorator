#' Apply headers and footnotes to gt object
#'
#' Pulls headers and footnotes from the docorator object and applies them to the gt object
#' Note: this function is only for use by downstream tools and is not intended for general users
#'
#' @param x a docorator object
#'
#' @return gt object (either tbl or group)
#' @keywords internal
#'
#' @export
#' @keywords internal

hf_to_gt <- function(x) {

  if (!inherits(x, "docorator")) {
    cli::cli_abort("The {.arg {caller_arg(x)}} argument must be class docorator, not {.obj_type_friendly {x}}. See documentation for `as_docorator`.",
              call = rlang::caller_env())
  }

  gt <- x$display

  if (!rlang::inherits_any(gt, c("gt_tbl", "gt_group"))) {
    cli::cli_abort("The {.arg {caller_arg(x)}} argument must be class gt_tbl or gt_group, not {.obj_type_friendly {x}}.",
              call = rlang::caller_env())
  }

  head_foot <- hf_extract(x)


  # for gt_group objects iteratively add headers and footers

  if(inherits(gt, "gt_group")){
    gt <- hf_to_gt_group(gt, head_foot$head_data, head_foot$subhead_data, head_foot$foot_data)
  }else if(inherits(gt, "gt_tbl")){
    gt <- hf_to_gt_tbl(gt, head_foot$head_data, head_foot$subhead_data, head_foot$foot_data)
  }

  return(gt)
}

#' headers and footers for gt_tbl
#' @param gt a gt object
#' @param header a character vector containing header information
#' @param subheader a character vector containing subheader information
#' @param footer a character vector containing footnote information
#'
#' @noRd
hf_to_gt_tbl <- function(gt, header, subheader, footer){
  if(inherits(gt, "gt_tbl")){
    subtitle <- NULL

    # check if existing subtitle exists
    if(length(gt$`_heading`$subtitle)>0){
      old_sub <- gt$`_heading`$subtitle
      # add subtitle text on top of groups if exists
      if(length(subheader)>0){
        subtitle = gt::md(paste0(paste0(subheader, collapse = "<br>"), "<br>",paste0(old_sub, collapse = "<br>")))
      }else{
        subtitle = gt::md(old_sub)
      }
    }else if(length(subheader)>0){
      subtitle = gt::md(paste0(subheader, collapse = "<br>"))
    }
    # header
    if(length(header)>0 | length(subtitle)>0){
      gt <- gt |>
        gt::tab_header(title = paste0(header, collapse = " "), subtitle = subtitle)
    }
    # footer
  if(length(footer)>0){
    for(footnote in footer){
      gt <- gt |>
        gt::tab_footnote(footnote = footnote)
    }
  }
  }
  return(gt)
}


#' headers and footers for gt_group
#' @param gt_group a gt_group object
#' @param header a dataframe containing header information
#' @param subheader a dataframe containing subheader information
#' @param footer a dataframe containing footnote information
#'
#' @noRd
hf_to_gt_group <- function(gt_group, header, subheader, footer){
  if(inherits(gt_group, "gt_group")){
    for(i in 1:nrow(gt_group$gt_tbls)){
      gt <- gt::grp_pull(gt_group, i)
      # replace
      gt_group <- gt::grp_replace(gt_group, hf_to_gt_tbl(gt, header, subheader, footer),.which = i)
    }
  }
  return(gt_group)
}

#' extract header footer info from docorator object
#' @param x a docorator object
#'
#' @return list of header footer info
#' @keywords internal
#'
#' @export
#' @keywords internal
hf_extract <- function(x){
  # get header and footer information
  header <- x$header
  footer <- x$footer

  # Take titles that are alignment center, remove any missing
  # First value is title, any remaining are subtitles
  all_headers <- unlist(lapply(header, function(x){
    if(!is.na(x$center)){
      x$center
    }}))

  head_data <- all_headers[1]

  # subheaders
  subhead_data <- all_headers[-1]

  # Take footers that are alignment left, remove any missing
  foot_data <- unlist(lapply(footer, function(x){
    if(!is.na(x$left)){
      x$left
    }}))

  list(head_data = head_data,
       subhead_data = subhead_data,
       foot_data = foot_data)

}

#' apply a gt function to a gt_group
#' @param func string with function name
#' @param args named list of function arguments with gt_tbl or gt_group as first arg
#' @param call caller env
#' @noRd
apply_to_grp <- function(func, args, call = rlang::caller_env()){

  # check first arg is gt obj
  gt_obj <- args[[1]]

  if(!(inherits(gt_obj, c("gt_tbl", "gt_group")))){
    cli::cli_abort("First arg must be a gt_tbl or gt_group object, not {.obj_type_friendly {gt_obj}}")
  }

  if(inherits(gt_obj, "gt_tbl")){
    gt_obj <- do.call(func, args, envir = call)
  }else if(inherits(gt_obj, "gt_group")){
    for (i in seq_len(nrow(gt_obj$gt_tbls))) {
      # pull out gt_tbl, apply function, reinsert into group
      gt_tbl <- gt::grp_pull(gt_obj, i)
      # replace data arg with current gt_tbl
      args[[1]] <- gt_tbl
      #make it clear which table if an error occurs
      gt_tbl <- tryCatch({
        do.call(func, args, envir = call)
      },
      error = function(e) {
        cli::cli_abort("Failure in Table {i}", parent = e)
      })

      gt_obj <- gt::grp_replace(gt_obj, gt_tbl, .which = i)
    }
  }

  gt_obj
}

#' Convert png object to gt from docorator object
#' @param x docorator object
#' @export
#' @keywords internal
png_to_gt <- function(x){

  # save png to temp file
 temp_png <- tempfile(
    pattern = "temp_png_",
    tmpdir = tempdir(),
    fileext = ".png")

 png::writePNG(x$display$png, temp_png)

  # convert to gt
  gt <- dplyr::tibble(ggplot =  temp_png) |>
    gt::gt() |>
    gt::fmt_image(columns = dplyr::everything(), sep = ",", width = "6in") |>
    # remove column headers and borders
    gt::tab_options(
      column_labels.hidden = TRUE,
      table.border.top.style = "hidden",
      table.border.bottom.style = "hidden"
    )

  gt

}

#' Convert ggplot object to gt from docorator object
#' @param x docorator object
#' @export
#' @keywords internal
gg_to_gt <- function(x){

  if (!inherits(x$display, "ggplot")) {
    cli::cli_abort("The display must be class ggplot, not {.obj_type_friendly {x$display}}.",
                   call = rlang::caller_env())
  }

  # remove header footer information
  display_info <- hf_strip(x$display)

  # convert to gt
  gt <- dplyr::tibble(ggplot =  display_info$display |>
                 gg_to_image(fig_dim = x$fig_dim, path = tempdir())) |>
    gt::gt() |>
    gt::fmt_image(columns = dplyr::everything(), sep = ",", width = "6in") |>
    # add header and footer information
    gt::tab_header(title = display_info$head_data, subtitle = display_info$subhead_data) |>
    # remove column headers and borders
    gt::tab_options(
      column_labels.hidden = TRUE,
      table.border.top.style = "hidden",
      table.border.bottom.style = "hidden"
    )

  # add footnotes if not NULL - avoids null row being added
  if(!is.null(display_info$foot_data)){
    gt <- gt |>
      gt::tab_footnote(footnote = display_info$foot_data)
  }

  gt

}

#' ggplot to image filepath
#' Taken from code here: https://github.com/rstudio/gt/blob/6312cf5be92fae41633b5df7d41aa948b850aaf8/R/image.R#L351C1-L392C2
#' @param plot_object ggplot object
#' @param fig_dim vector containing figure height and width in inches. Defaults to c(5,8) - docorator defaults
#' @param path file path including the png location to save the output to
#' @return filepath to snap of ggplot
gg_to_image <- function(plot_object, fig_dim = c(5,8), path = getwd()) {


  # Upgrade x to a list if only a single ggplot object is provided
  if (inherits(plot_object, "gg")) {
    plot_object <- list(plot_object)
  }

  vapply(
    seq_along(plot_object),
    FUN.VALUE = character(1L),
    USE.NAMES = FALSE,
    FUN = function(x) {

      filename <- tempfile(
        pattern = "temp_gt_ggplot_",
        tmpdir = path,
        fileext = ".png")

      # Save PNG file to disk
      ggplot2::ggsave(
        filename = filename,
        create.dir = TRUE,
        plot = plot_object[[x]],
        device = "png",
        dpi = 100,
        width = fig_dim[2],
        height = fig_dim[1],
        units = "in"
      )

      filename

    }
  )
}

#' strip header footer info from ggplot object
#' @param x a ggplot object
#'
#' @return list of header footer info
#'
#' @export
#' @keywords internal
hf_strip <- function(x){


  if (!inherits(x, "ggplot")) {
    cli::cli_abort("The display must be class ggplot, not {.obj_type_friendly {x}}.",
                   call = rlang::caller_env())
  }

  head_data <- x$labels$title
  # move tag to subtitle
  subhead_data <- c(x$labels$subtitle,x$labels$tag)
  foot_data <- x$labels$caption

  # set to null in ggplot object
  x$labels[c("title","subtitle", "caption", "tag")] <- NULL

  list(display = x,
       head_data = head_data,
       subhead_data = subhead_data,
       foot_data = foot_data)

}
