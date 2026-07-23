# JAMES - A program to monitor and interpret child growth and development.
# Copyright (C) 2025 Stef van Buuren (stef.vanbuuren@tno.nl)
# Arjan Huizing (arjan.huizing@tno.nl)
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

#' Draw an interactive, embeddable growth chart
#'
#' `embed_chart()` is the interactive counterpart to [draw_chart()]:
#' instead of drawing a static chart to a graphics device (served by
#' OpenCPU as SVG/PNG/PDF), it returns a self-contained HTML document (a
#' `plotly` widget) as a character string, retrievable at the session's
#' `R/.val/text` path and meant for embedding via `<iframe srcdoc="...">`
#' (not an `<img>` -- it is not an image, and not a plain file either:
#' OpenCPU does not persist files written by session code, so the HTML is
#' returned as the call's value instead). The document references
#' plotly.js and jQuery from a public CDN (see
#' [multikaart::save_widget_cdn()]) rather than inlining them, so it
#' requires a live internet connection to render, but is far smaller
#' (well under 250KB, vs. ~1.2MB fully self-contained).
#'
#' @inheritParams draw_chart
#' @param ytype Vertical axis metric: `"y"` (original units), `"z"`
#'   (SD score) or `"p"` (percentile).
#' @param show_matches Logical. Show donor curve matches (grey lines)?
#' @param show_prediction Logical. Show the predicted future growth curve?
#' @param show_targetheight Logical. Show the target height range/estimate
#'   (design "C"/"D" charts only, requires parental height data). Default
#'   `TRUE`.
#' @return A length-1 character string: the self-contained HTML document.
#' @author Stef van Buuren 2026
#' @seealso [draw_chart()], [select_chart()]
#' @keywords server
#' @examples
#' fn <- system.file("testdata", "client3.json", package = "james")
#' html <- embed_chart(txt = fn)
#' @export
embed_chart <- function(
  txt = "",
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
  ytype = c("y", "z", "p"),
  curve_interpolation = TRUE,
  quiet = FALSE,
  dnr = NULL,
  lo = NULL,
  hi = NULL,
  nmatch = 0L,
  exact_sex = TRUE,
  exact_ga = FALSE,
  break_ties = FALSE,
  show_realized = FALSE,
  show_future = FALSE,
  show_matches = FALSE,
  show_prediction = FALSE,
  show_targetheight = TRUE,
  ...
) {
  authenticate(...)

  selector <- match.arg(selector)
  ytype <- match.arg(ytype)
  tgt <- get_tgt(txt = txt, session = session, format = format)

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
    chartcode <- switch(
      selector,
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

  chart <- multikaart::load_chart(chartcode)

  # only prepare child data/curves when we actually have a target
  data <- NULL
  child <- NULL
  if (!is.null(tgt)) {
    data <- multikaart::set_data(
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
    child <- bdsreader::persondata(tgt)
  }

  fig <- plot(
    chart,
    data = data,
    ytype = ytype,
    show_matches = show_matches,
    show_prediction = show_prediction,
    show_realized = show_realized,
    period = period,
    child = child,
    target_height = list(show = show_targetheight, alpha = 0.95)
  )

  widget <- multikaart::unwrap_widget(fig)
  tmp <- tempfile(fileext = ".html")
  on.exit(unlink(tmp))
  multikaart::save_widget_cdn(widget, tmp)
  paste(readLines(tmp, warn = FALSE), collapse = "\n")
}
