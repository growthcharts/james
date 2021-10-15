#' Uploads, parses, converts and stores data on the server for further processing
#'
#' Uploads JSON data that adhere to the BDS-format, parses its
#' contents, converts it to an internal JAMES target object,
#' and stores the result on the server for further processing.
#' The function is useful for caching input data over multiple requests to
#' `OpenCPU`. The cached data feed into other JAMES functions by means
#' of the `"loc"` argument. The server wipes the cached data after 24 hours.
#' @inheritParams bdsreader::read_bds
#' @return A tibble with a person attribute
#' @author Stef van Buuren 2021
#' @seealso [bdsreader::read_bds()]
#'          [jsonlite::fromJSON()]
#' @examples
#' fn <- system.file("testdata", "client3.json", package = "james")
#' p <- fetch_loc(fn)
#' @keywords server
#' @export
fetch_loc <- function(txt = "",
                      format = "1.0",
                      ...) {
  authenticate(...)
  read_bds(txt = txt, format = format)
}
