# test-request_site.R
skip("Integration tests skipped — require running server.")

laura <- system.file("testdata", "Laura_S.json", package = "james")
laura_gro <- system.file("testdata", "Laura_S_gro.json", package = "james")
laura_dev <- system.file("testdata", "Laura_S_dev.json", package = "james")
laura_dev_2 <- system.file("testdata", "Laura_S_dev_2.json", package = "james")

kevin <- system.file("testdata", "Kevin_S.json", package = "james")
kevin_gro <- system.file("testdata", "Kevin_S_gro.json", package = "james")
kevin_dev <- system.file("testdata", "Kevin_S_dev.json", package = "james")

host <- "http://localhost:8080"


#site_laura_gro <- request_site(laura_gro, sitehost = host)
#site_laura_dev <- request_site(laura_dev, sitehost = host)
#site_laura_dev_2 <- request_site(laura_dev_2, sitehost = host)
# site_kevin_gro <- request_site(kevin_gro, sitehost = host)
# site_kevin_dev <- request_site(kevin_dev, sitehost = host)

# browseURL(site_laura)

## NESTED UPLOADS FAIL ON LOCALHOST
## The site/request/json endpoint does not work with nested uploads on localhost.
## Here's a test and a solution

library(httr)
library(jamesclient)

# get JSON data from file
fn <- system.file("examples/maria.json", package = "bdsreader")
js <- read_json_js(fn)

# test_that("request_site WORKS with nested upload for proper domains", {
#   host <- "https://james.groeidiagrammen.nl"
#   r <- james_post(
#     host = host,
#     path = "/site/request/json",
#     txt = js,
#     sitehost = host
#   )
#   expect_equal(status_code(r), 201L)
#   site <- r$parsed
#   # browseURL(site)
# })

test_that("request_site FAILS with nested upload on localhost", {
  host <- "http://localhost:8080"
  r <- james_post(
    host = host,
    path = "/site/request/json",
    txt = js,
    sitehost = host
  )
  expect_equal(status_code(r), 201L)
})

test_that("request_site can be replaced by data/upload to localhost", {
  host <- "http://localhost:8080"
  r <- james_post(host = host, path = "data/upload", txt = js)
  expect_equal(status_code(r), 201L)
  session <- get_url(r, "session")
  site <- modify_url(host, path = "site", query = list(session = session))
  # browseURL(site)
})

# test_that("site creation by data/upload also works on proper domains", {
#   host <- "https://james.groeidiagrammen.nl"
#   r <- james_post(host = host, path = "data/upload", txt = js)
#   expect_equal(status_code(r), 201L)
#   session <- get_url(r, "session")
#   site <- modify_url(host, path = "site", query = list(session = session))
#   # browseURL(site)
# })

# test_that("request_site works in dual-mode", {
#   js <- "{\"Format\":\"3.0\",\"reference\":\"Test\"}"

#   local_host <- "http://localhost:8080"
#   prod_host <- "https://james.groeidiagrammen.nl"

#   # Local session URL begins with localhost
#   url_loc <- request_site(txt = js, sitehost = local_host)
#   expect_true(grepl("^http://localhost:8080/site\\?session=", url_loc))

#   # Production URL begins with https://james...
#   url_prod <- request_site(txt = js, sitehost = prod_host)
#   expect_true(grepl(
#     "^https://james.groeidiagrammen.nl/site\\?session=",
#     url_prod
#   ))
# })
