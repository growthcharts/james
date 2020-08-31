#' Provides a Screen growth curves according to JGZ guidelines
#'
#' @inheritParams request_site
#' @return A table with screening results
#' @return A list with custom parts
#' @examples
#' \dontrun{
#' fn <- system.file("extdata", "smocc", "Laura_S.json", package = "jamestest")
#' host <- "http://localhost"
#'
#' # first upload, then create custom list
#' r1 <- upload_txt(fn, host = host)
#' loc <- jamesclient::get_url(r1, "location")
#' list1 <- custom_list(loc = loc)
#'
#' # upload & screen
#' list2 <- custom_list(fn)
#' identical(list1, list2)
#' }
#' @export
custom_list <- function(txt = "", loc = "") {

  site <- request_site(txt, loc)

  ind <- get_ind(txt, loc)

  res <- screen_curves_ind(ind)

  last_dscore <- NULL
  if (!is.null(ind)) {
    d <- ind@dsc@y[length(ind@dsc@y)]
    if (!is.na(d)) last_dscore <- d
  }

  # list of two elements if nu D-score, else 3 elements
  if (is.null(last_dscore)) {
    ret <- list(UrlGroeicurven = unbox(site),
                Resultaten = res)
  } else {
    ret <- list(UrlGroeicurven = unbox(site),
                Resultaten = res,
                LaatsteDscore = unbox(last_dscore))
  }
  toJSON(ret)
}
