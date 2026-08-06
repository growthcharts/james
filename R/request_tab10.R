# JAMES - A program to monitor and interpret child growth and development.
# Copyright (C) 2025 Stef van Buuren (stef.vanbuuren@tno.nl)
# Arjan Huizing (arjan.huizing@tno.nl)
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

#' Request a tab10 session URL for personalised risk communication
#'
#' Uploads BDS data to the server (reusing the same upload mechanism as
#' [upload_data()]) and constructs a URL to a standalone `tab10` deployment
#' with the resulting session key attached. Callers (e.g. `jamesapp`) use the
#' returned URL to hand off control to `tab10`, which retrieves the uploaded
#' data itself via the session's `/rda` path.
#' @param txt A JSON string, URL, or file with BDS data in JSON format. Data
#' should conform to the BDS JGZ 3.2.5 specification.
#' @param sitehost The JAMES server that receives the upload (the same host
#' serving this very endpoint). Defaults to `"http://localhost:8080"` if not
#' specified.
#' @param tab10host The server hosting the `tab10` Shiny app, e.g.
#' `"https://james.groeidiagrammen.nl/tab10"`. Defaults to `sitehost` with a
#' `/tab10` path appended.
#' @param session Optional session key if data is already uploaded to
#' `sitehost` (e.g. by a prior [request_site()] call). When given, `txt` is
#' ignored and no new upload happens -- `tab10` retrieves the data itself via
#' the existing session's `/rda` path, so the same session key already used
#' for `/site` can be handed to `tab10` as-is.
#' @param format JSON schema version, e.g., `"3.0"`. Used when uploading.
#' @return A character string URL pointing to the `tab10` app with a
#' `?session=` query parameter, or, if no session could be obtained, the bare
#' `tab10host` URL.
#' @seealso [request_site()], [upload_data()]
#' @examples
#' fn <- system.file("testdata", "client3.json", package = "james")
#' \dontrun{
#' url <- request_tab10(txt = fn, sitehost = "http://localhost:8080")
#' url
#' }
#' @author Stef van Buuren 2026
#' @keywords server
#' @export
request_tab10 <- function(
  txt = "",
  sitehost = "",
  tab10host = "",
  session = "",
  format = "3.0",
  ...
) {
  authenticate(...)

  if (is.empty(sitehost)) {
    warning(
      "Argument `sitehost` not provided. Defaulting to http://localhost:8080.",
      call. = FALSE
    )
    sitehost <- "http://localhost:8080"
  }

  if (is.empty(tab10host)) {
    parsed <- httr::parse_url(sitehost)
    tab10host <- httr::modify_url(
      sitehost,
      path = gsub("//+", "/", file.path(parsed$path, "tab10"))
    )
  }

  txt <- txt[1L]
  session <- session[1L]

  # Session already provided (e.g. reused from a prior request_site() call):
  # hand it straight to tab10, no re-upload. tab10 fetches the data itself
  # via /{session}/rda, which works cross-container over HTTP -- unlike
  # get_session_object(), it doesn't depend on sitehost's filesystem.
  if (!is.empty(session)) {
    return(httr::modify_url(tab10host, query = list(session = session)))
  }

  # No data: return the bare tab10 URL
  if (is.empty(txt)) {
    return(httr::modify_url(tab10host))
  }

  # get_session() uploads txt to sitehost's /ocpu/library/james/R/upload_data
  # (see internal.R) and returns the resulting OpenCPU session key. This
  # must be sitehost (where james itself runs), not tab10host.
  session <- get_session(txt, sitehost, format = format)

  if (is.na(session)) {
    return(httr::modify_url(tab10host))
  }

  httr::modify_url(tab10host, query = list(session = session))
}