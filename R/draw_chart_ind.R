#' Draw growth chart with individual data
#'
#' The function \code{draw_chart_ind()} expect an input location from
#' a previous call, and plots the individual data on the requested
#' growth chart.
#' @inheritParams draw_chart
#' @seealso \linkS4class{individual},
#' \code{\link{select_chart}}
#' \code{\link[chartplotter]{process_chart}}
#' @keywords server
#' @export
draw_chart_ind <- function(loc = "", chartcode = "",
                           curve_interpolation = TRUE, ...) {

  # legacy
  draw_chart(loc = loc, chartcode = chartcode,
             curve_interpolation = curve_interpolation)
}
