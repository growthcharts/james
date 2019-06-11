#' Derive chartcode list from data
#'
#' The function load individual data into, calculates the
#' chartcode and returns a list of parsed chartcode. The
#' function is called at initialization to automate the
#' selection of the chart according to the individual data.
#' @param location A url that points to the server location where the
#' data from a previous request to \code{convert_bds_ind()} are stored.
#' @param chartcode The code of the requested growth chart. If not
#' specified, the server will automatically plot child height for
#' the most recent age period.
#' @return A list with chart codes, produced by \code{chartbox::parse_chartcode}
#' @author Stef van Buuren 2019
#' @seealso \code{\link[chartbox]{parse_chartcode}}
#' @keywords server
#' @export
convert_ind_chartcodelist <- function(location = NULL,
                                      chartcode = NULL) {
  # assign object stored by convert_bds_ind to ind
  if (length(location) == 0L) ind <- NULL
  else {
    con <- curl(paste0(location, "R/.val/rda"))
    load(file = con)
    ind <- .val
    close(con)
    rm(".val")
  }

  # if (is.null(chartcode))
  chartcode <- select_chart(ind)$chartcode
  chartcodelist <- parse_chartcode(chartcode)
  chartcodelist$chartcode <- chartcode
  chartcodelist
}
