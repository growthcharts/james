#' Screen growth curves according to JGZ guidelines
#'
#' @inheritParams jsonlite::fromJSON
#' @param location  A url that points to the server location where the
#'   parsed data are stored. Optional. If specified, \code{location}
#'   takes priority over \code{txt}. \code{location} is typically
#'   the location of a previous \code{OpenCPU} call for uploading
#'   the data.
#' @return A JSON string
#' @examples
#' \dontrun{
#' # example json
#' fn <- file.path(path.package("james"), "testdata", "client3.json")
#' js <- readLines(fn, warn = FALSE)
#'
#' # first upload, then screen
#' r1 <- jamesclient::upload_bds(js)
#' location <- jamesclient::get_url(r1, "location")
#' location
#' screen_curves(location = location)
#'
#' # implicit upload (slower)
#' screen_curves(txt = js)
#'}
#' @export
screen_curves <- function(txt = NULL, location = NULL) {

  if (length(location) == 0L) {
    if (length(txt) > 0L) {
      r1 <- upload_bds(txt)
      location <- get_url(r1, "location")
    }
    else {
      return(toJSON(list(
        UrlGroeicurven = unbox("Data not found"),
        Resultaten = screen_curves_ind(NULL))))
    }
  }
  con <- curl(paste0(location, "R/.val/rda"))
  load(file = con)
  ind <- .val
  close(con)
  rm(".val")

  res <- screen_curves_ind(ind)
  url <- paste0("https://groeidiagrammen.nl/ocpu/lib/james/www/?ind=", location)
  ret <- list(UrlGroeicurven = unbox(url),
              Resultaten = res)
  toJSON(ret)
}
