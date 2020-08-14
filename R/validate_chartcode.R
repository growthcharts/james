#' Validates a growth chart code
#'
#' This function checks whether \code{chartcode} is a available
#' in the chart library.
#' @param chartcode Chart code, typically something like \code{"NMAB"}
#' @return \code{TRUE} or \code{FALSE}.
#' @seealso \code{\link{list_charts}}
validate_chartcode <- function(chartcode = NULL) {

  if (!length(chartcode)) return(FALSE)
  chartcode[1L] %in% list_charts()$chartcode
}

