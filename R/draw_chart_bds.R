#' Convert bds-format data to individual and return growth chart
#'
#' The function \code{draw_chart_bds()} convert bds data into an object
#' of class \linkS4class{individual}, and then draws the
#' individual data on the requested growth chart.
#' @param txt   A JSON string, URL or file
#' @param \dots For \code{draw_chart_bds}, additional parameter passed
#'   down to \code{fromJSON(txt, ...)}, \code{new("xyz",... )} and
#'   \code{new("bse",... )}. Useful parameters are \code{models =
#'   "bsmodel"} for setting the broken stick model, or \code{call =
#'   as.call(...)} for setting proper reference standards.
#' @inheritParams chartplotter::process_chart
#' @examples
#' fn <- system.file("testdata", "client3.json", package = "james")
#' g <- draw_chart_bds(txt = fn)
#' @keywords server
#' @export
draw_chart_bds <- function(txt = "", chartcode = "",
                           curve_interpolation = TRUE, ...) {

  # legacy
  draw_chart(txt = txt, chartcode = chartcode,
             curve_interpolation = curve_interpolation)
}

