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

# return the (likely) base URL of the ocpu server
get_host <- function() {
  hostname <- system("hostname", intern = TRUE)
  if (hostname == "opa") hostname <- "vps.stefvanbuuren.nl"
  scheme <- ifelse(hostname == "localhost", "http:", "https:")
  host <- paste0(scheme, "//", hostname)
  return(host)
}

# returns url of uploaded data
get_loc <- function(txt, host, format) {
  resp <- james_post(host = host, path = "data/upload", txt = txt, format = format)
  if (status_code(resp) != 201L) {
    message_for_status(resp,
                       task = paste0(
                         "upload data", "\n",
                         content(resp, "text", encoding = "utf-8")
                       )
    )
    return("")
  }
  get_url(resp, "location")
}

# returns session of uploaded data
get_session <- function(txt, host, format) {
  resp <- james_post(host = host, path = "data/upload", txt = txt, format = format)
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
get_tgt <- function(txt = "", host = "", session = "", ...) {

  url <- parse_url(host)

  if (is.empty(host)) {
    host <- get_host()
  }

  # no ind
  if (is.empty(txt) && is.empty(session)) {
    return(NULL)
  }

  # create target data on-the-fly
  if (!is.empty(txt)) {
    return(read_bds(txt, ...))
  }

  # download data from session
  url <- paste0(host, "/", session, "/rda")
  con <- curl(url = url, open = "rb")
  on.exit(close(con))
  load(file = con)
  return(.val)
}

is.empty <- function(x) nchar(x[1L]) == 0L || is.null(x)
