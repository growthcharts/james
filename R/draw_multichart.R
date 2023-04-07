#' Draw interactive flat growth chart
#'
#' The function `draw_multichart()` plots individual data on the flat growth chart.
#' @inheritParams draw_chart
#' @examples
#' fn <- system.file("testdata", "client3.json", package = "james")
#' g <- draw_multichart(txt = fn)
#' @export
draw_multichart <- function(txt = "",
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
                       draw_grob = TRUE,
                       ...) {
  authenticate(...)

  selector <- match.arg(selector)
  tgt <- get_tgt(txt = txt,
                 session = session,
                 format = format)

  # if we have no tgt, prioritise chartcode over derive
  # except when chartcode is empty
  chartcode <- chartcode[1L]
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

  # there we go..
  g <- process_multichart(
    target = tgt,
    chartcode = chartcode,
    ...)
  if (draw_grob) grid.draw(g)
  invisible(g)
}

process_multichart <- function(target, chartcode, ...){}
