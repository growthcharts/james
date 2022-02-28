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
#' library(jamesclient)
#' r1 <- james_post(path = "data/upload/json", txt = fn)
#' r2 <- james_post(path = "screeners/apply/json", loc = r1$location)
#' r3 <- james_post(path = "screeners/apply/json", session = r1$session)
#' }
#' @export
apply_screeners <- function(txt = "",
                            host = "",
                            session = "",
                            format = "1.0",
                            ynames = c("hgt", "wgt", "hdc"),
                            na.omit = TRUE,
                            loc = "",
                            ...) {
  authenticate(...)

  if (!missing(loc)) {
    warning("Argument loc is deprecated and will disappear in Sept 2022; please use session instead.",
            call. = FALSE
    )
    session <- loc2session(loc)
  }

  tgt <- get_tgt(txt = txt,
                 host = host,
                 session = session,
                 format = format)
  growthscreener::screen_curves_ind(ind = tgt,
                                    ynames = ynames,
                                    na.omit = na.omit,
                                    ...)
}
