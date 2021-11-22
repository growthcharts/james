#' Draw growth chart
#'
#' The function `draw_chart()` plots individual data on the growth chart.
#' @inheritParams request_site
#' @inheritParams select_chart
#' @inheritParams chartplotter::process_chart
#' @inheritParams bdsreader::read_bds
#' @param dnr Donor data, Prediction horizon: `"0-2"`, `"2-4"`
#' or `"4-18"`. May also be `"smocc"`, `"lollypop"`,
#' `"terneuzen"` or `"pops"`.
#' @param chartcode Optional. The code of the requested growth chart.
#' @param selector Either `"chartcode"`, `"data"` or `"derive"`.
#' The function can calculate the chart code by looking at the child
#' data (method `"data"`) or user input (method `"derive"`).
#' More in detail, the following behaviour decides between growth charts:
#'   \describe{
#'   \item{`"data"`}{Calculate chart code from the individual data.
#'   This setting chooses the "optimal" chart for a given individual set of data.}
#'   \item{`"derive"`}{Calculate chart code from a combination of user
#'   data: `chartgrp`, `agegrp`, `side`, `sex`,
#'   `etn`, `ga`. The method does not use individual data. Use
#'   this setting when chart choice needs to be reactive on user input.}
#'   \item{`"chartcode"`}{Take string specified in `chartcode`}
#'   }
#' If there is a valid `tgt` object, then the function simply obeys
#' the `selector` setting. If no valid `tgt` object is found,
#' the `"chartcode"` argument is taken. However, if the `"chartcode"`
#' is empty, then the function selects method `"derive"`.
#' @param lo Value of the left visit coded as string, e.g. `"4w"`
#'   or `"7.5m"`
#' @param hi Value of the right visit coded as string, e.g. `"4w"`
#'   or `"7.5m"`
#' @param draw_grob Logical. Should chart be plotted on current device?
#' Default is `TRUE`. For internal use only.
#' @param bds_data Legacy for `txt`. Use `txt` instead.
#' @param ind_loc Legacy for `loc`. Use `loc` instead.
#' @return A `gTree` object.
#' @author Stef van Buuren 2020
#' @seealso [select_chart()]
#' @keywords server
#' @examples
#' fn <- system.file("testdata", "client3.json", package = "james")
#' g <- draw_chart(txt = fn)
#' @export
draw_chart <- function(txt = "",
                       loc = "",
                       format = "1.0",
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
                       dnr = "0-2",
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
                       ind_loc = "",
                       ...) {
  authenticate(...)

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
  dnr <- match.arg(dnr,
    choices = c(
      "0-2", "2-4", "4-18", "smocc", "lollypop",
      "terneuzen", "pops"
    )
  )

  tgt <- get_tgt(txt, loc, format = format)

  # if we have no tgt, prioritise chartcode over derive
  # except when chartcode is empty
  if (is.null(tgt) && chartcode == "") {
    chartcode <- select_chart(
      target = NULL,
      chartgrp = chartgrp,
      agegrp = agegrp,
      sex = sex,
      etn = etn,
      ga = ga,
      side = side
    )$chartcode
  } else {
    # listen to selector
    chartcode <- switch(selector,
      "data" = select_chart(target = tgt)$chartcode,
      "derive" = select_chart(
        target = NULL,
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
    target = tgt,
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
