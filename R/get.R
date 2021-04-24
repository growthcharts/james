# return the (likely) base URL of the ocpu server
get_host <- function() {
  # where am I running?
  hostname <- system("hostname", intern = TRUE)
  switch(hostname,
    groeidiagrammen.nl = "https://groeidiagrammen.nl",
    opa = "https://vps.stefvanbuuren.nl",
    "http://localhost"
  )
}

# returns url of uploaded data
get_loc <- function(txt, host, schema) {
  resp <- upload_txt(txt, host = host, schema = schema)
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

# returns targetl or NULL
get_tgt <- function(txt = "", loc = "", schema = "bds_schema_str.json") {

  # no ind
  if (is.empty(txt) && is.empty(loc)) {
    return(NULL)
  }

  # create ind on-the-fly
  if (!is.empty(txt)) {
    return(read_bds(txt, schema = schema))
  }

  # download ind
  con <- curl(url = paste0(loc, "R/.val/rda"), open = "rb")
  on.exit(close(con))
  load(file = con)
  .val
}

is.empty <- function(x) nchar(x[1L]) == 0L || is.null(x)
