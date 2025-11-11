# JAMES - A program to monitor and interpret child growth and development.
# Copyright (C) 2022 Stef van Buuren (stef.vanbuuren@tno.nl)
# Arjan Huizing (arjan.huizing@tno.nl)
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

#' Calculates the next item to administer in an adaptive test to measure the
#' D-score. Uses the previously administered items and item scores as input.
#'
#' @inheritParams calculate_dscore
#' @inheritParams dcat_start
#' @inheritParams bdsreader::read_bds
#' @return A string of milestones
#' @author Iris Eekhout 2025
#' @examples
#' txt <- system.file("examples", "example_v3.1.json", package = "bdsreader")
#' dcat_next(txt = txt, p = 50)
#' @export
dcat_next <- function(
  txt = "",
  instrument = "gs1",
  key = "gsed2510",
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
    append = instrument
  )

  if (!is.list(tgt)) {
    message("Cannot calculate next item")
    return(NULL)
  }
  time <- timedata(tgt)

  # extract the D-score from the data
  has_dsc <- "dsc" %in% unlist(time[time$age == max(time$age), "yname"])
  if (has_dsc) {
    d <- unlist(time[time$age == max(time$age) & time$yname == "dsc", "y"])
  }

  # extract administered time-variables from the data
  vars_adm <- time$yname

  items_instrument <- dscore::get_itemnames(instrument = instrument)
  items_assessed <- intersect(vars_adm, items_instrument) #variabele that are part of instrument
  items_candidate <- setdiff(items_instrument, items_assessed)

  nexti <- dcat::dcat_next(
    dscore = d,
    key = key,
    p = p,
    items = items_candidate
  )$item

  return(nexti)
}
