#' Validates a growth chart code
#'
#' This function checks whether \code{chartcode} is a available
#' in the chart library.
#' @param chartcode Character vector of chart codes,
#' typically something like \code{"NMAB"}
#' @return Named logical vector with same length as \code{chartcode}.
#' A \code{TRUE} means a pass, a \code{FALSE} means a fail.
#' @seealso \code{\link{list_charts}}
#' @examples
#' validate_chartcode(c("NJAA", "NZXX", "PMAAN26"))
#' @export
validate_chartcode <- function(chartcode = NULL) {

  if (is.null(chartcode)) return(logical())
  result <- chartcode %in% list_charts()$chartcode
  names(result) <- chartcode
  result
}
