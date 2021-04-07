#' Validates a growth chart code
#'
#' This function checks whether `chartcode` is a available
#' in the chart library.
#' @param chartcode Chart code, typically something like `"NMAB"`
#' @return `TRUE` or `FALSE`.
#' @seealso [list_charts()]
validate_chartcode <- function(chartcode = "") {
  if (is.empty(chartcode)) {
    return(FALSE)
  }
  chartcode[1L] %in% list_charts()$chartcode
}
