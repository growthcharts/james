#' Validates a growth chart code
#'
#' This function checks whether `chartcode` is a available
#' in the chart library.
#' @param chartcode Chart code, typically something like `"NMAB"`
#' @return A logical vector of with `length(chartcode)` elements.
#' @seealso [list_charts()]
#' @export
validate_chartcode <- function(chartcode = "") {
  authenticate(...)
  if (is.empty(chartcode)) {
    return(FALSE)
  }
  chartcode %in% list_charts()$chartcode
}
