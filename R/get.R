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
  tryCatch(error = function(cnd) stop("Cannot upload"),
           {
             resp <- upload_txt(txt, host = host, schema = schema)
             get_url(resp, "location")
           }
  )
}

# returns object of S4 class individual
get_ind <- function(loc = NULL) {
  if (is.null(loc)) return(NULL)
  con <- curl(paste0(loc, "R/.val/rda"))
  on.exit(close(con))
  load(file = con)
  .val
}
