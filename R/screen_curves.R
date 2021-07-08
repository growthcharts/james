#' Screen growth curves according to JGZ guidelines
#'
#' @name screen_curves-deprecated
#' @inheritParams request_site
#' @inheritParams bdsreader::read_bds
#' @param location Legacy for `loc`
#' @param legacy Logical indicating whether legacy should be done.
#' @return A JSON string containing a table with screening results
#' @note Deprecated for consistency. Function returns JSON, whereas all other
#' functions return the R object. The alternative [screen_growth()]
#' requests only results from screening. The alternative [custom_list()]
#' produces the same list as `screen_curves`, but does not convert the
#' result to JSON.
#' @examples
#' # # example json
#' # fn <- system.file("testdata", "client3.json", package = "james")
#' # fn <- system.file("testdata", "Laura_S_dev.json", package = "james")
#' #
#' # # first upload, then screen
#' # r1 <- jamesclient::upload_txt(fn)
#' # location <- jamesclient::get_url(r1, "location")
#' # location
#' # screen_curves(loc = location)
#' #
#' # # upload & screen
#' # screen_curves(fn)
#' @export
screen_curves <- function(txt = "", loc = "", location = "", version = 2L,
                          legacy = TRUE) {
  .Deprecated("screen_growth",
    msg = "screen_curves() is deprecated. Please use screen_growth() or custom_list() instead."
  )
  # legacy
  if (!is.empty(location)) loc <- location
  if (legacy) {
    toJSON(custom_list(txt = txt, loc = loc))
  } else {
    toJSON(screen_curves_ind(get_tgt(txt, loc, version = version)))
  }
}
