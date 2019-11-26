#' Draw growth chart with individual data
#'
#' The function \code{draw_chart_ind()} expect an input location from
#' a previous call, and plots the individual data on the requested
#' growth chart.
#' @rdname draw_chart
#' @inheritParams draw_chart
#' @seealso \linkS4class{individual},
#' \code{\link{select_chart}}
#' \code{\link[chartplotter]{process_chart}}
#' @keywords server
#' @export
draw_chart_ind <- function(ind_loc = NULL, chartcode = NULL,
                           curve_interpolation = TRUE, ...) {

  # assign object stored by convert_bds_ind to ind
  if (length(ind_loc) == 0L) individual <- NULL
  else {
    con <- curl(paste0(ind_loc, "R/.val/rda"))
    load(file = con)
    individual <- .val
    close(con)
    rm(".val")
  }

  if (is.null(chartcode))
    chartcode <- select_chart(individual)$chartcode

  process_chart(individual, chartcode, curve_interpolation, quiet = TRUE)
}
