# return the (likely) base URL of the ocpu server
get_host <- function() {
  # where am I running?
  hostname <- system("hostname", intern = TRUE)
  switch(hostname,
    groeidiagrammen.nl = "https://groeidiagrammen.nl",
    james.groeidiagrammen.nl = "https://james.groeidiagrammen.nl",
    ijgz.eaglescience.nl = "https://ijgz.eaglescience.nl/modules/james",
    opa = "https://vps.stefvanbuuren.nl",
    "http://localhost"
  )
}

# returns url of uploaded data
get_loc <- function(txt, host, format) {
  resp <- upload_txt(txt, host = host, format = format)
  if (status_code(resp) != 201L) {
    message_for_status(resp,
      task = paste0(
        "upload data", "\n",
        content(resp, "text", encoding = "utf-8")
      )
    )
    return("")
  }
  headers(resp)$location
}

# returns session of uploaded data
get_session <- function(txt, host, format) {
  resp <- upload_txt(txt, host = host, format = format)
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
get_tgt <- function(txt = "", session = "", loc = "", ...) {

  # no ind
  if (is.empty(txt) && is.empty(session) && is.empty(loc)) {
    return(NULL)
  }

  # create ind on-the-fly
  if (!is.empty(txt)) {
    return(read_bds(txt, ...))
  }

  # construct url from session or loc
  if (!is.empty(session)) {
    url <- paste0("http://localhost/", session, "/rda")
  } else {
    # use oldstyle url for compatibility
    url <- paste0(loc, "R/.val/rda")
  }

  # download ind
  con <- curl(url = url, open = "rb")
  on.exit(close(con))
  load(file = con)
  .val
}

is.empty <- function(x) nchar(x[1L]) == 0L || is.null(x)
