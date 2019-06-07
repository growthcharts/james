#' Draw growth chart with individual data
#'
#' The function \code{draw_chart_ind()} expect an input location from
#' a previous call, and plots the individual data on the requested
#' growth chart.
#' @param location A url that points to the server location where the
#' data from a previous request to \code{convert_bds_ind()} are stored.
#' @param chartcode The code of the requested growth chart. If not
#' specified, the server will automatically plot child height for
#' the most recent age period.
#' @rdname draw_chart
#' @return tbd
#' @author Stef van Buuren 2019
#' @seealso \linkS4class{individual},
#' \code{\link[groeidiagrammen]{select_chart}}
#' \code{\link[groeidiagrammen]{draw_plot}}
#' @keywords server
#' @export
draw_chart_ind <- function(location = NULL, chartcode = NULL,
                           curve_interpolation = TRUE, ...) {

  # assign object stored by convert_bds_ind to ind
  browser()
  if (is.null(location)) ind <- NULL
  else {
    con <- curl(paste0(location, "R/.val/rda"))
    load(file = con)
    ind <- .val
    close(con)
    rm(".val")
  }

  if (is.null(chartcode))
    chartcode <- select_chart(ind)$chartcode

  draw_plot(ind, chartcode, curve_interpolation, quiet = TRUE)
}
