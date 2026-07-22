# JAMES - A program to monitor and interpret child growth and development.
# Copyright (C) 2025 Stef van Buuren (stef.vanbuuren@tno.nl)
# Arjan Huizing (arjan.huizing@tno.nl)
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

#' Draw an interactive, embeddable growth chart
#'
#' `embed_chart()` is the interactive counterpart to [draw_chart()]:
#' instead of drawing a static chart to a graphics device (served by
#' OpenCPU as SVG/PNG/PDF), it writes a self-contained HTML document (a
#' `plotly` widget) into the OpenCPU session's working directory, so it
#' can be fetched at the session's `files/widget.html` path and embedded
#' in an `<iframe>` (not an `<img>` -- OpenCPU has no dedicated htmlwidget
#' mechanism, so this relies on its generic `files/` static-file serving).
#'
#' @inheritParams draw_chart
#' @param ytype Vertical axis metric: `"y"` (original units), `"z"`
#'   (SD score) or `"p"` (percentile).
#' @param show_matches Logical. Show donor curve matches (grey lines)?
#' @param show_prediction Logical. Show the predicted future growth curve?
#' @param show_targetheight Logical. Show the target height range/estimate
#'   (design "C"/"D" charts only, requires parental height data). Default
#'   `TRUE`.
#' @return Invisibly, the path to the written `widget.html` file. Called
#'   for its side effect of writing the file into the session directory.
#' @author Stef van Buuren 2026
#' @seealso [draw_chart()], [select_chart()]
#' @keywords server
#' @examples
#' fn <- system.file("testdata", "client3.json", package = "james")
#' old <- setwd(tempdir())
#' fig <- embed_chart(txt = fn)
#' setwd(old)
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
  htmlwidgets::saveWidget(widget, "widget.html", selfcontained = TRUE)
  invisible("widget.html")
}
