#' List the available growth screeners
#'
#' @param \dots Used for authentication, passed down to [growthscreener::list_screeners()].
#' @examples
#' head(list_screeners(ynames = "hgt"), 2)
#' @export
list_screeners <- function(...) {
  authenticate(...)
  growthscreener::list_screeners(...)
}
