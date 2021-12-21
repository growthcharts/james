#' Screen growth curves according to JGZ guidelines
#'
#' @name screen_growth-deprecated
#' @inheritParams bdsreader::read_bds
#' @inheritParams request_site
#' @param ynames Character vector identifying the measures to be
#' screened. By default, `ynames = c("hgt", "wgt", "hdc")`.
#' @param na.omit A logical indicating whether records with a missing
#' `x` (age) or `y` (yname) should be removed. Defaults to
#' `TRUE`.
#' @examples
#' host <- "http://localhost"
#' fn <- system.file("testdata", "client3.json", package = "james")
#'
#' \dontrun{
#' # first upload, then screen
#' r1 <- jamesclient::upload_txt(fn, host = host)
#' location <- jamesclient::get_url(r1, "location")
#' location
#' screen_growth(loc = location)
#'
#' # upload & screen
#' screen_growth(fn)
#' }
#' @export
screen_growth <- function(txt = "",
                          loc = "",
                          format = "1.0",
                          ynames = c("hgt", "wgt", "hdc"),
                          na.omit = TRUE,
                          ...) {
  authenticate(...)
  .Deprecated("apply_screeners",
              msg = "screen_growth() is deprecated. Please use apply_screeners() instead.")
  screen_curves_ind(ind = get_tgt(txt, loc, format = format),
                    ynames = ynames,
                    na.omit = na.omit,
                    ...)
}
