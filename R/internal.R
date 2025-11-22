# JAMES - A program to monitor and interpret child growth and development.
# Copyright (C) 2025 Stef van Buuren (stef.vanbuuren@tno.nl)
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

# Uploads data to OpenCPU and returns session key
get_session <- function(txt, sitehost, format = "3.0", ...) {
  ocpu_host <- detect_ocpu_host(sitehost)

  if (!is.character(txt)) {
    txt <- jsonlite::toJSON(txt, auto_unbox = TRUE)
  }

  upload_url <- paste0(ocpu_host, "/ocpu/library/james/R/upload_data")

  h <- curl::new_handle()
  curl::handle_setform(
    h,
    txt = curl::form_data(txt, type = "text/plain; charset=utf-8"),
    format = curl::form_data(format, type = "text/plain")
  )

  res <- curl::curl_fetch_memory(upload_url, handle = h)

  header_text <- rawToChar(res$headers)
  lines <- strsplit(header_text, "\r\n|\n|\r")[[1]]

  # CASE-INSENSITIVE SEARCH
  match <- grep("^x-ocpu-session:", lines, value = TRUE, ignore.case = TRUE)

  if (length(match) == 0) {
    return(NA_character_)
  }

  session <- sub("^x-ocpu-session:\\s*", "", match, ignore.case = TRUE)
  return(session)
}


# returns targetl or NULL
get_tgt <- function(txt = "", session = "", ...) {
  # no data
  if (is.empty(txt) && is.empty(session)) {
    return(NULL)
  }

  # create target data on-the-fly (without data storage)
  if (!is.empty(txt)) {
    return(read_bds(txt, ...))
  }

  # download data from session
  # data <- eval(parse(text = paste0(session, ":.val")))
  data <- get_session_object(session)

  # check for a tgt object
  if (!(is.list(data) && all(c("psn", "xyz") %in% names(data)))) {
    warning(paste("session contains no data:", session), call. = FALSE)
    return(NULL)
  }

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
  warning("session not found: ", session, call. = FALSE)
  return(NULL)
}


is.empty <- function(x) nchar(x[1L]) == 0L || is.null(x)

get_max_age <- function(target) {
  max_age <- NA_real_
  if (!is.null(target)) {
    x <- timedata(target)[["age"]]
    max_age <- ifelse(sum(!is.na(x)), max(x, na.rm = TRUE), NA_real_)
  }
  return(max_age)
}
