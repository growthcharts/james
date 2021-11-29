#' Reports JAMES version
#'
#' This function return the version of the james package and R.
#' @param package Package name
#' @return A list with four elements:
#' \describe{
#'   \item{package}{Package name}
#'   \item{packageVersion}{Package version}
#'   \item{packageDate}{Package date}
#'   \item{Rversion}{R version}
#'   }
#' @export
version <- function(package = "james") {
  pkg <- package[1L]
  list(
    package = pkg,
    packageVersion = as.character(packageVersion(pkg)),
    packageDate = as.character(packageDate(pkg)),
    Rversion = as.character(getRversion())
  )
}
