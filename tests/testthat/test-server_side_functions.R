context("server-side functions")

# client3.json
fn  <- system.file("extdata", "allegrosultum", "client3.json", package = "jamestest")
js  <- jsonlite::toJSON(jsonlite::fromJSON(fn), auto_unbox = TRUE)

test_that("convert_bds_ind() on client3.json is silent",
           expect_silent(z <- convert_bds_ind(js)))
test_that("screen_curves() on client3.json is silent",
          expect_silent(y <- screen_curves(js)))
test_that("draw_chart() on client3.json is silent",
          expect_silent(v <- draw_chart(js)))

# problematic json file not_a_vector.json identified by Allegro Sultum - Feb 2020
fn  <- system.file("extdata", "test", "not_a_vector.json", package = "jamestest")
js  <- jsonlite::toJSON(jsonlite::fromJSON(fn), auto_unbox = TRUE)

test_that("convert_bds_ind() on not_a_vector.json has messages",
          expect_message(z <- convert_bds_ind(js)))
test_that("screen_curves() on not_a_vector.json has messages",
          expect_message(y <- screen_curves(js)))
test_that("draw_chart() on not_a_vector.json has messages",
          expect_message(v <- draw_chart(js)))

# problematic json file http400.json identified by Allegro Sultum - Feb 2020
fn  <- system.file("extdata", "test", "http400.json", package = "jamestest")
js  <- jsonlite::toJSON(jsonlite::fromJSON(fn), auto_unbox = TRUE)

test_that("convert_bds_ind() on http400.json has messages",
          expect_silent(z <- convert_bds_ind(js)))
test_that("screen_curves() on http400.json has messages",
          expect_silent(y <- screen_curves(js,
                                            host = "http://localhost:5656",
                                            path = "ocpu/library/james/R/convert_bds_ind")))
test_that("draw_chart() on http400.json has messages",
          expect_silent(v <- draw_chart(js)))

