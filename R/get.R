get_host <- function() {
  # where am I running?
  hostname <- system("hostname", intern = TRUE)
  switch(hostname,
         groeidiagrammen = "https://groeidiagrammen.nl",
         opa = "https://vps.stefvanbuuren.nl",
         "http://localhost")
}

get_loc <- function(txt, host, schema) {
  tryCatch(error = function(cnd) stop("Cannot upload"),
           {
             resp <- upload_txt(txt, host = host, schema = schema)
             get_url(resp, "location")
           }
  )
}
