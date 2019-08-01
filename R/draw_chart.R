#' Draw growth chart
#'
#' The function \code{draw_chart()} can read data from an input
#' location from a previous call, calculate the chartcode, and plot
#' the individual data on the requested growth chart.
#' @param bds_data A JSON string, URL or file. Optional.
#' @param ind_loc  A url that points to the server location where the
#'   data from a previous request to \code{convert_bds_ind()} are
#'   stored. Optional. \code{ind_loc} takes priority over
#'   \code{bds_data}.
#' @param chartcode The code of the requested growth chart, in the
#'   case the \code{selector == "chartcode"}.
#' @param selector A string, either \code{"derive"}, \code{"data"} or
#'   \code{"chartcode"}, that indicates the method to decide which
#'   growth chart is drawn. Method \code{"derive"} (default)
#'   calculates the chart from parameters \code{chartgrp},
#'   \code{agegrp}, \code{sex}, \code{etn}, \code{ga} and \code{side}
#'   parameters through the \code{select_chart()} function. Method
#'   \code{"ind"} calculates the chart from the individual data.
#'   Method \code{"chartcode"} will return the chart specified by the
#'   \code{chartcode} parameter.
#' @param curve_interpolation A logical indicating whether curve
#'   interpolation shoud be applied.
#' @param lo Value of the left visit coded as string, e.g. \code{"4w"}
#'   or \code{"7.5m"}
#' @param hi Value of the right visit coded as string, e.g. \code{"4w"}
#'   or \code{"7.5m"}
#' @inheritParams select_chart
#' @rdname draw_chart
#' @return tbd
#' @author Stef van Buuren 2019
#' @seealso \linkS4class{individual}, \code{\link{select_chart}}
#' @keywords server
#' @export
draw_chart <- function(bds_data  = NULL,
                       ind_loc   = NULL,
                       selector  = c("derive", "data", "chartcode"),
                       chartcode = NULL,
                       chartgrp  = NULL,
                       agegrp    = NULL,
                       sex       = NULL,
                       etn       = NULL,
                       ga        = NULL,
                       side      = "hgt",
                       curve_interpolation = TRUE,
                       dnr       =  c("smocc", "terneuzen", "lollypop.preterm",
                                      "lollypop.term"),
                       lo        = NULL,
                       hi        = NULL,
                       nmatch    = NULL,
                       exact_sex = TRUE,
                       exact_ga = FALSE,
                       break_ties = FALSE,
                       show_realized = FALSE,
                       show_future = FALSE,
                       ...) {
  selector <- match.arg(selector)
  dnr <- match.arg(dnr)

  # create or load object `ind`
  if (length(ind_loc) == 0L) {
    if (length(bds_data) == 0L) ind <- NULL
    else ind <- convert_bds_individual(bds_data)
  }
  else {
    con <- curl(paste0(ind_loc, "R/.val/rda"))
    load(file = con)
    ind <- .val
    close(con)
    rm(".val")
  }

  # create chartcode using selector
  cc <- switch(selector,
               "derive" = select_chart(
                 ind = NULL, chartgrp = chartgrp, agegrp = agegrp,
                 sex = sex, etn = etn, ga = ga, side = side)$chartcode,
               "data" = select_chart(ind = ind)$chartcode,
               "chartcode" = chartcode)

  # convert hi and lo into period vector
  nmatch <- as.integer(nmatch)
  period <- convert_str_age(c(lo, hi))

  # there we go..
  draw_plot(individual = ind,
            chartcode = cc,
            curve_interpolation = curve_interpolation,
            quiet = TRUE,
            dnr = dnr,
            period = period,
            nmatch = nmatch,
            exact_sex = exact_sex,
            exact_ga = exact_ga,
            break_ties = break_ties,
            show_realized = show_realized,
            show_future = show_future)
}
