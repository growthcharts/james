#' Screen growth curves according to JGZ guidelines
#'
#' @inheritParams request_site
#' @return A table with screening results
#' @examples
#' \dontrun{
#' # example json
#' fn <- system.file("testdata", "client3.json", package = "james")
#' fn <- system.file("extdata", "smocc", "Laura_S.json", package = "jamestest")
#'
#' # first upload, then screen
#' r1 <- upload_txt(fn)
#' location <- jamesclient::get_url(r1, "location")
#' location
#' screen_curves(loc = location)
#'
#' # upload & screen
#' screen_curves(fn)
#'}
#' @export
screen_curves <- function(txt = NULL, loc = NULL) {

  # no input
  if (is.null(txt) && is.null(loc))
    return(screen_curves_ind(NULL))

  # upload txt data and return loc
  if (!is.null(txt))
    return(screen_curves_ind(convert_bds_individual(txt)))
  else
    return(screen_curves_ind(read_ind(loc)))
}

read_ind <- function(loc) {
  con <- curl(paste0(loc, "R/.val/rda"))
  load(file = con)
  close(con)
  .val
}

