library(httr)

library(jamesclient)

# client3.json
fn <- system.file("extdata", "allegrosultum", "client3.json", package = "jamesdemodata")
js <- jsonlite::toJSON(jsonlite::fromJSON(fn), auto_unbox = TRUE)
host <- "http://localhost"

if (jamesclient::valid_url(host)) {
  path <- "ocpu/library/james/R/upload_data"
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

  path <- "ocpu/library/james/R/screen_growth"
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
}

# Allegro Sultum 1 sept 2020
laura_dev <- system.file("testdata", "Laura_S_dev.json", package = "james")
expect_warning(screen_growth(txt = laura_dev))

laura_dev_2 <- system.file("testdata", "Laura_S_dev_2.json", package = "james")
expect_warning(screen_growth(txt = laura_dev_2))
