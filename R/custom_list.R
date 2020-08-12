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
custom_list <- function(txt = NULL, loc = NULL) {

  site <- request_site(txt, loc)

  if (!is.null(txt)) ind <- convert_bds_individual(txt)
  else ind <- get_ind(loc)

  res <- screen_curves_ind(ind)

  last_dscore <- ind@dsc@y[length(ind@dsc@y)]

  ret <- list(UrlGroeicurven = unbox(site),
              Resultaten = res,
              LaatsteDscore = last_dscore)
  toJSON(ret)
}
