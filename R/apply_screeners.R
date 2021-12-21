#' Apply growth screeners to child data
#'
#' @inheritParams bdsreader::read_bds
#' @inheritParams request_site
#' @param ynames Character vector identifying the measures to be
#' screened. By default, `ynames = c("hgt", "wgt", "hdc")`.
#' @param na.omit A logical indicating whether records with a missing
#' `x` (age) or `y` (yname) should be removed. Defaults to
#' `TRUE`.
#' @note `apply_screeners()` supersedes `screen_growth()` and `screen_curves()`.
#' @examples
#' fn <- system.file("testdata", "client3.json", package = "james")
#' apply_screeners(fn)
#' \dontrun{
#' # first upload, then screen
#' host <- "http://localhost"
#' r1 <- jamesclient::upload_txt(fn, host = host)
#' location <- jamesclient::get_url(r1, "location")
#' location
#' apply_screeners(loc = location)
#' }
#' @export
apply_screeners <- function(txt = "",
                            loc = "",
                            format = "1.0",
                            ynames = c("hgt", "wgt", "hdc"),
                            na.omit = TRUE,
                            ...) {
  authenticate(...)
  growthscreener::screen_curves_ind(ind = get_tgt(txt, loc, format = format),
                                    ynames = ynames,
                                    na.omit = na.omit,
                                    ...)
}
