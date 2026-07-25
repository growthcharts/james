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
#' @param display A named list of display defaults, appended as extra query
#' parameters so an API consumer can set them without the end user having to
#' click through the site's "Instellingen" panel. Recognised names:
#' \describe{
#'   \item{`interactive`}{Logical. Show the interactive (plotly) chart
#'   instead of the default fixed (grid) one.}
#'   \item{`interpolation`}{Logical. Show the child's curve interpolated
#'   between observations. Defaults to `TRUE` in the site itself.}
#'   \item{`size`}{Integer. Chart display size in pixels (400-1000).}
#' }
#' Unset elements are omitted, leaving the site's own defaults in place.
#' @inheritParams draw_chart
#' @return A character string URL pointing to the personalised JAMES site.
#' @seealso [jamesclient::james_post()], [jamesclient::get_url()]
#' @examples
#' fn <- system.file("testdata", "client3.json", package = "james")
#' js <- jsonlite::toJSON(jsonlite::fromJSON(fn), auto_unbox = TRUE)
#' url <- "https://james.groeidiagrammen.nl/ocpu/library/james/testdata/client3.json"
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
#'
#' # set display defaults (interactive chart, no interpolation, 600px)
#' # without the user having to click through Instellingen
#' site <- request_site(
#'   sitehost = host, txt = fn,
#'   display = list(interactive = TRUE, interpolation = FALSE, size = 600)
#' )
#' site
#' # browseURL(site)
#' }
#' @export
request_site <- function(
  txt = "",
  sitehost = "",
  session = "",
  format = "3.0",
  upload = TRUE,
  loc = "",
  display = list(),
  ...
) {
  authenticate(...)

  if (!missing(loc)) {
    warning(
      "Argument `loc` is deprecated and will be removed. Use `session` instead.",
      call. = FALSE
    )
    session <- loc2session(loc)
  }

  if (is.empty(sitehost)) {
    warning(
      "Argument `sitehost` not provided. Defaulting to http://localhost:8080.",
      call. = FALSE
    )
    sitehost <- "http://localhost:8080"
  }

  txt <- txt[1L]
  session <- session[1L]

  # Helper function to append /site to existing path
  append_site_path <- function(url) {
    parsed <- httr::parse_url(url)
    new_path <- file.path(parsed$path, "site")
    # Remove any double slashes except after protocol
    new_path <- gsub("//+", "/", new_path)
    return(new_path)
  }

  # Turns display = list(interactive = TRUE, interpolation = FALSE, size =
  # 600) into query params matching what inst/www/js/start.js reads
  # (?interactive=, ?interpolation=, ?size=) to seed the site's
  # "Instellingen" panel before the first render. Unrecognised names are
  # dropped rather than erroring, so a typo doesn't break the whole URL.
  display_query <- function(display) {
    recognised <- intersect(names(display), c("interactive", "interpolation", "size"))
    if (!length(recognised)) {
      return(list())
    }
    lapply(display[recognised], function(x) {
      if (is.logical(x)) tolower(as.character(x)) else as.character(x)
    })
  }
  extra_query <- display_query(display)

  # CASE 1: Neither txt nor session provided – return base site URL
  if (is.empty(txt) && is.empty(session)) {
    return(httr::modify_url(sitehost, path = append_site_path(sitehost), query = extra_query))
  }

  # CASE 2: txt provided, no session, and upload = TRUE → upload data
  if (!is.empty(txt) && is.empty(session) && upload) {
    session <- get_session(txt, sitehost, format = format)

    if (is.na(session)) {
      return(httr::modify_url(sitehost, path = append_site_path(sitehost), query = extra_query))
    } else {
      return(httr::modify_url(
        sitehost,
        path = append_site_path(sitehost),
        query = c(list(session = session), extra_query)
      ))
    }
  }

  # CASE 3: Valid session provided (or via loc)
  if (!is.empty(session)) {
    data <- get_session_object(session)
    if (is.null(data)) {
      return(httr::modify_url(sitehost, path = append_site_path(sitehost), query = extra_query))
    } else {
      return(httr::modify_url(
        sitehost,
        path = append_site_path(sitehost),
        query = c(list(session = session), extra_query)
      ))
    }
  }

  # CASE 4: txt provided and upload = FALSE – return ?txt=
  if (!is.empty(txt) && !upload && validate(txt)) {
    return(httr::modify_url(
      sitehost,
      path = append_site_path(sitehost),
      query = c(list(txt = minify(txt)), extra_query)
    ))
  }

  httr::modify_url(sitehost, path = append_site_path(sitehost), query = extra_query)
}
