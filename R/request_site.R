# JAMES - A program to monitor and interpret child growth and development.
# Copyright (C) 2025 Stef van Buuren (stef.vanbuuren@tno.nl)
# Arjan Huizing (arjan.huizing@tno.nl)
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

#' Request site containing personalised charts
#'
#' Server-side function to construct a URL to a site that shows a personalised
#' growth chart. The site includes a navigation bar so that the end
#' user can interact to chart choices.
#' @param txt A JSON string, URL or file with the data in JSON
#' format. The input data adhere to specification
#' [BDS JGZ 3.2.5](https://www.ncj.nl/themadossiers/informatisering/basisdataset/documentatie/?cat=12),
#' and are converted to JSON according to `schema`.
#' @param sitehost The host that renders the site. Normally, that would be equal
#' to the host on which JAMES runs. If not specified, the function throws a warning
#' and sets `sitehost` to `"http://localhost:8080"`.
#' @param session Alternative to `txt`. Session key where input data is uploaded
#' on `sitehost`.
#' @param upload Logical. If `TRUE` then `request_site()` will upload
#' the data in `txt` to `sitehost` and return a site address with
#' the `?session=` query appended.
#' Setting (`FALSE`) just appends `?txt=` to the site url, thus
#' deferring validation and conversion to internal representation to the site.
#' @param loc Alternative to `txt`. Location where input data is uploaded.
#' Argument `loc` is deprecated and will disappear in Nov 2022; please
#' use `session` instead.
#' @inheritParams draw_chart
#' @return URL composed of JAMES server, possibly appended by query string starting
#' with `?txt=` or `?session=`.
#' @seealso [jamesclient::james_post()], [jamesclient::get_url()]
#' @details
#' One of `txt` or `session` needs to be specified. If both are given,
#' `txt` takes precedence. If neither is given, then the function returns
#' the base site without any data.
#'
#' @examples
#' fn <- system.file("testdata", "client3.json", package = "james")
#' js <- jsonlite::toJSON(jsonlite::fromJSON(fn), auto_unbox = TRUE)
#' url <- "https://groeidiagrammen.nl/ocpu/library/james/testdata/client3.json"
#' host <- "http://localhost:8080"
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
                         format = "1.0",
                         upload = TRUE,
                         loc = "",
                         ...) {
  authenticate(...)

  if (!missing(loc)) {
    warning("Argument loc is deprecated and will disappear in Nov 2022; please use session instead.",
            call. = FALSE
    )
    session <- loc2session(loc)
  }

  if (is.empty(sitehost)) {
    warning("Argument sitehost not found. Defaulting to http://localhost:8080.",
            call. = FALSE)
    sitehost <- "http://localhost:8080"
  }

  txt <- txt[1L]
  session <- session[1L]
  url <- parse_url(sitehost)

  # no data
  if (is.empty(txt) && is.empty(session)) {
    return(modify_url(url, path = file.path(url$path, "site")))
  }

  # perform implicit upload
  # if we have txt and no session, upload the data in txt in a separate request
  # return the URL with site?session=...
  if (!is.empty(txt) && is.empty(session) && upload) {
    session <- get_session(txt, sitehost, format = format)
    return(modify_url(url,
                      path = file.path(url$path, "site"),
                      query = paste0("session=", session)))
  }

  # if session was specified explicitly as argument
  # we need to check for its validity
  # and return empty site if invalid
  if (!is.empty(session)) {
    data <- get_session_object(session)
    if (is.null(data)) {
      return(
        modify_url(url,
                   path = file.path(url$path, "site"))
      )
    } else {
      return(
        modify_url(url,
                   path = file.path(url$path, "site"),
                   query = paste0("session=", session))
      )
    }
  }

  # return ?txt=... query parameter if we don't upload
  # not recommended
  if (!is.empty(txt) && !upload && validate(txt)) {
    return(modify_url(url,
                      path = file.path(url$path, "site"),
                      query = paste0("txt=", minify(txt))))
  }

  # site without data
  return(modify_url(url,
                    path = file.path(url$path, "site"))
  )
}
