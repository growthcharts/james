library(httr)

fn  <- system.file("extdata", "allegrosultum", "client3.json", package = "jamestest")
js  <- jsonlite::toJSON(jsonlite::fromJSON(fn), auto_unbox = TRUE)

# 2 problematic json files identified by Allegro Sultum - Feb 2020
#fn  <- system.file("extdata", "test", "not_a_vector.json", package = "jamestest")
#js  <- jsonlite::toJSON(jsonlite::fromJSON(fn), auto_unbox = TRUE)

#host <- "https://groeidiagrammen.nl"
#path <- "ocpu/library/james/R/convert_bds_ind"

host <- "http://localhost:5656"
path <- "ocpu/library/james/R/convert_bds_ind"

url <- modify_url(url = host, path = path)
resp <- POST(url = url,
             body = list(txt = js),
             encode = "json",
             add_headers(Accept = "plain/text"))

browseURL(paste0(headers(resp)$location, "R/.val"))
#browseURL(paste0(headers(resp)$location, "R/convert_bds_ind"))
#browseURL(paste0(headers(resp)$location, "messages"))

test_that("file uploads to server",
          expect_equal(status_code(resp), 201))


# z <- convert_bds_ind(js)
# y <- screen_curves(js)
# v <- draw_chart(js)
#
# test_that("NOT A VECTOR error is solved",
#           expect_silent(convert_bds_individual(js)))
