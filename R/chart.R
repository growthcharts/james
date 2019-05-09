#' Draw growth chart with individual data
#'
#' This function expect an input key to an object of class
#' \linkS4class{individual}, and calculates the individual data on the
#' requested growth chart.
#' @param location A url that points to the server location where the
#' parsed data are stored.
#' @param chartcode The code of the requested growth chart. If not
#' specified, the server will automatically plot child height for
#' the most recent age period.
#' @param \dots Not used
#' @inheritParams groeidiagrammen::draw_plot
#' @return tbd
#' @author Stef van Buuren 2019
#' @seealso \linkS4class{individual},
#' \code{\link[groeidiagrammen]{select_chart}}
#' \code{\link[groeidiagrammen]{draw_plot}}
#' @keywords server
#' @export
chart <- function(location = NULL, chartcode = NULL,
                  curve_interpolation = TRUE, ...) {

  # get the object stored by convert_bds_ind
  rda <- paste0(location, "R/.val/rda")
  con <- curl(rda)
  load(file = con)
  ind <- .val
  close(con)
  rm(".val")

  if (is.null(chartcode))
    chartcode <- select_chart(ind)$chartcode

  draw_plot(ind, chartcode, curve_interpolation, quiet = TRUE)
}
