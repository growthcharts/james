#' List the available growth screeners
#'
#' @param \dots Used for authentication
#' @examples
#' @export
list_screeners <- function(...) {
  authenticate(...)
  growthscreener::list_screeners(...)
}
