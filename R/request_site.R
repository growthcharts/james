#' Request site containing personalised charts
#'
#' Constructs a URL to a JAMES site showing a personalised growth chart.
#' Optionally uploads the data to the server and returns a session-based URL.
#'
#' @param txt A JSON string, URL, or file with BDS data in JSON format. Data
#' should conform to the BDS JGZ 3.2.5 specification.
#' @param sitehost The server that renders the site. Defaults to
#' `"http://localhost:8080"` if not specified.
#' @param session Optional session key if data is already uploaded to `sitehost`.
#' @param format JSON schema version, e.g., `"3.0"`. Used when uploading.
#' @param upload Logical. If `TRUE`, uploads `txt` and returns URL with
#' `?session=`. If `FALSE`, appends `?txt=` directly (not recommended).
#' @param loc Deprecated. Use `session` instead.
#' @inheritParams draw_chart
#' @return A character string URL pointing to the personalised JAMES site.
#' @seealso [jamesclient::james_post()], [jamesclient::get_url()]
#' @examples
#' fn <- system.file("testdata", "client3.json", package = "james")
#' js <- jsonlite::toJSON(jsonlite::fromJSON(fn), auto_unbox = TRUE)
#' url <- "https://groeidiagrammen.nl/ocpu/library/james/testdata/client3.json"
#' host <- "http://localhost:8080"
#' host <- "https://james.groeidiagrammen.nl"
#'
#' # solutions that upload the data and create a URL with the `?session=` query parameter
#' \dontrun{
#' # upload file - works with docker on localhost
#' site <- request_site(sitehost = host, txt = fn)
#' # browseURL(site)
#'
#' # upload JSON string
#' site <- request_site(sitehost = host, txt = js)
#' site
#' # browseURL(site)
#'
#' # upload URL
#' site <- request_site(sitehost = host, txt = url)
#' site
#' # browseURL(site)
#'
#' # same, but in two steps, starting from file name
#' # this also works for js and url
#' resp <- jamesclient::james_post(path = "data/upload", txt = fn)
#' session <- resp$session
#' site <- request_site(sitehost = host, session = session)
#' site
#' # browseURL(site)
#'
#' # solutions that create an immediate ?txt=[..data..] query
#' # this method does not create a cache on the server
#' site <- request_site(sitehost = host, txt = js, upload = FALSE)
#' # browseURL(site)
#' }
#' @export
request_site <- function(txt = "",
                         sitehost = "",
                         session = "",
                         format = "3.0",
                         upload = TRUE,
                         loc = "",
                         ...) {
  authenticate(...)

  if (!missing(loc)) {
    warning("Argument `loc` is deprecated and will be removed. Use `session` instead.", call. = FALSE)
    session <- loc2session(loc)
  }

  if (is.empty(sitehost)) {
    warning("Argument `sitehost` not provided. Defaulting to http://localhost:8080.", call. = FALSE)
    sitehost <- "http://localhost:8080"
  }

  txt <- txt[1L]
  session <- session[1L]

  # CASE 1: Neither txt nor session provided – return base site URL
  if (is.empty(txt) && is.empty(session)) {
    return(httr::modify_url(sitehost, path = "site"))
  }

  # CASE 2: txt provided, no session, and upload = TRUE → upload data
  if (!is.empty(txt) && is.empty(session) && upload) {
    session <- get_session(txt, sitehost, format = format)
    return(httr::modify_url(sitehost, path = "site", query = list(session = session)))
  }

  # CASE 3: Valid session provided (or via loc), return site?session=...
  if (!is.empty(session)) {
    data <- get_session_object(session)
    if (is.null(data)) {
      # Invalid session – return base site
      return(httr::modify_url(sitehost, path = "site"))
    } else {
      return(httr::modify_url(sitehost, path = "site", query = list(session = session)))
    }
  }

  # CASE 4: txt provided and upload = FALSE – return site?txt=... (not recommended)
  if (!is.empty(txt) && !upload && validate(txt)) {
    return(httr::modify_url(sitehost, path = "site", query = list(txt = minify(txt))))
  }

  # Default: return base site
  httr::modify_url(sitehost, path = "site")
}
