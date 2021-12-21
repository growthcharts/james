#' Uploads, parses, converts and stores data on the server
#'
#' Uploads JSON data that adhere to the BDS-format, parses its
#' contents, converts it to an internal JAMES target object,
#' and stores the result on the server for further processing.
#' The function is useful for caching input data over multiple requests to
#' `OpenCPU`. The cached data feed into other JAMES functions by means
#' of the `"loc"` argument. The server wipes the cached data after 2 hours.
#' @inheritParams bdsreader::read_bds
#' @param \dots Used for additional parameters
#' @return A tibble with an attribute called `"person"`
#' @author Stef van Buuren 2021
#' @seealso [bdsreader::read_bds()]
#'          [jsonlite::fromJSON()]
#' @examples
#' fn <- system.file("testdata", "client3.json", package = "james")
#' p <- upload_data(fn)
#' @keywords server
#' @export
upload_data <- function(txt = "",
                        auto_format = TRUE,
                        format = "1.0",
                        schema = NULL,
                        append_ddi = FALSE,
                        verbose = FALSE,
                        ...) {
  authenticate(...)
  read_bds(txt = txt,
           auto_format = auto_format,
           format = format,
           schema = schema,
           append_ddi = append_ddi,
           verbose = verbose,
           ...)
}