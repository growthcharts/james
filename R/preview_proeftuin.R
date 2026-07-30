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
  time <- bdsreader::timedata(tgt)
  # Most recent measurement first within each measure, so a caregiver
  # scanning the table sees the current state before scrolling to history.
  time[order(time$yname, -time$age), ]
}

#' Preview growth screener results at every measurement occasion
#'
#' Experimental "Proeftuin" endpoint: unlike [apply_screeners()], which
#' screens once using the single most recent measurement per `yname` (with
#' all earlier ones as context), this re-screens at every occasion,
#' truncating the time series to that occasion and treating it as if it
#' were the most recent one. This surfaces how the advice for each measure
#' would have read at each point in time, not just the current one.
#' @inheritParams apply_screeners
#' @return A data frame with one row per (measure, occasion) combination,
#' sorted by `CategorieOmschrijving` and descending `Leeftijd` (most recent
#' occasion first).
#' @author Stef van Buuren 2026
#' @seealso [apply_screeners()]
#' @examples
#' fn <- system.file("testdata", "client3.json", package = "james")
#' preview_screeners(fn)
#' @keywords server
#' @export
preview_screeners <- function(
  txt = "",
  session = "",
  format = "1.0",
  ynames = c("hgt", "wgt", "hdc"),
  na.omit = TRUE,
  ...
) {
  authenticate(...)
  tgt <- get_tgt(txt = txt, session = session, format = format)
  if (is.null(tgt)) {
    return(data.frame())
  }

  results <- list()
  for (yname in ynames) {
    ages <- sort(unique(tgt$xyz$age[tgt$xyz$yname == yname]))
    for (age in ages) {
      tgt_cut <- tgt
      tgt_cut$xyz <- tgt$xyz[tgt$xyz$age <= age, ]
      results[[length(results) + 1]] <- growthscreener::screen_curves_ind(
        ind = tgt_cut,
        ynames = yname,
        na.omit = na.omit,
        ...
      )
    }
  }
  if (!length(results)) {
    return(data.frame())
  }
  out <- do.call(rbind, results)
  out[order(out$CategorieOmschrijving, -out$Leeftijd), ]
}
