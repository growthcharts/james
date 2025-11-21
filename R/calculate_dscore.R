# JAMES - A program to monitor and interpret child growth and development.
# Copyright (C) 2025 Stef van Buuren (stef.vanbuuren@tno.nl)
# Arjan Huizing (arjan.huizing@tno.nl)
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

#' Calculates the D-score and DAZ for each visit
#'
#' The function `draw_chart()` plots individual data on the growth chart.
#' @inheritParams request_site
#' @param append Optional vector of strings indicating which instrument to base
#'   D-score calculations on. Currently supports `ddi` and `gs1`. Requires JSON
#'   schema V3.0 or later.
#' @param output A string, either `"table"`, `"last_visit"` or '`"last_dscore"`
#'   specifying the result. The default `"table"` returns with columns: `"date"`
#'   (date), `"x"` (age), `"y"` (D-score) and `"z"` (DAZ). The number of rows
#'   equals to the number of visits. If `output` equals `"last_visit"` the
#'   function returns only the last row. If `output` equals `"last_dscore"` the
#'   function returns only the D-score from the last row.
#' @inheritParams bdsreader::read_bds
#' @return A table, row or scalar.
#' @author Stef van Buuren 2020
#' @keywords server
#' @examples
#' fn <- system.file("testdata", "Laura_S.json", package = "james")
#' df <- calculate_dscore(txt = fn)
#' head(df, 4)
#' @export
calculate_dscore <- function(
  txt = "",
  session = "",
  format = "3.1",
  append = c("ddi","gs1"),
  output = c("table", "last_visit", "last_dscore"),
  loc = "",
  ...
) {
  authenticate(...)

  if (!missing(loc)) {
    warning(
      "Argument loc is deprecated and will disappear in Nov 2022; please use session instead.",
      call. = FALSE
    )
    session <- loc2session(loc)
  }

  output <- match.arg(output)
  tgt <- get_tgt(txt = txt, session = session, format = format, append = append)

  if (!is.list(tgt)) {
    message("Cannot calculate D-score")
    return(NULL)
  }

  #select the items
  items <- dscore::get_itemnames(instrument = append)

  # check key - set default for gsed
    key <- "gsed2510"
    if(all(is.na(get_tau(items, key = key)))){
      key <- "gsed2406"
    }
    # get the defaults for key
    idx <- which(dscore::builtin_keys$key == key)
    # get population
    population = dscore::builtin_keys$base_population[idx]

  time <- timedata(tgt)

  dsc <- time %>%
    dplyr::select(-zname, -z) |>
    tidyr::pivot_wider(id_cols = c(age, xname), names_from = yname, values_from = y)|>
    dscore::dscore(key = key, population = population)

  if (output == "last_visit") {
    return(dsc[nrow(dsc), ])
  }
  if (output == "last_dscore") {
    return(dsc[nrow(dsc), "d"])
  }
  dsc
}
