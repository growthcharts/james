#' Screen growth curves according to JGZ guidelines
#'
#' @inheritParams draw_chart
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
#' screen_curves(ind_loc = location)
#'
#' # implicit upload (slower)
#' screen_curves(bds_data = js)
#'}
#' @export
screen_curves <- function(bds_data  = NULL,
                          ind_loc = NULL) {

  if (length(ind_loc) == 0L) {
    if (length(bds_data) > 0L) {
      r1 <- upload_bds(bds_data)
      ind_loc <- get_url(r1, "location")
    }
    else {
      return(toJSON(list(
        UrlGroeicurven = unbox("Data not found"),
        Resultaten = screen_curves_ind(NULL))))
    }
  }
  con <- curl(paste0(ind_loc, "R/.val/rda"))
  load(file = con)
  ind <- .val
  close(con)
  rm(".val")

  res <- screen_curves_ind(ind)
  url <- paste0("https://groeidiagrammen.nl/ocpu/lib/james/www/?ind=", ind_loc)
  ret <- list(UrlGroeicurven = unbox(url),
              Resultaten = res)
  toJSON(ret)
}
