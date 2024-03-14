# JAMES - A program to monitor and interpret child growth and development.
# Copyright (C) 2022 Stef van Buuren (stef.vanbuuren@tno.nl)
# Arjan Huizing (arjan.huizing@tno.nl)
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

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
#'    `"preterm"`, `"who"`, `"gsed1"`, `"gsed1pt"`.}
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
convert_tgt_chartadvice <- function(txt = "",
                                    session = "",
                                    format = "1.0",
                                    chartcode = "",
                                    selector = c("data", "chartcode"),
                                    loc = "",
                                    ind_loc = "",
                                    ...) {
  authenticate(...)

  if (!missing(ind_loc) && missing(session)) {
    warning("Argument ind_loc is deprecated and will disappear in Nov 2022; please use session instead.",
            call. = FALSE
    )
    session <- loc2session(ind_loc)
  }

  if (!missing(loc) && missing(session)) {
    warning("Argument loc is deprecated and will disappear in Nov 2022; please use session instead.",
            call. = FALSE
    )
    session <- loc2session(loc)
  }

  selector <- match.arg(selector)

  # give priority of specified chartcode
  if (chartcode != "") selector <- "chartcode"

  # read data if needed, set emergency chartcode in case of no data
  if (selector == "data") {
    tgt <- get_tgt(txt = txt,
                   session = session,
                   format = format)
    if (!is.null(tgt)) {
      chartcode <- select_chart(target = tgt)$chartcode
    } else {
      chartcode <- "NJAH"
      warning("No data found. chartcode set to NJAH.")
    }
  }

  initializer(selector, tgt, chartcode)
}
