#' Derive advice on chart choice from data
#'
#' The function loads individual data from an url,
#' calculates the chartcode and returns a list of parsed chartcode
#' and age range of the data.
#' The function is called at initialization to automate setting
#' of proper chart and analysis defaults according to the child data.
#' @inheritParams draw_chart
#' @return A list with the following elements
#' \describe{
#'    \item{`population`}{A string identifying the population,
#'    e.g. `'NL'`,`'MA'`, `'TU'` or `'PT'`.}
#'    \item{`sex`}{A string `"male"`, `"female"` or
#'    `"undifferentiated"`.}
#'    \item{`design`}{A letter indicating the chart design: `'A'` = 0-15m,
#'    `'B'` = 0-4y, `'C'` = 1-21y, `'D'` = 0-21y, `'E'` =
#'    0-4ya.}
#'    \item{`side`}{A string indicating the side or `yname`:
#'    `'front'`, `'back'`, `'both'`, `'hgt'`,
#'    `'wgt'`, `'hdc'`, `'bmi'`, `'wfh'`}
#'    \item{`language`}{The language in which the chart is drawn. Currently only
#'    `"dutch"` charts are implemented, but for `population == "PT"` we
#'    may also have `"english"`.}
#'    \item{`week`}{A scalar indicating the gestational age at birth.
#'    Only used if `population == "PT"`.}
#'    \item{`chartcode`}{A string indicating the chart code.}
#'    \item{`chartgrp`}{A string indicating the chart group, either `"nl2010"`,
#'    `"preterm"` or `"who"`.}
#'    \item{`agegrp`}{A string indicating the age group, either `"0-15m"`,
#'    `"0-4y"`, `"1-21y"` or `"0-21y"`.}
#'    \item{`dnr`}{A string indicating the donor dataset for matching, either `"smocc"`,
#'    `"lollypop"`, `"terneuzen"` or `"pops"`.}
#'    \item{`slider_list`}{A string indicating the set of slider labels, either `"0_2"`,
#'    `"0_4"` or `"0_29"`.}
#'    \item{`period`}{A character vector of two elements, indicating the first and last period for the
#'    matching analysis, e.g. like `c("3m", "14m")`.}
#'    }
#' @author Stef van Buuren 2020
#' @seealso [chartcatalog::parse_chartcode()]
#' @keywords server
#' @export
convert_tgt_chartadvice <- function(txt = "", loc = "",
                                    format = 2L,
                                    chartcode = "",
                                    selector = c("data", "chartcode"),
                                    ind_loc = "") {
  if (!missing(ind_loc)) {
    warning("Argument ind_loc is deprecated; please use loc instead.",
      call. = FALSE
    )
  }

  # legacy
  if (!is.empty(ind_loc)) loc <- ind_loc

  selector <- match.arg(selector)
  tgt <- get_tgt(txt = txt, loc = loc, format = format)
  chartcode <- switch(selector,
    "data" = select_chart(target = tgt)$chartcode,
    "chartcode" = chartcode
  )

  initializer(selector, tgt, chartcode)
}
