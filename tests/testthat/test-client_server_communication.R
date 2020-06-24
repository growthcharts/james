context("client-server communication")
library(httr)

# hack to evade ssl verification error: certificate has expired
# remove hack after server certificate is repaired
# httr::set_config(config(ssl_verifypeer = 0L))

# define testing host
host <- "https://groeidiagrammen.nl"
# host <- "https://vps.stefvanbuuren.nl"
#host <- "http://localhost:5656"

# client3.json
fn  <- system.file("extdata", "allegrosultum", "client3.json", package = "jamestest")
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

path <- "ocpu/library/james/R/draw_chart"
url <- modify_url(url = host, path = path)
resp <- POST(url = url,
             body = list(txt = js),
             encode = "json",
             add_headers(Accept = "plain/text"))
test_that("file client3.json is drawn",
          expect_equal(status_code(resp), 201))


# problematic json file not_a_vector.json identified by Allegro Sultum - Feb 2020
fn  <- system.file("extdata", "test", "not_a_vector.json", package = "jamestest")
js  <- jsonlite::toJSON(jsonlite::fromJSON(fn), auto_unbox = TRUE)

path <- "ocpu/library/james/R/convert_bds_ind"
url <- modify_url(url = host, path = path)
resp <- POST(url = url,
             body = list(txt = js),
             encode = "json",
             add_headers(Accept = "plain/text"))
test_that("file not_a_vector.json uploads to server",
          expect_equal(status_code(resp), 201))

path <- "ocpu/library/james/R/screen_curves"
url <- modify_url(url = host, path = path)
resp <- POST(url = url,
             body = list(txt = js),
             encode = "json",
             add_headers(Accept = "plain/text"))
test_that("file not_a_vector.json is screened",
          expect_equal(status_code(resp), 201))

path <- "ocpu/library/james/R/draw_chart"
url <- modify_url(url = host, path = path)
resp <- POST(url = url,
             body = list(txt = js),
             encode = "json",
             add_headers(Accept = "plain/text"))
test_that("file not_a_vector.json is drawn",
          expect_equal(status_code(resp), 201))


# problematic json file http400.json identified by Allegro Sultum - Feb 2020
fn  <- system.file("extdata", "test", "http400.json", package = "jamestest")
js  <- jsonlite::toJSON(jsonlite::fromJSON(fn), auto_unbox = TRUE)

path <- "ocpu/library/james/R/convert_bds_ind"
url <- modify_url(url = host, path = path)
resp <- POST(url = url,
             body = list(txt = js),
             encode = "json",
             add_headers(Accept = "plain/text"))
test_that("file http400.json uploads to server",
          expect_equal(status_code(resp), 201))

path <- "ocpu/library/james/R/screen_curves"
url <- modify_url(url = host, path = path)
resp <- POST(url = url,
             body = list(txt = js),
             encode = "json",
             add_headers(Accept = "plain/text"))
test_that("file http400.json is screened",
          expect_equal(status_code(resp), 201))

path <- "ocpu/library/james/R/draw_chart"
url <- modify_url(url = host, path = path)
resp <- POST(url = url,
             body = list(txt = js),
             encode = "json",
             add_headers(Accept = "plain/text"))
test_that("file http400.json is drawn",
          expect_equal(status_code(resp), 201))


# browseURL(paste0(headers(resp)$location, "R/.val"))
# browseURL(paste0(headers(resp)$location, "R/convert_bds_ind"))
# browseURL(paste0(headers(resp)$location, "messages"))
