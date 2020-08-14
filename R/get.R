# return the (likely) base URL of the ocpu server
get_host <- function() {
  # where am I running?
  hostname <- system("hostname", intern = TRUE)
  switch(hostname,
         groeidiagrammen = "https://groeidiagrammen.nl",
         opa = "https://vps.stefvanbuuren.nl",
         "http://localhost")
}

# returns url of uploaded data
get_loc <- function(txt, host, schema) {
  tryCatch(expr = {
    resp <- upload_txt(txt, host = host, schema = schema)
    get_url(resp, "location")
  },
  error = function(cnd) paste("Cannot upload", txt)
  )
}

# returns object of S4 class individual
get_ind <- function(txt = NULL, loc = NULL) {

  # no ind
  if (!length(txt) && !length(loc)) return(NULL)

  # create ind on-the-fly
  if (length(txt)) return(convert_bds_individual(txt))

  # download ind
  con <- curl(url = paste0(loc, "R/.val/rda"), open = "rb")
  on.exit(close(con))
  load(file = con)
  .val
}
