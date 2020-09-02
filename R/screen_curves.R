#' Screen growth curves according to JGZ guidelines
#'
#' @inheritParams request_site
#' @param location Legacy for \code{loc}
#' @param legacy Logical indicating whether legacy should be done.
#' @return A JSON string containing a table with screening results
#' @note \code{screen_curves} is the only function in \code{james} that
#' returns its result as JSON.
#' @examples
#' \dontrun{
#' # example json
#' fn <- system.file("testdata", "client3.json", package = "james")
#' fn <- system.file("testdata", "Laura_S_dev.json", package = "james")
#'
#' # first upload, then screen
#' r1 <- upload_txt(fn)
#' location <- jamesclient::get_url(r1, "location")
#' location
#' screen_curves(loc = location)
#'
#' # upload & screen
#' screen_curves(fn)
#' }
#' @export
screen_curves <- function(txt = "", loc = "", location = "", legacy = TRUE) {
  # legacy
  if (!is.empty(location)) loc <- location
  if (legacy) {
    toJSON(custom_list(txt = txt, loc = loc))
  } else {
    toJSON(screen_curves_ind(get_ind(txt, loc)))
  }
}
