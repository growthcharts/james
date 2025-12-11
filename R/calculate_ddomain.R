# JAMES - A program to monitor and interpret child growth and development.
# Copyright (C) 2025 Stef van Buuren (stef.vanbuuren@tno.nl)
# Arjan Huizing (arjan.huizing@tno.nl)
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

#' Calculates the domain specific D-score and DAZ for each visit
#'
#' The function `draw_chart()` plots individual data on the growth chart.
#' @inheritParams request_site
#' @param append Optional vector of strings indicating which instrument to base
#'   D-score calculations on. Currently supports `ddi` and `gs1`. Requires JSON
#'   schema V3.0 or later.
#' @param set String with the name of the domainset
#' @param domain Vector of strings with names of specific domains, by default
#' all domains in the set are returned.
#' @inheritParams bdsreader::read_bds
#' @return A list of data.frames.
#' @author Iris Eekhout 2025
#' @keywords server
#' @examples
#' fn <- system.file("testdata", "Laura_S.json", package = "james")
#' df <- calculate_dscore(txt = fn)
#' head(df, 4)
#' @export
calculate_ddomain <- function(
  txt = "",
  session = "",
  format = "3.1",
  append = c("ddi", "gs1"),
  set = "GFCLS",
  domain = NULL,
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

  tgt <- get_tgt(txt = txt, session = session, format = format, append = append)

  if (!is.list(tgt)) {
    message("Cannot calculate D-score")
    return(NULL)
  }

  time <- timedata(tgt)

  #select the items present in data
  items <- dscore::get_itemnames(instrument = append)
  items <- items[items %in% time$yname]

  # check key - set default for gsed
  key <- "gsed2510"
  if (all(is.na(get_tau(items, key = key)))) {
    key <- "gsed2406"
  }
  # get the defaults for key
  idx <- which(dscore::builtin_keys$key == key)
  # get population
  population = dscore::builtin_keys$base_population[idx]

  # transform data
  time <- time %>%
    dplyr::select(-.data$zname, -.data$z) |>
    tidyr::pivot_wider(
      id_cols = c(.data$age, .data$xname),
      names_from = .data$yname,
      values_from = .data$y
    )

  # calculate both D-score and domain scores
  dsc <- time |>
    dscore::dscore(key = key, population = population)
  domains <- time |>
    dscore::ddomain(key = key, population = population,
                    set = set, domain = domain)
  dsc <- c(list("dscore" = dsc), domains)

  return(dsc)
}
