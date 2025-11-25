# JAMES - A program to monitor and interpret child growth and development.
# Copyright (C) 2022 Stef van Buuren (stef.vanbuuren@tno.nl)
# Arjan Huizing (arjan.huizing@tno.nl)
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

#' Calculates the recommended van Wiechen milestones based on age and past
#' milestones
#'
#' @inheritParams calculate_dscore
#' @param p Reference percentile indicating the expected probability of a
#'   positive van Wiechen outcome given child age. Higher values correspond with
#'   easier items.
#' @param n Number of van Wiechen items to suggest. By default returns all items
#'   within set probability limits.
#' @inheritParams bdsreader::read_bds
#' @return A string of milestones
#' @author Arjan Huizing 2025
#' @examples
#' fn <- system.file("testdata", "Laura_S.json", package = "james")
#' select_vwc(txt = fn, p = 50, n = 10)
#' @export
select_vwc <- function(
  txt = "",
  p = 90,
  n = 6,
  session = "",
  format = "1.0",
  loc = "",
  ...
) {
  authenticate(...)
  daz <- d <- NULL

  if (!missing(loc)) {
    warning(
      "Argument loc is deprecated and will disappear in Nov 2022; please use session instead.",
      call. = FALSE
    )
    session <- loc2session(loc)
  }

  tgt <- get_tgt(
    txt = txt,
    session = session,
    format = format,
    append_ddi = TRUE
  )

  if (!is.list(tgt)) {
    message("Cannot calculate VWC items")
    return(NULL)
  }
  time <- timedata(tgt)

  if ("dsc" %in% time$yname) {
    # get last observed DAZ score
    daz <- unlist(time[
      which.max(ifelse(time$yname == "dsc", time$age, NA)),
      "z"
    ])
  }

  vwc <- vwc::select_vwc(
    age = max(time$age),
    p = p,
    d = d,
    daz = daz,
    n = n,
    passed_items = time[time$y == 1.00, ]$yname
  )

  return(jsonlite::toJSON(unique(vwc), auto_unbox = TRUE))
}
