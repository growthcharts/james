#' Derive chartcode list from data
#'
#' The function load individual data into, calculates the
#' chartcode and returns a list of parsed chartcode. The
#' function is called at initialization to automate the
#' selection of the chart according to the individual data.
#' @param ind_loc  A url that points to the server location where the
#'   data from a previous request to \code{convert_bds_ind()} are
#'   stored. Optional. \code{ind_loc} takes priority over
#'   \code{bds_data}.
#' @param chartcode The code of the requested growth chart. If not
#'   specified, the function will select the chart that best matches
#'   the input data.
#' @return A list with chart codes, produced by \code{chartbox::parse_chartcode}
#' @author Stef van Buuren 2019
#' @seealso \code{\link[chartbox]{parse_chartcode}}
#' @keywords server
#' @export
convert_ind_chartcodelist <- function(ind_loc = NULL,
                                      chartcode = NULL) {
  selector <- ifelse(is.null(chartcode), "data", "chartcode")

  # assign object stored by convert_bds_ind to ind
  if (length(ind_loc) == 0L) ind <- NULL
  else {
    con <- curl(paste0(ind_loc, "R/.val/rda"))
    load(file = con)
    ind <- .val
    close(con)
    rm(".val")
  }

  cc <- switch(selector,
               "data" = select_chart(ind = ind)$chartcode,
               "chartcode" = chartcode)

  chartcodelist <- parse_chartcode(cc)
  chartcodelist$chartcode <- cc
  chartcodelist
}
