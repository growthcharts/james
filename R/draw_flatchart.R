#' Draw flat growth chart
#'
#' The function `draw_flatchart()` plots individual data on the flat growth chart.
#' @param ynames A character vector with outcomes to plot
#' @inheritParams draw_chart
#' @examples
#' fn <- system.file("testdata", "client3.json", package = "james")
#' g <- draw_flatchart(txt = fn)
#' @export
draw_flatchart <- function(txt = "",
                           session = "",
                           format = "1.0",
                           chartcode = "",
                           selector = c("data", "derive", "chartcode"),
                           chartgrp = NULL,
                           agegrp = NULL,
                           sex = NULL,
                           etn = NULL,
                           ga = NULL,
                           side = "hgt",
                           ynames = "hgt",
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
                           plot_library = c("plotly", "ggplot"),
                           ...) {

  selector <- match.arg(selector)
  side <- side[1L]
  ynames <- union(side, ynames)
  ynames <- intersect(ynames, c("hgt", "wgt", "wfh", "bmi", "hdc", "dsc"))
  dnr <- match.arg(dnr,
                   choices = c(
                     "0-2", "2-4", "4-18", "smocc", "lollypop",
                     "terneuzen", "pops"
                   ))
  plot_library <- match.arg(plot_library)

  # get child data
  tgt <- get_tgt(txt = txt,
                 session = session,
                 format = format)

  # create vector chartcodes from user interaction
  chartcodes <- rep("", length(ynames))
  for (i in seq_along(ynames)) {
    if (is.null(tgt) && chartcode == "") {
      chartcodes[cc] <- select_chart(
        target = NULL,
        chartgrp = chartgrp,
        agegrp = agegrp,
        sex = sex,
        etn = etn,
        ga = ga,
        side = ynames[i]
      )$chartcode
    } else {
      # listen to selector
      chartcodes[cc] <- switch(selector,
                              "data" = select_chart(target = tgt)$chartcode,
                              "derive" = select_chart(
                                target = NULL,
                                chartgrp = chartgrp,
                                agegrp = agegrp,
                                sex = sex,
                                etn = etn,
                                ga = ga,
                                side = ynames[i]
                              )$chartcode,
                              "chartcode" = chartcode
      )
    }
  }

  # convert hi and lo into period vector
  nmatch <- as.integer(nmatch)
  period <- convert_str_age(c(lo, hi))

  # there we go..
  g <- process_flatchart(
    target = tgt,
    chartcodes = chartcodes,
    plot_library = plot_library,
    ...)
}

