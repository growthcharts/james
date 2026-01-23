# JAMES - A program to monitor and interpret child growth and development.
# Copyright (C) 2022 Stef van Buuren (stef.vanbuuren@tno.nl)
# Arjan Huizing (arjan.huizing@tno.nl)
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

#' Applies the adaptive test algorithm to determine the next step: administer
#' the next item or stop test and return D-score.
#'
#' @inheritParams dcat::dcat
#' @inheritParams bdsreader::read_bds
#' @inheritParams request_site
#' @param sem_rule numeric target for sem can be estimated based on Cohen's d
#' from `sem_rule()`.
#'
#' @return A string with an item name or a table.
#' @author Iris Eekhout 2025
#' @examples
#' txt <- system.file("examples", "example_v3.1.json", package = "bdsreader")
#' dcat(txt = txt, p = 50)
#' txt <- "~/OneDrive - TNO/Documents/GitHub/james/data-raw/test_data.json"
#' dcat(txt = txt, p = 50)
#' @export
dcat <- function(
  txt = "",
  instrument = "gs1",
  key = NULL,
  population = NULL,
  p = 50,
  sem_rule = 1.726,
  session = "",
  format = "3.1",
  ...
) {
  authenticate(...)
  dat <- NULL

  # default is most recent gsed key; if no tau for new key, fall back to previous key
  if (is.null(key) || key == "gsed") {
    key <- "gsed2510"
    if (
      all(is.na(dscore::get_tau(dscore::get_itemnames(instrument), key = key)))
    ) {
      key <- "gsed2406"
    }
  }

  tgt <- get_tgt(
    txt = txt,
    session = session,
    format = format,
    append = instrument
  )

  psn <- persondata(tgt)
  # extract the current age from the data
  age <- as.numeric(Sys.Date() - psn$dob) / 365.25

  if (is.na(age)) {
    message("No date of birth found, cannot calculate next item")
    return(NULL)
  }

  time <- timedata(tgt)
  # extract most recent administered items
  if (nrow(time) > 0) {
    dat <- time
    colnames(dat)[colnames(dat) %in% c("yname", "y")] <- c("item", "score")
    dat <- dat |> select(all_of(c("item", "score")))
  }

  dcat_result <- dcat::dcat(
    data = dat,
    age = age,
    key = key,
    population = population,
    p = p,
    instrument = instrument,
    sem_rule = sem_rule
  )

  return(dcat_result)
}
