# JAMES - A program to monitor and interpret child growth and development.
# Copyright (C) 2022 Stef van Buuren (stef.vanbuuren@tno.nl)
# Arjan Huizing (arjan.huizing@tno.nl)
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

#' Provides additional information on percentiles of D-score and age in months
#' for the percentiles 2, 10, 50, 90 and 98. User either provides known van
#' Wiechen milestones, or information to calculate the recommended van Wiechen
#' milestones based on age and past milestones.
#'
#' @inheritParams calculate_dscore
#' @param p Reference percentile indicating the expected probability of a
#'   positive van Wiechen outcome given child age. Higher values correspond with
#'   easier items.
#' @param n Number of van Wiechen items to suggest. By default returns all items
#'   within set probability limits.
#' @param vwc Vector of string values matching van Wiechen milestones. Bypasses
#'   calculations and directly supply the milestones of interest
#' @inheritParams bdsreader::read_bds
#' @return A table.
#' @author Arjan Huizing 2025
#' @examples
#' fn <- system.file("testdata", "Laura_S.json", package = "james")
#' percentiles_vwc(txt = fn, p = 50, n = 3)
#' @export
percentiles_vwc <- function(txt = "",
                       p = 90,
                       n = 6,
                       vwc = NULL,
                       session = "",
                       format = "1.0",
                       loc = "",
                       percentiles = FALSE,
                       ...) {
  authenticate(...)
  daz <- d <- NULL

  if (!is.null(vwc)) return(vwc::vwc_percentiles(vwc))


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

  if ("dsc" %in% time[time$age == max(time$age), "yname"]) {
    d <- unlist(time[time$age == max(time$age) & time$yname == "dsc", "y"])
    # Confirm with Iris if this adds anything:
    # daz <- unlist(time[time$age == max(time$age) & time$yname == "dsc", "z"])
  }

  vwc <- vwc::select_vwc(age = max(time$age),
                         p = p,
                         d = d,
                         daz = daz,
                         n = n,
                         passed_items = time[time$y == 1.00, ]$yname)

  return(vwc::vwc_percentiles(vwc))
}
