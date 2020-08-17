#' Screen growth curves according to JGZ guidelines
#'
#' @inheritParams request_site
#' @param location Legacy for \code{loc}
#' @return A table with screening results
#' @examples
#' \dontrun{
#' # example json
#' fn <- system.file("testdata", "client3.json", package = "james")
#' fn <- system.file("extdata", "smocc", "Laura_S.json", package = "jamestest")
#'
#' # first upload, then screen
#' r1 <- upload_txt(fn)
#' location <- jamesclient::get_url(r1, "location")
#' location
#' screen_curves(loc = location)
#'
#' # upload & screen
#' screen_curves(fn)
#'}
#' @export
screen_curves <- function(txt = "", loc = "", location = "") {
  # legacy
  if (!is.empty(location)) return(custom_list(txt = txt, loc = location))

  screen_curves_ind(get_ind(txt, loc))
}
