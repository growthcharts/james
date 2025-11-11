# JAMES - A program to monitor and interpret child growth and development.
# Copyright (C) 2025 Stef van Buuren (stef.vanbuuren@tno.nl)
# Arjan Huizing (arjan.huizing@tno.nl)
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

#' Calculates the start item from age for an adaptive test to measure D-score.
#'
#' @inheritParams calculate_dscore
#' @param instrument A character vector with 3-position codes of instruments
#' that should match. The default is `instrument = "gs1"` for GSED SF;
#' `instrument = NULL` allows for all instruments.
#' @param key String. They key identifies 1) the difficulty estimates
#' pertaining to a particular Rasch model, and 2) the prior mean and standard
#' deviation of the prior distribution for calculating the D-score.
#' The default key `key = "gsed2510"`.
#' @param population String. Name of the reference population.
#' @param p percentage to pass the item, difficulty in percentile units.
#' @inheritParams bdsreader::read_bds
#' @return A string of milestones.
#' @author Iris Eekhout 2025
#' @examples
#' fn <- system.file("examples", "example_v3.1.json", package = "bdsreader")
#' dcat_start(txt = fn, p = 50)
#' @export
dcat_start <- function(
  txt = "",
  instrument = "gs1",
  key = "gsed2510",
  population = "",
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

  if (population == "") {
    population <- NULL
  }

  psn <- persondata(tgt)
  # extract the age from the data
  age <- as.numeric(Sys.Date() - psn$dob) / 365.25

  # get items from instrument
  items_instrument <- dscore::get_itemnames(instrument = instrument)

  starti <- dcat::dcat_start(
    age = age,
    key = key,
    population = population,
    p = p,
    items = items_instrument
  )

  return(starti)
}
