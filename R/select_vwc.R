# JAMES - A program to monitor and interpret child growth and development.
# Copyright (C) 2022 Stef van Buuren (stef.vanbuuren@tno.nl)
# Arjan Huizing (arjan.huizing@tno.nl)
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

#' Calculates the recommended van Wiechen milestones based on age and past
#' milestones
#'
#' @inheritParams calculate_dscore
#' @param refperc Reference percentile indicating the expected probability of a
#'   positive van Wiechen outcome given child age. Higher values correspond with
#'   easier items.
#' @param nsuggest Number of van Wiechen items to suggest.
#' @param percentiles When `FALSE` (default), return a string vector containing
#'   recommended van Wiechen items. When `TRUE`, returns a table with columns
#'   `"item"` and `"D"` (D-score) and `"A"` (Age in months) columns for the
#'   percentiles 2, 10, 50, 90 and 98.
#' @inheritParams bdsreader::read_bds
#' @return A vector or table.
#' @author Arjan Huizing 2025
#' @examples
#' fn <- system.file("testdata", "Laura_S_dev.json", package = "james")
#' vwc <- select_vwc(txt = fn, refperc = 50)
#' @export
select_vwc <- function(txt = "",
                       refperc = 90,
                       nsuggest = 6,
                       session = "",
                       format = "1.0",
                       loc = "",
                       percentiles = FALSE,
                       ...) {
  authenticate(...)

  if (!missing(loc)) {
    warning("Argument loc is deprecated and will disappear in Nov 2022; please use session instead.",
            call. = FALSE
    )
    session <- loc2session(loc)
  }

  tgt <- get_tgt(txt = txt,
                 session = session,
                 format = format,
                 append_ddi = TRUE)

  if (!is.list(tgt)) {
    message("Cannot calculate VWC items")
    return(NULL)
  }
  time <- timedata(tgt)

  vwc <- vwc::select_vwc(age = max(time$age),
                    refperc = refperc,
                    nsuggest = nsuggest,
                    passed_items = time)

  if (percentiles) return(vwc::vwc_percentiles(vwc))
  return(unique(vwc))
}
