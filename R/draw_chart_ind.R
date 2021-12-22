#' Draw growth chart with individual data
#'
#' The function `draw_chart_ind()` expect an input location from
#' a previous call, and plots the individual data on the requested
#' growth chart.
#' @name draw_chart_ind-deprecated
#' @inheritParams draw_chart
#' @note Deprecated. Please use the more comprehensive [draw_chart()]
#' function.
#' @seealso [select_chart()]
#' [chartplotter::process_chart()]
#' @keywords server
#' @export
draw_chart_ind <- function(loc = "", chartcode = "",
                           curve_interpolation = TRUE, ...) {
  authenticate(...)
  .Deprecated("draw_chart",
    msg = "draw_chart_ind() is deprecated and will disappear in Sept 2022. Please use draw_chart() instead."
  )

  # legacy
  draw_chart(
    loc = loc, chartcode = chartcode,
    curve_interpolation = curve_interpolation,
    ...
  )
}
