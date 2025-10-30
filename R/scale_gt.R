#' Apply scaling to gt objects
#'
#' @param x gt object
#' @param tbl_scale Boolean for whether or not to automatically scale table columns to fit display area. Defaults to TRUE. Note that this will overwrite scaling set in the table directly unless set to FALSE.
#' @param tbl_stub_pct percent of total width that should be dedicated to stub column(s). If more than 1 stub column then this is the total for both.
#' @param fontsize document font size
#' @return scaled gt object
#' @name apply_scale
#' @examples
#' gt <- gt::exibble |>
#' gt::gt()
#'
#' apply_scale(gt, fontsize = 10, tbl_scale = FALSE, tbl_stub_pct = "20%")
NULL

#' @name apply_scale
#' @export
#' @keywords internal
apply_scale <- function (x, fontsize, tbl_scale, tbl_stub_pct) {
  UseMethod("apply_scale", x)
}

#' @name apply_scale
#' @export
#' @keywords internal
apply_scale.default <- function(x, fontsize, tbl_scale, tbl_stub_pct) {
  x
}

#' @name apply_scale
#' @export
#' @keywords internal
apply_scale.gt_tbl <- function(x, fontsize, tbl_scale, tbl_stub_pct) {

  table_width <- "100%"
  if(isFALSE(tbl_scale)){
    scaling <- check_gt_widths(x)
    tbl_scale <- scaling$tbl_scale
    table_width <-scaling$table_width
  }

  if(isTRUE(tbl_scale)){
    x <- scale_gt(x, tbl_stub_pct)
  }

  x |>
    gt::tab_options(table.font.size = paste0(fontsize, "pt"),
               table.width = table_width
  )

}

#' @name apply_scale
#' @export
#' @keywords internal
apply_scale.gt_group <- function(x, fontsize, tbl_scale, tbl_stub_pct) {

  arg_list <- list(x = x, fontsize=fontsize, tbl_scale = tbl_scale, tbl_stub_pct = tbl_stub_pct)

  x <- apply_to_grp("apply_scale",arg_list)

  x
}

#' Scale gt table contents for document
#'
#' @param x table of class `gt_tbl`
#' @param tbl_stub_pct percent of total width that should be dedicated to stub column(s). If more than 1 stub column then this is the total for both.
#'
#' @return Table with col_widths settings applied
#' @export
#'
#' @examples
#'
#' gt::gtcars |>
#'   dplyr::slice_head(n = 10) |>
#'   dplyr::select(mfr, model, year, msrp, ctry_origin) |>
#'   gt::gt(
#'       groupname_col = "ctry_origin",
#'       rowname_col = "mfr",
#'       row_group_as_column = TRUE) |>
#'   scale_gt(tbl_stub_pct = 0.4)
#'
scale_gt <- function(x,
                     tbl_stub_pct = 0.3
){

  # will group add to stub?
  row_grp_as_column <- x$`_options` |>
    dplyr::filter(.data$parameter=="row_group_as_column") |>
    dplyr::pull(.data$value) |>
    unlist()

  # total # of columns in table
  boxhead <- x[["_boxhead"]] |>
    dplyr::filter(!.data$type=="hidden")
  n_cols <- nrow(boxhead)

  # # of stub columns in table
  n_stubs <- boxhead |>
    dplyr::filter(type %in% c("stub", "row_group")) |>
    nrow()

  # account for row_grp NOT as column
  if (n_stubs>0 && "row_group" %in% boxhead$type && !row_grp_as_column) {
    n_stubs <- n_stubs-1
  }

  if (n_stubs==0) tbl_stub_pct <- 0
  widths_cols <- (100-100*tbl_stub_pct)/(n_cols-n_stubs)
  list_widths <- vector(mode = "list")

  # add stub %s
  if (n_stubs>0) {
    widths_stub <- 100*tbl_stub_pct/n_stubs

    if ("stub" %in% x[["_boxhead"]]$type){
      list_widths <- c(list_widths, rlang::new_formula(quote(gt::stub()), paste0(widths_stub, "%")))
    }
    if ("row_group" %in% x[["_boxhead"]]$type){
      row_grp_var <- dplyr::filter(x[["_boxhead"]], .data$type=="row_group")$var
      list_widths <- c(list_widths, rlang::new_formula(row_grp_var, paste0(widths_stub, "%")))
    }
  }

  list_widths <- c(list_widths, rlang::new_formula(quote(dplyr::everything()), paste0(widths_cols, "%")))

  # temp fix for order until gt #1922 resolved
  x$`_boxhead` <- x$`_boxhead` |>
    dplyr::arrange(match(.data$type, c("stub","row_group","default","hidden")))

  gt::cols_width(
    x,
    .list = list_widths
  )

}

#' function to check manually specified widths are in pct and are <100
#' @return boolean true if needs rescaling, false otherwise.
#' @noRd
check_gt_widths <- function(x){

  # preset table_width
  table_width <- "100%"

  # preset to false
  tbl_scale <- FALSE

  # get rid of hidden columns
  no_hide <- x$`_boxhead` |>
    dplyr::filter(!.data$type=="hidden")

  # vector of widths frm gt
  width_vec <- unlist(no_hide$column_width)

  # remove empty widths
  width_vec_full <- width_vec[width_vec != ""]

  # extract numeric values and sum
  nums <- gregexpr("[0-9]+(?:\\.[0-9]+)?", width_vec_full)
  width_sum <- sum(as.numeric(unlist(regmatches(width_vec_full, nums))))

  if(grepl("px",paste0(width_vec_full, collapse=""))){
    cli::cli_warn("Column widths must be specified in % not px. Applying auto table scaling.",
             call = rlang::caller_env())
    tbl_scale <- TRUE
  }else if(length(width_vec_full)>0 & !grepl("%",paste0(width_vec_full, collapse=""))){
    cli::cli_warn("Column widths must be specified in %. Applying auto table scaling.",
             call = rlang::caller_env())
    tbl_scale <- TRUE
  }else if(nrow(no_hide)>length(width_vec_full) & length(width_vec_full)>0 & width_sum<100){
    cli::cli_inform("NOTE: Column widths total <100%. Resulting table may not respect document margins.",
             call = rlang::caller_env())

    # dont rescale

  }else if(width_sum>100){
    cli::cli_warn("Column widths must be add to =<100%, not {width_sum}%. Applying auto table scaling.",
             call = rlang::caller_env())

    tbl_scale <- TRUE
  }else if(length(width_vec_full) == nrow(no_hide)){
    # if all cols are specified, don't set table width = 100, dont rescale
    table_width <- NULL
  }

  list(tbl_scale = tbl_scale,
       table_width = table_width)
}
