#' Convert json BSD data for single individual to class individual
#'
#' This function takes data from a json source and saves as a tibble with
#' a person attribute.
#' @note Deprecated. Use [fetch_loc()] instead.
#' @name convert_bds_ind-deprecated
#' @inheritParams bdsreader::read_bds
#' @return A tibble with a person attribute.
#' @author Stef van Buuren 2021
#' @examples
#' fn <- system.file("testdata", "client3.json", package = "james")
#' p <- convert_bds_ind(fn, version = 1)
#' @keywords server
#' @export
convert_bds_ind <- function(txt = "", version = 2L, ...) {
  .Deprecated("fetch_loc",
    msg = "convert_bds_ind() is deprecated. Please use fetch_loc() instead."
  )
  fetch_loc(txt = txt, version = version, ...)
}
