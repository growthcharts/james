#' Draw growth chart
#'
#' The function \code{draw_chart()} plots individual data on the growth chart.
#' @inheritParams request_site
#' @inheritParams select_chart
#' @inheritParams chartplotter::process_chart
#' @param chartcode Optional. The code of the requested growth chart.
#' @param selector Either \code{"chartcode"}, \code{"data"} or \code{"derive"}.
#' The function can calculate the chart code by looking at the child
#' data (method \code{"data"}) or user input (method \code{"derive"}).
#' More in detail, the following behaviour decides between growth charts:
#'   \describe{
#'   \item{\code{"data"}}{Calculate chart code from the individual data.
#'   This setting chooses the "optimal" chart for a given individual set of data.}
#'   \item{\code{"derive"}}{Calculate chart code from a combination of user
#'   data: \code{chartgrp}, \code{agegrp}, \code{side}, \code{sex},
#'   \code{etn}, \code{ga}. The method does not use individual data. Use
#'   this setting when chart choice needs to be reactive on user input.}
#'   \item{\code{"chartcode"}}{Take string specified in \code{chartcode}}
#'   }
#' If there is a valid \code{ind} object, then the function simply obeys
#' the \code{selector} setting. If no valid \code{ind} object is found,
#' the \code{"chartcode"} argument is taken. However, if the \code{"chartcode"}
#' is empty, then the function selects method \code{"derive"}.
#' @param lo Value of the left visit coded as string, e.g. \code{"4w"}
#'   or \code{"7.5m"}
#' @param hi Value of the right visit coded as string, e.g. \code{"4w"}
#'   or \code{"7.5m"}
#' @param draw_grob Logical. Should chart be plotted on current device?
#' Default is \code{TRUE}. For internal use only.
#' @param bds_data Legacy for \code{txt}. Use \code{txt} instead.
#' @param ind_loc Legacy for \code{loc}. Use \code{loc} instead.
#' @return A \code{gTree} object.
#' @author Stef van Buuren 2020
#' @seealso \linkS4class{individual}, \code{\link{select_chart}}
#' @keywords server
#' @examples
#' fn <- system.file("testdata", "client3.json", package = "james")
#' g <- draw_chart(txt = fn)
#' @export
draw_chart <- function(txt = "",
                       loc = "",
                       chartcode = "",
                       selector = c("data", "derive", "chartcode"),
                       chartgrp = NULL,
                       agegrp = NULL,
                       sex = NULL,
                       etn = NULL,
                       ga = NULL,
                       side = "hgt",
                       curve_interpolation = TRUE,
                       quiet = FALSE,
                       dnr = c("smocc", "terneuzen", "lollypop", "pops"),
                       lo = NULL,
                       hi = NULL,
                       nmatch = 0L,
                       exact_sex = TRUE,
                       exact_ga = FALSE,
                       break_ties = FALSE,
                       show_realized = FALSE,
                       show_future = FALSE,
                       draw_grob = TRUE,
                       bds_data = "",
                       ind_loc = "") {
  if (!missing(bds_data)) {
    warning("Argument bds_data is deprecated; please use txt instead.",
      call. = FALSE
    )
  }
  if (!missing(ind_loc)) {
    warning("Argument ind_loc is deprecated; please use loc instead.",
      call. = FALSE
    )
  }

  # legacy
  if (!is.empty(bds_data)) txt <- bds_data
  if (!is.empty(ind_loc)) loc <- ind_loc

  selector <- match.arg(selector)
  dnr <- match.arg(dnr)

  ind <- get_ind(txt, loc)

  # if we have no ind, prioritise chartcode over derive
  # except when chartcode is empty
  if (is.null(ind)) {
    if (chartcode == "") {
      chartcode <- select_chart(
        ind = NULL,
        chartgrp = chartgrp,
        agegrp = agegrp,
        sex = sex,
        etn = etn,
        ga = ga,
        side = side
      )$chartcode
    }
  } else {
    # listen to selector
    chartcode <- switch(selector,
      "data" = select_chart(ind = ind)$chartcode,
      "derive" = select_chart(
        ind = NULL,
        chartgrp = chartgrp,
        agegrp = agegrp,
        sex = sex,
        etn = etn,
        ga = ga,
        side = side
      )$chartcode,
      "chartcode" = chartcode
    )
  }

  # convert hi and lo into period vector
  nmatch <- as.integer(nmatch)
  period <- convert_str_age(c(lo, hi))

  # there we go..
  g <- process_chart(
    individual = ind,
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
    show_future = show_future
  )
  if (draw_grob) grid.draw(g)
  invisible(g)
}
