#' Upload and parse data for JAMES
#'
#' Server side upload of a JSON file, string or URL with BDS data, checks the data,
#' stores its contents as an object of class
#' \code{\link[minihealth:individual-class]{individual}} on host,
#' and returns an object of class \code{\link[httr:response]{response}}
#' that contains the results of the request.
#' @inheritParams request_site
#' @param host String with URL of the JAMES host machine. Defaults to
#' \code{https://groeidiagrammen.nl}.
#' @return An object of class \code{\link[httr:response]{response}}
#' @details
#' JSON format: See
#' \url{https://stefvanbuuren.name/jamesdocs/getting-data-into-james.html}
#' for the specification of the JSON format.
#'
#' User agent: The function \code{upload_txt()} searches for an object called \code{ua} on the search
#' list. The \code{ua} object is an optional user agent, a request that identifies
#' yourself to the API. For example, run
#' \code{httr::user_agent("https://github.com/myaccount")} (with
#' \code{myaccount} replaced by your github user name) before
#' calling \code{upload_txt()}. See
#' \url{https://httr.r-lib.org/articles/api-packages.html} for details. Setting
#' the user agent is not required.
#'
#' Append \code{"/json"} to \code{path} and set \code{query = "auto_unbox=TRUE&force=TRUE"}
#' to obtain a partial JSON representation of the S4 class \code{individual}. At present, it is not
#' possible to rebuild the S4 class \code{individual} from its JSON representation because
#' the S4 class depends on environments, and these are not converted to JSON.
#' Warning: The S4 class
#' \code{individual} is an internal format that is in development. It is likely to
#' change, so don't build applications based on this data structure. If you need
#' components from the internal structure (e.g. Z-scores, brokenstick estimates) it
#' is better to develop a dedicated API for obtaining these.
#'
#' @note Argument \code{schema} not yet implemented.
#' @examples
#' library(httr)
#' fn  <- system.file("extdata", "allegrosultum", "client3.json", package = "jamestest")
#' js  <- jsonlite::toJSON(jsonlite::fromJSON(fn), auto_unbox = TRUE)
#'
#' url <- "https://groeidiagrammen.nl/ocpu/library/james/testdata/client3.json"
#' # host <- "https://groeidiagrammen.nl"
#' host <- "http://localhost"
#'
#' # upload JSON file
#' r1 <- upload_txt(fn, host)
#' identical(status_code(r1), 201L)
#'
#' # upload JSON string
#' r2 <- upload_txt(js, host)
#' identical(status_code(r2), 201L)
#'
#' # upload JSON from external URL
#' r3 <- upload_txt(url, host)
#' identical(status_code(r3), 201L)
#' @seealso \code{\link[minihealth]{convert_bds_individual}},
#' \code{\link{request_site}}
#' @export
upload_txt <- function(txt, host = "https://groeidiagrammen.nl", schema = NULL) {

  url <- modify_url(url = host, path = "ocpu/library/james/R/convert_bds_ind")
  txt <- txt[[1L]]
  ua <- get0("ua", mode = "list")
  try.error <- FALSE

  if (file.exists(txt))
    # txt is a file name: upload
    resp <- POST(url = url,
                 body = list(txt = upload_file(txt), schema = schema),
                 encode = "multipart",
                 ua,
                 add_headers(Accept = "plain/text"))
  else {
    # txt is a URL: overwrite txt with JSON string
    if (!validate(txt)) {
      con.url <- try(con <- url(txt, open = 'rb'), silent = TRUE)
      try.error <- inherits(con.url, "try-error")
      if (!try.error) {
        txt <- toJSON(fromJSON(txt, flatten = TRUE), auto_unbox = TRUE)
        close(con)
      }
    }
    # txt is JSON string: upload
    resp <- POST(url = url,
                 body = list(txt = txt),
                 encode = "json",
                 ua,
                 add_headers(Accept = "plain/text"))
  }

  # throw warnings and messages
  if (try.error) warning("Data URL not found (404)")
  url_warnings <- get_url(resp, "warnings")
  url_messages <- get_url(resp, "messages")
  if (length(url_warnings) >= 1L)
    warning(content(GET(url_warnings), "text", encoding = "utf-8"))
  if (length(url_messages) >= 1L)
    message(content(GET(url_messages), "text", encoding = "utf-8"))

  resp
}
