#' Convert bds-format data to individual and return growth chart
#'
#' The function `draw_chart_bds()` convert bds data into an object
#' of class individual, and then draws the
#' individual data on the requested growth chart.
#' Superseded by [draw_chart()].
#' @name draw_chart_bds-deprecated
#' @param txt   A JSON string, URL or file
#' @param selector Legacy addition to solve a problem in jgzApp. See
#' `draw_chart` for interpretation. The default is set to
#' `"chartcode"`.
#' @param \dots For `draw_chart_bds`, additional parameter passed
#'   down to `fromJSON(txt, ...)`, `new("xyz",... )` and
#'   `new("bse",... )`. Useful parameters are `models =
#'   "bsmodel"` for setting the broken stick model, or `call =
#'   as.call(...)` for setting proper reference standards.
#' @inheritParams chartplotter::process_chart
#' @examples
#' fn <- system.file("testdata", "client3.json", package = "james")
#' g <- draw_chart_bds(txt = fn)
#' @keywords server
#' @export
draw_chart_bds <- function(txt = "", chartcode = "",
                           curve_interpolation = TRUE,
                           selector = "chartcode", ...) {

  # legacy
  .Deprecated("draw_chart",
    msg = "draw_chart_bds() is deprecated. Please use draw_chart() instead."
  )

  draw_chart(
    txt = txt, chartcode = chartcode,
    curve_interpolation = curve_interpolation,
    selector = selector
  )
}
