context("screen_curves")
library(httr)

library(jamesclient)

# define testing host
# host <- "https://groeidiagrammen.nl"
# host <- "https://vps.stefvanbuuren.nl"
host <- "http://localhost"

# client3.json
fn <- system.file("extdata", "allegrosultum", "client3.json", package = "jamestest")
# fn <- system.file("testdata", "Laura_S_dev.json", package = "james")
js <- jsonlite::toJSON(jsonlite::fromJSON(fn), auto_unbox = TRUE)

path <- "ocpu/library/james/R/fetch_loc"
url <- modify_url(url = host, path = path)
resp <- POST(
  url = url,
  body = list(txt = js),
  encode = "json",
  add_headers(Accept = "plain/text")
)
test_that(
  "file client3.json uploads to server",
  expect_equal(status_code(resp), 201)
)

path <- "ocpu/library/james/R/screen_curves"
url <- modify_url(url = host, path = path)
resp <- POST(
  url = url,
  body = list(txt = js),
  encode = "json",
  add_headers(Accept = "plain/text")
)
test_that(
  "file client3.json is screened",
  expect_equal(status_code(resp), 201)
)


# Allegro Sultum 1 sept 2020
laura_dev <- system.file("testdata", "Laura_S_dev.json", package = "james")
test_that(
  "file Laura_S_dev.json (only development) warns",
  expect_warning(screen_curves(txt = laura_dev))
)

laura_dev_2 <- system.file("testdata", "Laura_S_dev_2.json", package = "james")
test_that(
  "file Laura_S_dev_2.json (only development) warns",
  expect_warning(screen_curves(txt = laura_dev_2))
)
