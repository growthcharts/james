#' Uploads, parses, converts and stores data on the server for further processing
#'
#' Uploads JSON data that adhere to the BDS-format, parses its
#' contents, converts it to an internal JAMES object of class `target`,
#' and stores the result on the server for further processing.
#' The function is useful for caching input data over multiple requests to
#' `OpenCPU`. The cached data feed into other JAMES functions by means
#' of the `"loc"` argument. The server wipes the cached data after 2 hours.
#' @name fetch_loc-deprecated
#' @inheritParams bdsreader::read_bds
#' @return An object of class `target`. Basically a list with elements `psn`
#' (persondata) and `xyz` (timedata).
#' @author Stef van Buuren 2021
#' @seealso [bdsreader::read_bds()]
#'          [jsonlite::fromJSON()]
#' @examples
#' fn <- system.file("testdata", "client3.json", package = "james")
#' p <- fetch_loc(fn)
#' @keywords server
#' @export
fetch_loc <- function(txt = "",
                      ...) {
  authenticate(...)
  .Deprecated("upload_data",
              msg = "fetch_loc() is deprecated and will disappear in Sept 2022. Please use upload_data() instead.")
  upload_data(txt = txt, ...)
}
