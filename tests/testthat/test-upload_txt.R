context("upload data")

library(httr)

fn  <- system.file("extdata", "allegrosultum", "client3.json", package = "jamestest")
js  <- jsonlite::toJSON(jsonlite::fromJSON(fn), auto_unbox = TRUE)
url <- "https://groeidiagrammen.nl/ocpu/library/james/testdata/client3.json"

host1 <- "https://groeidiagrammen.nl"
host2 <- "https://vps.stefvanbuuren.nl"
host3 <- "http://localhost"

test_that("client3.json uploads to host1",
          expect_equal(status_code(upload_txt(fn, host = host1)), 201))
test_that("JSON string uploads to host1",
          expect_equal(status_code(upload_txt(js, host = host1)), 201))
test_that("JSON file at URL uploads to host1",
          expect_equal(status_code(upload_txt(url, host = host1)), 201))

test_that("client3.json uploads to host2",
          expect_equal(status_code(upload_txt(fn, host = host2)), 201))
test_that("JSON string uploads to host2",
          expect_equal(status_code(upload_txt(js, host = host2)), 201))
test_that("JSON file at URL uploads to host2",
          expect_equal(status_code(upload_txt(url, host = host2)), 201))

test_that("client3.json uploads to host3",
          expect_equal(status_code(upload_txt(fn, host = host3)), 201))
test_that("JSON string uploads to host3",
          expect_equal(status_code(upload_txt(js, host = host3)), 201))
test_that("JSON file at URL uploads to host3",
          expect_equal(status_code(upload_txt(url, host = host3)), 201))


jtf <- system.file("extdata", "test", paste0("test", 1:23, ".json"), package = "jamestest")

test_that("test2.json (missing referentie) PASSES",
          expect_equal(status_code(upload_txt(jtf[2], host = host3)), 201))

test_that("test3.json (missing OrganisatieCode) PASSES",
          expect_equal(status_code(upload_txt(jtf[3], host = host3)), 201))

test_that("test4.json (wrong type) PASSES",
          expect_equal(status_code(upload_txt(jtf[4], host = host3)), 201))

test_that("test5.json (missing ClientGegevens) PASSES",
          expect_equal(status_code(upload_txt(jtf[5], host = host3)), 201))

test_that("test6.json (Missing ContactMomenten) PASSES",
          expect_equal(status_code(upload_txt(jtf[6], host = host3)), 201))

test_that("test7.json (Missing Referentie & OrganisatieCode) PASSES",
          expect_equal(status_code(upload_txt(jtf[7], host = host3)), 201))

test_that("test8.json (Invalid OrganisatieCode) ERROR 400",
          expect_equal(status_code(upload_txt(jtf[8], host = host3)), 400L))

test_that("test9.json (Bdsnummer 19 missing) PASSES",
          expect_equal(status_code(upload_txt(jtf[9], host = host3)), 201))

test_that("test10.json (Bdsnummer 20 missing) PASSES",
          expect_equal(status_code(upload_txt(jtf[10], host = host3)), 201))

test_that("test11.json (Bdsnummer 82 missing) PASSES",
          expect_equal(status_code(upload_txt(jtf[11], host = host3)), 201L))

test_that("test12.json (Bdsnummer 91 missing) PASSES",
          expect_equal(status_code(upload_txt(jtf[12], host = host3)), 201L))

test_that("test13.json (Bdsnummer 110 missing) PASSES",
          expect_equal(status_code(upload_txt(jtf[13], host = host3)), 201L))

test_that("test14.json (Empty file) ERROR 400",
          expect_equal(status_code(upload_txt(jtf[14], host = host3)), 400L))

test_that("test15.json (Bdsnummer 19 numeric) PASSES with message",
          expect_message(upload_txt(jtf[15], host = host3),
                         '[{"bdsnummer":19,"description":"Sex of child","expected":"one of: 0, 1, 2, 3","supplied":"2","supplied_type":"numeric"},{"bdsnummer":62,"description":"Caretaker relation","expected":"one of: 01, 02, 03, 04, 05, 06, 07, 08, 98","supplied":"1","supplied_type":"numeric"}]'))

test_that("test16.json (Bdsnummer 20 numeric) PASSES",
          expect_equal(status_code(upload_txt(jtf[16], host = host3)), 201L))

test_that("test17.json (Bdsnummer 82 numeric) PASSES",
          expect_equal(status_code(upload_txt(jtf[17], host = host3)), 201L))

test_that("test18.json (Bdsnummer 91 numeric) FAILS",
          expect_message(upload_txt(jtf[18], host = host3),
                         '[{"bdsnummer":91,"description":"Smoking during pregnancy","expected":"one of: 1, 2, 99","supplied":"1","supplied_type":"numeric"}]'))

test_that("test19.json (Bdsnummer 110 numeric) PASSES",
          expect_equal(status_code(upload_txt(jtf[19], host = host3)), 201L))

test_that("test20.json (missing Groepen) PASSES",
          expect_equal(status_code(upload_txt(jtf[20], host = host3)), 201L))

test_that("test21.json (minimal data) PASSES",
          expect_equal(status_code(upload_txt(jtf[21], host = host3)), 201L))

test_that("test22.json (range checking) PASSES",
          expect_equal(status_code(upload_txt(jtf[22], host = host3)), 201L))

test_that("test23.json (multiple messages) PASSES",
          expect_message(upload_txt(jtf[23], host = host3),
                         '[{"bdsnummer":91,"description":"Smoking during pregnancy","expected":"one of: 1, 2, 99","supplied":"1","supplied_type":"numeric"}]'))


fn  <- system.file("extdata", "smocc", "Laura_S.json", package = "jamestest")
js  <- jsonlite::toJSON(jsonlite::fromJSON(fn), auto_unbox = TRUE)

test_that("Laura_S.json file uploads",
          expect_equal(status_code(upload_txt(fn, host = host3)), 201))

test_that("Laura_S js string uploads",
          expect_equal(status_code(upload_txt(js, host = host3)), 201))

