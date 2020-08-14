#' Request site containing personalised charts
#'
#' Server-side function cto construct a URL to a site that shows a personalised
#' growth chart. The site includes a navigation bar so that the end
#' user can tweak chart choice.
#' @param txt A JSON string, URL or file, with the data (in JSON
#'   format) to be uploaded. The variable specification are expected
#'   to be according specification
#'   \href{https://www.ncj.nl/themadossiers/informatisering/basisdataset/documentatie/?cat=12}{BDS
#'    JGZ 3.2.5}, and converted to JSON.
#' @param loc Alternative to \code{txt}. Location where data is uploaded
#' and processed, for example, as obtained by \code{upload_txt()}.
#' @param schema Optional. A JSON string, URL or file that selects the JSON validation
#' schema. Only relevant if \code{txt} is specified.
#' @return URL composed of JAMES server and query string starting
#' with \code{?loc=...}, which indicates the URL of the uploaded
#' child data
#' @seealso \code{\link{upload_txt}}, \code{\link[jamesclient]{get_url}}
#' @details
#'
#' The function can take child data in two forms: 1) a JSON file with
#' BDS-formatted child data (argument \code{txt}) or, 2) a URL with
#' child data on a previously stored server location on the server
#' (argument \code{loc}).
#'
#' One of \code{txt} or \code{loc} need to be specified. If both are given,
#' \code{txt} takes precedence. The \code{txt} option uploads the data to the
#' host that runs \code{request_side()}.
#'
#' @note This not yet work with Docker because we cannot get the host URL.
#' @examples
#' fn <- system.file("extdata", "smocc", "Laura_S.json", package = "jamestest")
#'
#' # as two steps (upload to default site groeidiagrammen.nl)
#' resp <- upload_txt(fn)
#' loc <- jamesclient::get_url(resp, "location")
#' request_site(loc = loc)
#'
#' \dontrun{
#' # upload to localhost (if running)
#' resp <- upload_txt(fn, "http://localhost")
#' loc <- jamesclient::get_url(resp, "location")
#' request_site(loc = loc)
#'
#' # as one step
#' request_site(fn)
#' }
#' @export
request_site <- function(txt = NULL, loc = NULL, schema = NULL) {

  # What is the URL of the server where I run?
  host <- get_host()
  site <- paste0(host, "/ocpu/lib/james/www/")

  if (is.null(txt) && is.null(loc)) return(site)
  if (!is.null(txt)) loc <- get_loc(txt, host, schema)

  paste0(site, "?loc=", loc)
}
