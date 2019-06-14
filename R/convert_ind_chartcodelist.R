#' Derive chartcode list from data
#'
#' The function load individual data that is already on the server,
#' calculates the chartcode and returns a list of parsed chartcode.
#' The function is called at initialization to automate the selection
#' of the chart according to the individual data.
#' @inheritParams draw_chart
#' @return A list with chart codes, produced by \code{chartbox::parse_chartcode}
#' @author Stef van Buuren 2019
#' @seealso \code{\link[chartbox]{parse_chartcode}}
#' @keywords server
#' @export
convert_ind_chartcodelist <- function(ind_loc,
                                      chartcode,
                                      selector) {

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
               "chartcode" = validate_chartcode(chartcode))

  chartcodelist <- parse_chartcode(cc)
  chartcodelist$chartcode <- cc
  chartcodelist
}
