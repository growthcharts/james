#' Request site containing personalised charts
#'
#' Server-side function to construct a URL to a site that shows a personalised
#' growth chart. The site includes a navigation bar so that the end
#' user can interact to chart choices.
#' @param txt A JSON string, URL or file with the data in JSON
#' format. The input data adhere to specification
#' \href{https://www.ncj.nl/themadossiers/informatisering/basisdataset/documentatie/?cat=12}{BDS JGZ 3.2.5},
#' and are converted to JSON according to \code{schema}.
#' @param loc Alternative to \code{txt}. Location where input data is uploaded
#' and converted to internal server format.
#' @param schema Optional. A JSON string, URL or file that selects the JSON validation
#' schema. Only used if the \code{txt} argument is specified.
#' @param upload Logical. If \code{TRUE} then \code{request_site()} will upload
#' the data in \code{txt} and return a site address with the \code{?loc=} query appended.
#' Setting (\code{FALSE}) just appends \code{?txt=} to the site url, thus
#' deferring validation and conversion to internal representation to the site.
#' @param host URL of the JAMES server. By default, host is the currently
#' running server that processes the request.
#' @return URL composed of JAMES server, possibly appended by query string starting
#' with \code{?txt=} or \code{?loc=}.
#' @seealso \code{\link{upload_txt}}, \code{\link[jamesclient]{get_url}}
#' @details
#' One of \code{txt} or \code{loc} needs to be specified. If both are given,
#' \code{txt} takes precedence. If neither is given, then the function returns
#' the base site without any data.
#'
#' @note This function does not yet work with Docker because we cannot get the
#' host URL name.
#' The output form \code{?txt=} currently ignores the \code{schema} argument.
#'
#' @examples
#' fn <- system.file("testdata", "client3.json", package = "james")
#' js <- jsonlite::toJSON(jsonlite::fromJSON(fn), auto_unbox = TRUE)
#' url <- "https://groeidiagrammen.nl/ocpu/library/james/testdata/client3.json"
#'
#' # solutions that create a ?loc= parameter
#'
#' # upload JSON string to default host, return site url
#' site <- request_site(js)
#' site
#' browseURL(site)
#' request_site(url)
#'
#' # same, as two steps, starting from file name
#' resp <- upload_txt(fn)
#' loc <- jamesclient::get_url(resp, "location")
#' request_site(loc = loc)
#'
#' # solutions that create a ?txt= parameter
#'
#' request_site(fn, upload = FALSE)
#' request_site(js, upload = FALSE)
#' request_site(url, upload = FALSE)
#' @export
request_site <- function(txt = "", loc = "", schema = NULL,
                         upload = TRUE, host = NULL) {

  txt <- txt[1L]
  loc <- loc[1L]

  # What is the URL of the server where I run?
  if (is.null(host)) host <- get_host()
  site <- paste0(host, "/ocpu/lib/james/www/")

  # no data
  if (is.empty(txt) && is.empty(loc))
    return(site)

  # return ?txt=
  if (!is.empty(txt) && !upload) {

    # json string
    if (validate(txt)) {
      return(paste0(site, "?txt=", minify(txt)))
    }

    # url
    if (startsWith(txt, "http")) {
      req <- curl::curl_fetch_memory(txt)
      if (req$status_code != 200L) {
        message("txt = ", txt, ", - status code", req$status_code, ".")
        return(site)
      }
      js <- rawToChar(req$content)
      if (!validate(js)) {
        message("txt = ", txt, " - URL does not contain valid JSON.")
        return(site)
      }
      return(paste0(site, "?txt=", minify(js)))
    }

    # file
    # when run as server - Is this a security risk?
    if (file.exists(txt)) {
      js <- jsonlite::toJSON(jsonlite::fromJSON(txt), auto_unbox = TRUE)
      if (!validate(js)) {
        message("txt = ", txt, " - File does not contain valid JSON.")
        return(site)
      }
      return(paste0(site, "?txt=", minify(js)))
    }
  }

  # # return ?loc=, possibly after upload of txt
  if (!is.empty(txt) && upload)
    loc <- get_loc(txt, host, schema)

  ifelse(loc == "", site, paste0(site, "?loc=", loc))
}
