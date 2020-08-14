#' Draw growth chart
#'
#' The function \code{draw_chart()} plots individual data on the growth chart.
#' @inheritParams request_site
#' @inheritParams select_chart
#' @inheritParams chartplotter::process_chart
#' @param chartcode Optional. The code of the requested growth chart.
#' If not specified or if not valid, the function calculates the chart code
#' by the method specified by the \code{selector} argument.
#' @param selector Either \code{data} or \code{"derive"} specifying the
#' method to decide between growth charts:
#'   \describe{
#'   \item{\code{"data"}}{Calculate chart code from the individual data by
#'   \code{select_chart()} (default).}
#'   \item{\code{"derive"}}{Calculate chart code from parameters
#'   \code{chartgrp}, \code{agegrp}, \code{sex}, \code{etn}, \code{ga}
#'   and \code{side} by \code{select_chart()}.}
#'   \item{\code{"chartcode"}}{Take string specified in \code{chartcode}.}
#'   }
#' @param lo Value of the left visit coded as string, e.g. \code{"4w"}
#'   or \code{"7.5m"}
#' @param hi Value of the right visit coded as string, e.g. \code{"4w"}
#'   or \code{"7.5m"}
#' @return A \code{gTree} object.
#' @author Stef van Buuren 2020
#' @seealso \linkS4class{individual}, \code{\link{select_chart}}
#' @keywords server
#' @examples
#' fn <- system.file("testdata", "client3.json", package = "james")
#' g <- draw_chart(txt = fn)
#' @export
draw_chart <- function(txt  = NULL,
                       loc   = NULL,
                       chartcode = NULL,
                       selector  = c("data", "derive", "chartcode"),
                       chartgrp  = NULL,
                       agegrp    = NULL,
                       sex       = NULL,
                       etn       = NULL,
                       ga        = NULL,
                       side      = "hgt",
                       curve_interpolation = TRUE,
                       quiet     = FALSE,
                       dnr       =  c("smocc", "terneuzen", "lollypop.preterm",
                                      "lollypop.term", "pops"),
                       lo        = NULL,
                       hi        = NULL,
                       nmatch    = 0L,
                       exact_sex = TRUE,
                       exact_ga = FALSE,
                       break_ties = FALSE,
                       show_realized = FALSE,
                       show_future = FALSE) {
  selector <- match.arg(selector)
  dnr <- match.arg(dnr)

  ind <- get_ind(txt, loc)
  chartcode <- switch(selector,
                      "data" = select_chart(ind = ind)$chartcode,
                      "derive" = select_chart(ind = NULL,
                                              chartgrp = chartgrp,
                                              agegrp = agegrp,
                                              sex = sex,
                                              etn = etn,
                                              ga = ga,
                                              side = side)$chartcode,
                      "chartcode" = chartcode)

  # convert hi and lo into period vector
  nmatch <- as.integer(nmatch)
  period <- convert_str_age(c(lo, hi))

  # there we go..
  process_chart(individual = ind,
                chartcode = chartcode,
                curve_interpolation = curve_interpolation,
                quiet = quiet,
                dnr = dnr,
                period = period,
                nmatch = nmatch,
                exact_sex = exact_sex,
                exact_ga = exact_ga,
                break_ties = break_ties,
                show_realized = show_realized,
                show_future = show_future)
}
