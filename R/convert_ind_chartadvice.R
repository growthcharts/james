#' Derive advice on chart choice from data
#'
#' The function loads individual data from an url,
#' calculates the chartcode and returns a list of parsed chartcode
#' and agerange of the data.
#' The function is called at initialization to automate seting
#' of proper chart and analysis defaults according to the child data.
#' @inheritParams draw_chart
#' @return A list with chart codes (produced by \code{chartcatalog::parse_chartcode})
#' plus an element called `agerange`
#' @author Stef van Buuren 2019
#' @seealso \code{\link[chartcatalog]{parse_chartcode}}
#' @keywords server
#' @export
convert_ind_chartadvice <- function(ind_loc,
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
  chartcodelist$agerange <- get_range(ind = ind)
  chartcodelist
}
