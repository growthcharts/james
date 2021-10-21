#' List the available growth charts
#'
#' @param \dots Used for authentication
#'
#' @export
list_charts <- function(...) {
  authenticate(...)
  chartbox::list_charts()
}
