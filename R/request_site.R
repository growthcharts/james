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
#' with \code{?ind=...}, which indicates the URL of the uploaded
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
#' \code{txt} takes precedence.
#' @note The \code{txt} option uploads and processes the data on the host where
#' this code runs.
#' @examples
#' fn <- system.file("extdata", "allegrosultum", "client3.json", package = "jamestest")
#' fn <- system.file("extdata", "smocc", "Laura_S.json", package = "jamestest")
#'
#' # as two steps
#' resp <- upload_txt(fn)
#' loc <- jamesclient::get_url(resp, "location")
#' site_url <- request_site(loc = loc)
#' site_url
#' # browseURL(site_url)
#'
#' # as one step
#' site_url <- request_site(fn)
#' site_url
#' @export
request_site <- function(txt = NULL, loc = NULL, schema = NULL) {

  # derive static URL of host on which code runs
  # note: under Docker, hostname is container ID, so we need to adapt
  # this code when running under docker
  hostname <- system("hostname", intern = TRUE)
  host <- switch(hostname,
                 groeidiagrammen = "https://groeidiagrammen.nl",
                 opa = "https://vps.stefvanbuuren.nl",
                 "http://localhost")
  url_bare <- paste0(host, "/ocpu/lib/james/www/")

  # no input
  if (is.null(txt) && is.null(loc)) return(url_bare)

  # upload txt data and return loc
  if (!is.null(txt)) {
    get_loc <- function(x) {
      tryCatch(error = function(cnd) stop("Cannot upload"),
               {
                 resp <- upload_txt(x, host = host)
                 get_url(resp, "location")
               }
      )
    }
    loc <- get_loc(txt)
  }

  paste0(url_bare, "?ind=", loc)
}
