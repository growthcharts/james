# JAMES - A program to monitor and interpret child growth and development.
# Copyright (C) 2022 Stef van Buuren (stef.vanbuuren@tno.nl)
# Arjan Huizing (arjan.huizing@tno.nl)
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

#' Provides multiple outputs in one request
#'
#' Function `request_blend()` acts as a one-stop-shop to obtain multiple
#' outputs through one request.
#' @inheritParams request_site
#' @param blend A string indicating the requested blend. The default (`"standard"`)
#' returns the results of the standard end points that produces tables. Graphs
#' are currently not supported.
#' @return The default `blend = "standard"` return a list with the following
#' components:
#' \describe{
#'   \item{`txt`}{String, file or URL with child data}
#'   \item{`session`}{Session with uploaded child data}
#'   \item{`child`}{Processed child level data}
#'   \item{`time`}{Processed time level data}
# #'   \item{`chart`}{SVG of growth chart}
#'   \item{`screeners`}{Results from application of screeners to child data}
#'   \item{`site`}{URL with personalised child data}
#' }
#' @examples
#' \dontrun{
#' fn <- system.file("extdata", "bds_v2.0", "smocc", "Laura_S.json", package = "jamesdemodata")
#' results <- request_blend(txt = fn)
#' }
#' @export
request_blend <- function(txt = "",
                          sitehost = "",
                          session = "",
                          blend = "standard",
                          loc = "",
                          ...) {
  authenticate(...)

  if (!missing(loc)) {
    warning("Argument loc is deprecated and will disappear in Nov 2022; please use session instead.",
            call. = FALSE
    )
    session <- loc2session(loc)
  }

  if (blend == "standard") {
    return(request_blend_standard(txt = txt, sitehost = sitehost, session = session, ...))
  }

  stop("blend", blend, "not found.")
}

request_blend_standard <- function(txt, sitehost, session, ...) {
  site <- request_site(txt = txt, sitehost = sitehost, session = session, ...)
  session <- strsplit(site, "?session=", fixed = TRUE)[[1]][2]
  if (is.na(session)) session <- ""
  tgt <- get_tgt(session = session)

  # render chart as svg
  #chart <- draw_chart(loc = loc, draw_grob = FALSE, ...)
  #sidecode <- substr(chart$name, 4L, 4L)
  #if (sidecode %in% c("A", "B", "C", "X")) {
  #  width <- 8.27
  #  height <- 11.69
  #} else {
  #  width <- 7.09
  #  height <- 7.09
  #}
  #s <- svglite::svgstring(width = width, height = height)
  #grid.draw(chart)
  #dev.off()

  screeners <- apply_screeners(session = session, ...)

  result <- list(
    txt = unbox(txt),
    session = unbox(session),
    site = unbox(site),
    child = persondata(tgt),
    time = timedata(tgt),
#    chart = s(),
    screeners = screeners
  )
  return(result)
}

