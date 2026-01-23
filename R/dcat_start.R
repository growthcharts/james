# JAMES - A program to monitor and interpret child growth and development.
# Copyright (C) 2025 Stef van Buuren (stef.vanbuuren@tno.nl)
# Arjan Huizing (arjan.huizing@tno.nl)
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

#' Calculates the start item from age for an adaptive test to measure D-score.
#'
#' @inheritParams dcat::dcat
#' @inheritParams bdsreader::read_bds
#' @inheritParams calculate_dscore
#'
#' @return A string of milestones.
#' @author Iris Eekhout 2025
#' @examples
#' fn <- system.file("examples", "example_v3.1.json", package = "bdsreader")
#' dcat_start(txt = fn, p = 50)
#' @export
dcat_start <- function(
  txt = "",
  instrument = "gs1",
  key = NULL,
  population = NULL,
  p = 50,
  session = "",
  format = "3.1",
  ...
) {
  authenticate(...)
  daz <- d <- NULL

  tgt <- get_tgt(
    txt = txt,
    session = session,
    format = format,
    append_ddi = TRUE
  )

  if (!is.list(tgt)) {
    message("Cannot calculate start item")
    return(NULL)
  }

  psn <- persondata(tgt)
  # extract the age from the data
  age <- as.numeric(Sys.Date() - psn$dob) / 365.25

  # get items from instrument
  items_instrument <- dscore::get_itemnames(instrument = instrument)

  # default is most recent gsed key; if no tau for new key, fall back to previous key
  if (is.null(key) || key == "gsed") {
    key <- "gsed2510"
    if (all(is.na(dscore::get_tau(items_instrument, key = key)))) {
      key <- "gsed2406"
    }
  }

  starti <- dcat::dcat_start(
    age = age,
    key = key,
    population = population,
    p = p,
    items = items_instrument
  )

  return(starti)
}
