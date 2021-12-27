#' Convert json BSD data for single individual to class individual
#'
#' @note Deprecated. Use [upload_data()] instead.
#' @name convert_bds_ind-deprecated
#' @inheritParams bdsreader::read_bds
#' @return An object of class `target`. Basically a list with elements `psn`
#' (persondata) and `xyz` (timedata).
#' @author Stef van Buuren 2021
#' @examples
#' fn <- system.file("testdata", "client3.json", package = "james")
#' p <- convert_bds_ind(fn)
#' @keywords server
#' @export
convert_bds_ind <- function(txt = "", format = "1.0", ...) {
  authenticate(...)
  .Deprecated("upload_data",
    msg = "convert_bds_ind() is deprecated and will disappear in Sept 2022. Please use upload_data() instead."
  )
  upload_data(txt = txt, format = format, ...)
}
