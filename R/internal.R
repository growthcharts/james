# JAMES - A program to monitor and interpret child growth and development.
# Copyright (C) 2022 Stef van Buuren (stef.vanbuuren@tno.nl)
# Arjan Huizing (arjan.huizing@tno.nl)
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

loc2session <- function(url) {
  surl <- strsplit(url, "/")[[1L]]
  matches <- surl[grepl("x0", surl)]
  if (length(matches)) {
    return(matches[[length(matches)]])
  }
  return("")
}

convert_str_age <- function(s) {
  # converts s to decimal age
  # s is formatted as "number|unit", where unit
  # is 'd' (days), 'w' (weeks), 'm' (months), 'y' or 'j' (years)
  # s <- c("2m", "7.5m", "1y", "12", "", NULL, "xd")
  units <- substr(s, nchar(s), nchar(s))
  numbers <- as.numeric(gsub("[^\\d\\.]+", "", s, perl = TRUE))
  z <- numbers
  z[units == "d"] <- z[units == "d"] / 365.25
  z[units == "w"] <- z[units == "w"] * 7 / 365.25
  z[units == "m"] <- z[units == "m"] / 12
  round(z, 4)
}

# uploads data and returns session
get_session <- function(txt, sitehost, format) {
  resp <- james_post(sitehost = sitehost, path = "data/upload", txt = txt, format = format)
  if (status_code(resp) != 201L) {
    message_for_status(resp,
                       task = paste0(
                         "upload data", "\n",
                         content(resp, "text", encoding = "utf-8")
                       )
    )
    return("")
  }
  get_url(resp, "session")
}


# returns targetl or NULL
get_tgt <- function(txt = "", session = "", ...) {

  # no ind
  if (is.empty(txt) && is.empty(session)) {
    return(NULL)
  }

  # create target data on-the-fly
  if (!is.empty(txt)) {
    return(read_bds(txt, ...))
  }

  # download data from session
  # data <- eval(parse(text = paste0(session, ":.val")))
  data <- get_session_object(session)
  return(data)
}

#' Load data from a previous OpenCPU session on same host
#'
#' This function loads data from a previous OpenCPU session on the same host.
#' The assumption is that sessions are stored in path `/tmp/ocpu-store`.
#' Provides a short-cut to the data eliminating the need to make self-requests.
#'
#' @param session Character, e.g. `session = "x077dd78bd0bbc6"`
#' @param object  Character, e.g. `object = ".val"`. Refers to objects within the
#' `/R` path (e.g. function returns or variables saved in scripts).
#' @return
#' If found, object from a the session. If not found, the function generates a
#' warning and return `NULL`.
#' @examples
#' \dontrun{
#' get_session_object(session = "x02a93ec661121", object = ".val")
#' }
get_session_object = function(session, object = ".val") {
  sessionenv <- new.env()
  sessionfile <- file.path("/tmp/ocpu-store", session, ".RData")
  if (file.exists(sessionfile)) {
    load(sessionfile, envir = sessionenv)
    return(sessionenv[[object]])
  }
  warning("session not found: ", session)
  return(NULL)
}


is.empty <- function(x) nchar(x[1L]) == 0L || is.null(x)
