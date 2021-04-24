#' Screen growth curves according to JGZ guidelines
#'
#' @inheritParams request_site
#' @note `screen_growth` superseeds `screen_curves` and will
#' only return results from growth screening.
#' @examples
#' # example json
#' fn <- system.file("testdata", "client3.json", package = "james")
#'
#' # first upload, then screen
#' r1 <- jamesclient::upload_txt(fn)
#' location <- jamesclient::get_url(r1, "location")
#' location
#' screen_growth(loc = location)
#'
#' # upload & screen
#' screen_growth(fn)
#' @export
screen_growth <- function(txt = "", loc = "", schema = "bds_schema_str.json") {
  screen_curves_ind(get_tgt(txt, loc, schema = schema))
}
