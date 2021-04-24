#' Provides a Screen growth curves according to JGZ guidelines
#'
#' @inheritParams request_site
#' @return A table with screening results
#' @return A list with custom parts
#' @examples
#' fn <- system.file("extdata", "bds_str", "smocc", "Laura_S.json", package = "jamesdemodata")
#' host <- "http://localhost"
#'
#' # first upload, then create custom list
#' r1 <- jamesclient::upload_txt(fn, host = host)
#' loc <- jamesclient::get_url(r1, "location")
#' list1 <- custom_list(loc = loc)
#'
#' # upload & screen
#' list2 <- custom_list(fn)
#' identical(list1, list2)
#' @export
custom_list <- function(txt = "", loc = "", schema = "bds_schema_str.json") {
  site <- request_site(txt, loc, schema = schema)

  ind <- get_tgt(txt, loc, schema = schema)

  res <- screen_curves_ind(ind)

  last_dscore <- NULL
  if (!is.null(ind)) {
    d <- ind@dsc@y[length(ind@dsc@y)]
    if (length(d) && !is.na(d)) last_dscore <- d
  }

  # list of two elements if nu D-score, else 3 elements
  if (is.null(last_dscore)) {
    ret <- list(
      UrlGroeicurven = unbox(site),
      Resultaten = res
    )
  } else {
    ret <- list(
      UrlGroeicurven = unbox(site),
      Resultaten = res,
      LaatsteDscore = unbox(last_dscore)
    )
  }
  ret
}
