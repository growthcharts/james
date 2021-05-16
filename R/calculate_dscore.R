#' Calculates the D-score and DAZ for each visit
#'
#' The function `draw_chart()` plots individual data on the growth chart.
#' @inheritParams request_site
#' @param output A string, either `"table"`, `"last_visit"` or
#' '`"last_dscore"` specifying the result. The default `"table"`
#' returns a table with four columns: `"date"`, `"x"` (age),
#' `"y"` (D-score) and `"z"` (DAZ). The number of rows equals to
#' the number of visits. If `output` equals `"last_visit"` the
#' function returns only the last row. If `output` equals
#' `"last_dscore"` the function returns only the D-score from the last row.
#' @return A table, row or scalar.
#' @author Stef van Buuren 2020
#' @keywords server
#' @examples
#' fn <- system.file("testdata", "Laura_S_dev.json", package = "james")
#' d <- calculate_dscore(txt = fn)
#' @export
calculate_dscore <- function(txt = "",
                             loc = "",
                             schema = "bds_schema_str.json",
                             output = c("table", "last_visit", "last_dscore")) {
  output <- match.arg(output)
  tgt <- get_tgt(txt, loc, schema = schema)

  if (!hasName(attributes(tgt), "person")) {
    message("Cannot calculate D-score")
    return(NULL)
  }

  df <- tgt %>%
    filter(.data$yname == "dsc") %>%
    mutate(date = format(attr(!!tgt, "person")$dob + round(.data$age * 365.25), "%Y%m%d"))

  if (output == "last_visit") {
    return(df[nrow(df), ])
  }
  if (output == "last_dscore") {
    return(pull(df[nrow(df), "y"]))
  }
  df
}