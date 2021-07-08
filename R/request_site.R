#' Request site containing personalised charts
#'
#' Server-side function to construct a URL to a site that shows a personalised
#' growth chart. The site includes a navigation bar so that the end
#' user can interact to chart choices.
#' @param txt A JSON string, URL or file with the data in JSON
#' format. The input data adhere to specification
#' [BDS JGZ 3.2.5](https://www.ncj.nl/themadossiers/informatisering/basisdataset/documentatie/?cat=12),
#' and are converted to JSON according to `schema`.
#' @param loc Alternative to `txt`. Location where input data is uploaded
#' and converted to internal server format.
#' @param upload Logical. If `TRUE` then `request_site()` will upload
#' the data in `txt` and return a site address with the `?loc=` query appended.
#' Setting (`FALSE`) just appends `?txt=` to the site url, thus
#' deferring validation and conversion to internal representation to the site.
#' @param host URL of the JAMES server. By default, host is the currently
#' running server that processes the request.
#' @inheritParams bdsreader::read_bds
#' @return URL composed of JAMES server, possibly appended by query string starting
#' with `?txt=` or `?loc=`.
#' @seealso [jamesclient::upload_txt()], [jamesclient::get_url()]
#' @details
#' One of `txt` or `loc` needs to be specified. If both are given,
#' `txt` takes precedence. If neither is given, then the function returns
#' the base site without any data.
#'
#' @note This function does not yet work with Docker because we cannot get the
#' host URL name.
#' The output form `?txt=` currently ignores the `schema` argument.
#'
#' @examples
#' fn <- system.file("testdata", "client3.json", package = "james")
#' js <- jsonlite::toJSON(jsonlite::fromJSON(fn), auto_unbox = TRUE)
#' url <- "https://groeidiagrammen.nl/ocpu/library/james/testdata/client3.json"
#' host <- "http://localhost"
#'
#' # solutions that upload the data and create a URL with the `?loc=` query parameter
#' \dontrun{
#' # upload file - does not work (object 'bds_schema_str.json' not found)
#' site <- request_site(fn, host = host)
#' # browseURL(site)
#'
#' # upload JSON string
#' site <- request_site(js, host = host)
#' site
#' # browseURL(site)
#'
#' # upload URL
#' site <- request_site(url, host = host)
#' site
#' # browseURL(site)
#'
#' # same, but in two steps, starting from file name
#' # this also works for js and url
#' resp <- jamesclient::upload_txt(fn, host = host)
#' loc <- jamesclient::get_url(resp, "location")
#' site <- request_site(loc = loc)
#' site
#' # browseURL(site)
#'
#' # solutions that create an immediate ?txt=[..data..] query
#' # this method does not create a cache on the server
#' site <- request_site(fn, upload = FALSE)
#' site <- request_site(js, upload = FALSE)
#' site <- request_site(url, upload = FALSE)
#' # browseURL(site)
#' }
#' @export
request_site <- function(txt = "", loc = "",
                         version = 2L,
                         upload = TRUE, host = NULL) {
  txt <- txt[1L]
  loc <- loc[1L]

  # What is the URL of the server where I run?
  if (is.null(host)) host <- get_host()
  site <- paste0(host, "/ocpu/lib/james/www/")

  # no data
  if (is.empty(txt) && is.empty(loc)) {
    return(site)
  }

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
  if (!is.empty(txt) && upload) {
    loc <- get_loc(txt, host, version = version)
  }

  ifelse(loc == "", site, paste0(site, "?loc=", loc))
}
