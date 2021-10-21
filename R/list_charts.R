#' List the available growth charts
#'
#' @param authToken A JSON web token.
#' @param \dots Used for authentication
#'
#' @export
list_charts <- function(authToken = NULL, ...) {
  authenticate(authToken = authToken, ...)
  chartbox::list_charts()
}
