#' Uploads, parses, converts and stores data on the server for further processing
#'
#' Uploads JSON data that adhere to the BDS-format, parses its
#' contents, converts it to an internal JAMES target object,
#' and stores the result on the server for further processing.
#' The function is useful for caching input data over multiple requests to
#' \code{OpenCPU}. The cached data feed into other JAMES functions by means
#' of the \code{"loc"} argument. The server wipes the cached data after 24 hours.
#'
#' @param txt A JSON string, URL or file
#' @param schema The name of one the the built-in schema's.
#' The default (\code{NULL}) loads \code{"bds_schema_str.json"}. See
#' \url{https://github.com/stefvanbuuren/bdsreader/tree/master/inst/json}
#' for available schema's.
#' @return A tibble with a person attribute
#' @author Stef van Buuren 2021
#' @seealso \code{\link[bdsreader]{read_bds}}
#'          \code{\link[jsonlite]{fromJSON}}
#' @examples
#' fn <- system.file("testdata", "client3.json", package = "james")
#' p <- fetch_loc(fn)
#' @keywords server
#' @export
fetch_loc <- function(txt = "",
                      schema = "bds_schema_str.json") {
  read_bds(txt = txt, schema = schema)
}
