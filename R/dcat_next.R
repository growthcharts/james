# JAMES - A program to monitor and interpret child growth and development.
# Copyright (C) 2022 Stef van Buuren (stef.vanbuuren@tno.nl)
# Arjan Huizing (arjan.huizing@tno.nl)
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

#' Calculates the next item to administer in an adaptive test to measure the
#' D-score. Uses the previously administered items and item scores as input.
#'
#' @inheritParams calculate_dscore
#' @param instrument A character vector with 3-position codes of instruments
#' that should match. The default is `instrument = gs1` for GSED SF;
#' `instrument = NULL` allows for all instruments.
#' @param key String. They key identifies 1) the difficulty estimates
#' pertaining to a particular Rasch model, and 2) the prior mean and standard
#' deviation of the prior distribution for calculating the D-score.
#' The default key `key = "gsed2510"`.
#' @param p percentage to pass the item, difficulty in percentile units.
#' @inheritParams bdsreader::read_bds
#' @return A string of milestones
#' @author Iris Eekhout 2025
#' @examples
#' txt <- system.file("examples", "example_v3.1.json", package = "bdsreader")
#' dcat_next(txt = txt, p = 50)
#' @export
dcat_next <- function(txt = "",
                       instrument = "gs1",
                       key = "gsed2510",
                       p = 50,
                       session = "",
                       format = "3.1",
                       loc = "",
                       ...) {
  authenticate(...)
  daz <- d <- NULL

  if (!missing(loc)) {
    warning("Argument loc is deprecated and will disappear in Nov 2022; please use session instead.",
            call. = FALSE
    )
    session <- loc2session(loc)
  }

  tgt <- get_tgt(txt = txt,
                 session = session,
                 format = format,
                 append = instrument)

  if (!is.list(tgt)) {
    message("Cannot calculate next item")
    return(NULL)
  }
  time <- timedata(tgt)

  # extract the D-score from the data

  if ("dsc" %in% time[time$age == max(time$age), "yname"]) {
    d <- unlist(time[time$age == max(time$age) & time$yname == "dsc", "y"])
  }

  # extract administered time-variables from the data
  vars_adm <- time$yname

  items_instrument <- dscore::get_itemnames(instrument = instrument)
  items_assessed <- intersect(vars_adm, items_instrument) #variabele that are part of instrument
  items_candidate <- setdiff(items_instrument, items_assessed)

  nexti <- dcat::dcat_next(
                         p = p,
                         d = d,
                         items = items_candidate
                        )$item

  return(nexti)
}
