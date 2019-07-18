#' Convert json BSD data for single individual to class individual
#'
#' This function takes data from a json source and saves as a an object
#' of class \linkS4class{individual}. The function automatically calculates
#' standard deviation scores and broken stick conditional means per visit.
#'
#' This is function is a wrapper around \code{minhealth::convert_bds_individual()}.
#' @inheritParams minihealth::convert_bds_individual
#' @return An object of class \linkS4class{individual}.
#' @author Stef van Buuren 2019
#' @seealso \linkS4class{individual}, \linkS4class{bse}, \linkS4class{xyz},
#'          \code{\link[minihealth]{convert_bds_individual}}
#'          \code{\link[jsonlite]{fromJSON}}
#' @examples
#' fn <- file.path(path.package("james"), "testdata", "client3.json")
#' p <- convert_bds_ind(fn)
#' @keywords server
#' @export
convert_bds_ind <- function(txt = NULL, ...) {
  minihealth::convert_bds_individual(txt = txt, ...)
}
