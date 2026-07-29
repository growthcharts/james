# JAMES - A program to monitor and interpret child growth and development.
# Copyright (C) 2025 Stef van Buuren (stef.vanbuuren@tno.nl)
# Arjan Huizing (arjan.huizing@tno.nl)
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

#' Preview the child data JAMES uses internally
#'
#' Experimental "Proeftuin" endpoint: returns the person- or time-level
#' data exactly as `bdsreader` parses it, for inspection in the app.
#' @inheritParams bdsreader::read_bds
#' @inheritParams request_site
#' @return A data frame.
#' @author Stef van Buuren 2026
#' @seealso [bdsreader::persondata()], [bdsreader::timedata()]
#' @examples
#' fn <- system.file("testdata", "client3.json", package = "james")
#' preview_persondata(fn)
#' preview_timedata(fn)
#' preview_persondata()
#' @keywords server
#' @export
preview_persondata <- function(txt = "", session = "", format = "1.0", ...) {
  authenticate(...)
  tgt <- get_tgt(txt = txt, session = session, format = format)
  if (is.null(tgt)) {
    return(data.frame())
  }
  bdsreader::persondata(tgt)
}

#' @rdname preview_persondata
#' @export
preview_timedata <- function(txt = "", session = "", format = "1.0", ...) {
  authenticate(...)
  tgt <- get_tgt(txt = txt, session = session, format = format)
  if (is.null(tgt)) {
    return(data.frame())
  }
  bdsreader::timedata(tgt)
}

#' Preview growth screener results
#'
#' Experimental "Proeftuin" endpoint: thin wrapper around
#' [apply_screeners()] for the Proeftuin preview UI.
#' @inheritParams apply_screeners
#' @return A data frame.
#' @author Stef van Buuren 2026
#' @seealso [apply_screeners()]
#' @examples
#' fn <- system.file("testdata", "client3.json", package = "james")
#' preview_screeners(fn)
#' @keywords server
#' @export
preview_screeners <- function(txt = "", session = "", ...) {
  apply_screeners(txt = txt, session = session, ...)
}
