#' Calculates the D-score and DAZ for each visit
#'
#' The function \code{draw_chart()} plots individual data on the growth chart.
#' @inheritParams request_site
#' @param output A string, either \code{"table"}, \code{"last_visit"} or
#' '\code{"last_dscore"} specifying the result. The default \code{"table"}
#' returns a table with four columns: \code{"date"}, \code{"x"} (age),
#' \code{"y"} (D-score) and \code{"z"} (DAZ). The number of rows equals to
#' the number of visits. If \code{output} equals \code{"last_visit"} the
#' function returns only the last row. If \code{output} equals
#' \code{"last_dscore"} the function returns only the D-score from the last row.
#' @return A table, row or scalar.
#' @author Stef van Buuren 2020
#' @keywords server
#' @examples
#' fn <- system.file("testdata", "Laura_S_dev.json", package = "james")
#' d <- calculate_dscore(txt = fn)
#' @export
calculate_dscore <- function(txt = "",
                             loc = "",
                             output = c("table", "last_visit", "last_dscore")) {
  output <- match.arg(output)
  ind <- get_ind(txt, loc)

  if (!is.individual(ind)) {
    message("Cannot calculate D-score")
    return(NULL)
  }

  yname <- "dsc"
  df <- data.frame(
    date = format(slot(ind, "dob") + round(slot(ind, yname)@x * 365.25), format = "%Y%m%d"),
    x = slot(ind, yname)@x,
    y = slot(ind, yname)@y,
    z = slot(ind, yname)@z,
    check.names = FALSE,
    fix.empty.names = FALSE
  )

  if (output == "last_visit") {
    return(df[nrow(df), ])
  }
  if (output == "last_dscore") {
    return(df[nrow(df), "y"])
  }
  df
}
