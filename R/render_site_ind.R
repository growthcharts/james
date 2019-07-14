#' Render the site starting from BDS data
#'
#' The function constructs the url that points to the site
#' with the individual data.
#' @param location A url that points to the server location where the
#' data from a previous request to \code{convert_bds_ind()} are stored.
#' @param chartcode The code of the requested growth chart. If not
#' specified, the server will automatically plot child height for
#' the most recent age period.
#' @inheritParams chartplotter::process_chart
#' @return A url pointing to the site
#' @author Stef van Buuren 2019
#' @seealso \linkS4class{individual},
#' \code{\link{draw_chart_ind}}
#' @keywords server
#' @export
render_site_ind <- function(location = NULL, chartcode = NULL,
                            curve_interpolation = TRUE) {

  # get the object stored by convert_bds_ind
  rda <- paste0(location, "R/.val/rda")
  con <- curl(rda)
  load(file = con)
  ind <- .val
  close(con)
  rm(".val")

  if (is.null(chartcode))
    chartcode <- select_chart(ind)$chartcode

  # return url to site with individual data
  url1 <- "http://localhost:5656/ocpu/apps/stefvanbuuren/james/www/"
  param <- paste0("url_data", location, sep = "=")
  paste(url1, param, sep = "?")
}
