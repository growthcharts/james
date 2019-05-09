#' Convert bds-format data to individual and return growth chart
#'
#' This function takes data from a json source and saves as a an object
#' of class \linkS4class{individual}. The function then draws the
#' individual data on the requested growth chart.
#' @param txt       A JSON string, URL or file
#' @param chartcode The code of the requested growth chart. If not
#' specified, the server will automatically plot child height for
#' the most recent age period.
#' @inheritParams groeidiagrammen::draw_plot
#' @param \dots Additional parameter passed down to
#'   \code{fromJSON(txt, ...)}, \code{new("xyz",... )} and
#'   \code{new("bse",... )}. Useful parameters are \code{models =
#'   "bsmodel"} for setting the broken stick model, or \code{call =
#'   as.call(...)} for setting proper reference standards.
#' @return -specify-
#' @author Stef van Buuren 2019
#' @seealso \linkS4class{individual},
#' \code{\link[groeidiagrammen]{select_chart}}
#' \code{\link[groeidiagrammen]{draw_plot}}
#' @examples
#' fn <- file.path(path.package("james"), "testdata", "client3.json")
#' g <- draw_chart_bds(txt = fn)
#' @keywords server
#' @export
draw_chart_bds <- function(txt = NULL, chartcode = NULL,
                           curve_interpolation = TRUE, ...) {

  ind <- convert_bds_ind(txt)

  if (is.null(chartcode))
    chartcode <- select_chart(ind)$chartcode

  draw_plot(ind, chartcode, curve_interpolation, quiet = TRUE)
}
