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
  if (draw_grob) print(g)
  invisible(g)
}

process_multichart <- function(target, chartcode, ...){

  x <- c(1:15)
  y <- c(10, 20, NA, 15, 10, 5, 15, NA, 20, 10, 10, 15, 25, 20, 10)

  data <- data.frame(x, y)

  fig <- plot_ly(data, x = ~x, y = ~y, name = "Gaps", type = 'scatter', mode = 'lines')
  fig <- fig %>%
    add_trace(y = ~y - 5, name = "<b>No</b> Gaps", connectgaps = TRUE)
  fig
}
