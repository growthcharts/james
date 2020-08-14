context("server-side functions")

# client3.json
fn  <- system.file("extdata", "allegrosultum", "client3.json", package = "jamestest")
js  <- jsonlite::toJSON(jsonlite::fromJSON(fn), auto_unbox = TRUE)

test_that("convert_bds_ind() on client3.json is silent",
           expect_silent(convert_bds_ind(js)))

# hack to evade ssl verification error: certificate has expired
# remove hack after server certificate is repaired
# httr::set_config(config(ssl_verifypeer = 0L))

test_that("screen_curves() on client3.json is silent",
          expect_silent(screen_curves(js)))

test_that("draw_chart() on client3.json is silent",
          expect_silent(draw_chart(js, draw_grob = FALSE, quiet = TRUE)))

# problematic json file not_a_vector.json identified by Allegro Sultum - Feb 2020
fn  <- system.file("extdata", "test", "not_a_vector.json", package = "jamestest")
js  <- jsonlite::toJSON(jsonlite::fromJSON(fn), auto_unbox = TRUE)

test_that("convert_bds_ind() on not_a_vector.json has messages",
          expect_message(convert_bds_ind(js)))
test_that("screen_curves() on not_a_vector.json has messages",
          expect_message(screen_curves(js)))
test_that("draw_chart() on not_a_vector.json has messages",
          expect_message(draw_chart(js)))

# problematic json file http400.json identified by Allegro Sultum - Feb 2020
fn  <- system.file("extdata", "test", "http400.json", package = "jamestest")
js  <- jsonlite::toJSON(jsonlite::fromJSON(fn), auto_unbox = TRUE)

test_that("convert_bds_ind() on http400.json has messages",
          expect_silent(convert_bds_ind(js)))
#test_that("screen_curves() on http400.json has messages",
#          expect_silent(y <- screen_curves(js,
#                                            host = "http://localhost:5656",
#                                            path = "ocpu/library/james/R/convert_bds_ind")))
test_that("draw_chart() on http400.json has messages",
          expect_silent(draw_chart(js, quiet = TRUE)))

