context("screen_curves")
library(httr)

library(jamesclient)

# define testing host
# host <- "https://groeidiagrammen.nl"
# host <- "https://vps.stefvanbuuren.nl"
host <- "http://localhost"

# client3.json
fn  <- system.file("extdata", "allegrosultum", "client3.json", package = "jamestest")
fn <- system.file("extdata", "smocc", "Laura_S.json", package = "jamestest")
js  <- jsonlite::toJSON(jsonlite::fromJSON(fn), auto_unbox = TRUE)

path <- "ocpu/library/james/R/convert_bds_ind"
url <- modify_url(url = host, path = path)
resp <- POST(url = url,
             body = list(txt = js),
             encode = "json",
             add_headers(Accept = "plain/text"))
test_that("file client3.json uploads to server",
          expect_equal(status_code(resp), 201))

path <- "ocpu/library/james/R/screen_curves"
url <- modify_url(url = host, path = path)
resp <- POST(url = url,
             body = list(txt = js),
             encode = "json",
             add_headers(Accept = "plain/text"))
test_that("file client3.json is screened",
          expect_equal(status_code(resp), 201))

