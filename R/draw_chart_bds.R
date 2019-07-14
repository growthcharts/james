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
#' @rdname draw_chart
#' @examples
#' fn <- file.path(path.package("james"), "testdata", "client3.json")
#' g <- draw_chart_bds(txt = fn)
#' @keywords server
#' @export
draw_chart_bds <- function(txt = NULL, chartcode = NULL,
                           curve_interpolation = TRUE, ...) {

  individual <- convert_bds_ind(txt)

  if (is.null(chartcode))
    chartcode <- select_chart(individual)$chartcode

  draw_plot(individual, chartcode, curve_interpolation, quiet = TRUE)
}
