#' Validates a growth chart code
#'
#' This function checks whether \code{chartcode} is a available
#' in the chart library.
#' @param chartcode Chart code, typically something like \code{"NMAB"}
#' @return The \code{chartcode} if available. \code{NULL} if not
#' available.
#' @seealso \code{\link{list_charts}}
#' @examples
#' validate_chartcode("NJAA")
#' @export
validate_chartcode <- function(chartcode = NULL) {

  if (is.null(chartcode)) return(NULL)
  if (!chartcode[1L] %in% list_charts()$chartcode) return(NULL)
  chartcode
}
