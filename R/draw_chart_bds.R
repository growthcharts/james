#' Convert bds-format data to individual and return growth chart
#'
#' The function \code{draw_chart_bds()} convert bds data into an object
#' of class \linkS4class{individual}, and then draws the
#' individual data on the requested growth chart.
#' @name draw_chart_bds-deprecated
#' @param txt   A JSON string, URL or file
#' @param selector Legacy addition to solve a problem in jgzApp. See
#' \code{draw_chart} for interpretation. The default is set to
#' \code{"chartcode"}.
#' @param \dots For \code{draw_chart_bds}, additional parameter passed
#'   down to \code{fromJSON(txt, ...)}, \code{new("xyz",... )} and
#'   \code{new("bse",... )}. Useful parameters are \code{models =
#'   "bsmodel"} for setting the broken stick model, or \code{call =
#'   as.call(...)} for setting proper reference standards.
#' @inheritParams chartplotter::process_chart
#' @note Deprecated. Please use the more comprehensive \code{\link{draw_chart}}
#' function.
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

  draw_chart(txt = txt, chartcode = chartcode,
             curve_interpolation = curve_interpolation,
             selector = selector)
}

