# JAMES - A program to monitor and interpret child growth and development.
# Copyright (C) 2025 Stef van Buuren (stef.vanbuuren@tno.nl)
# Arjan Huizing (arjan.huizing@tno.nl)
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

#' Calculates the D-score and DAZ for each visit
#'
#' The function `draw_chart()` plots individual data on the growth chart.
#' @inheritParams request_site
#' @param output A string, either `"table"`, `"last_visit"` or
#' '`"last_dscore"` specifying the result. The default `"table"`
#' returns with columns: `"date"` (date), `"x"` (age), `"y"` (D-score)
#' and `"z"` (DAZ). The number of rows equals to
#' the number of visits. If `output` equals `"last_visit"` the
#' function returns only the last row. If `output` equals
#' `"last_dscore"` the function returns only the D-score from the last row.
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
  format = "1.0",
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
  tgt <- get_tgt(txt = txt, session = session, format = format)

  if (!is.list(tgt)) {
    message("Cannot calculate D-score")
    return(NULL)
  }

  time <- timedata(tgt)
  child <- persondata(tgt)
  df <- time %>%
    filter(.data$yname == "dsc") %>%
    mutate(date = format(child[["dob"]] + round(.data$age * 365.25), "%Y%m%d"))

  if (output == "last_visit") {
    return(df[nrow(df), ])
  }
  if (output == "last_dscore") {
    return(pull(df[nrow(df), "y"]))
  }
  df
}
