#' Screen growth curves according to JGZ guidelines
#'
#' @inheritParams request_site
#' @inheritParams bdsreader::read_bds
#' @note `screen_growth` superseeds `screen_curves` and will
#' only return results from growth screening.
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
screen_growth <- function(txt = "", loc = "", format = "1.0", ...) {
  authenticate(...)
  screen_curves_ind(ind = get_tgt(txt, loc, format = format), ...)
}
