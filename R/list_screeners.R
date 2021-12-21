#' List the available growth screeners
#'
#' @param ynames Character vector identifying the measures to be
#' screened. By default, `ynames = c("hgt", "wgt", "hdc")`.
#' @param \dots Used for authentication, passed down to [growthscreener::list_screeners()].
#' @examples
#' head(list_screeners(ynames = "hgt"), 2)
#' @export
list_screeners <- function(ynames = c("hgt", "wgt", "hdc"),
                           ...) {
  authenticate(...)
  growthscreener::list_screeners(ynames = ynames, ...)
}
