fn <- system.file("testdata", "client_tanner.json", package = "james")
fn_male <- system.file("testdata", "client_tanner_male.json", package = "james")

test_that("embed_tanner() renders for a male patient with pubertal data", {
  html <- embed_tanner(txt = fn_male)
  expect_type(html, "character")
  expect_length(html, 1L)
  expect_true(grepl("Plotly", html, fixed = TRUE))
  expect_true(grepl("Genital", html, fixed = TRUE))
  expect_true(grepl("Testis", html, fixed = TRUE))
  expect_false(grepl("Breast", html, fixed = TRUE))
})

test_that("embed_tanner() renders for a female patient with pubertal data", {
  html <- embed_tanner(txt = fn)
  expect_type(html, "character")
  expect_length(html, 1L)
  expect_true(grepl("Plotly", html, fixed = TRUE))
  expect_true(grepl("Breast", html, fixed = TRUE))
  expect_true(grepl("Menarche", html, fixed = TRUE))
})

test_that("embed_tanner() renders a reference-only frame when there is no data", {
  html <- embed_tanner(txt = "")
  expect_type(html, "character")
  expect_length(html, 1L)
  expect_true(grepl("Plotly", html, fixed = TRUE))
  # default sex when there is no target is male (Genital/Pubic hair/Testis)
  expect_true(grepl("Testis", html, fixed = TRUE))
})

test_that("build_tanner_patient() pivots xyz into one row per visit age", {
  tgt <- bdsreader::read_bds(fn, format = "3.1")
  patient <- build_tanner_patient(tgt)

  expect_true(all(c("age", "bre", "bre_sds", "phg", "phg_sds", "men", "men_sds") %in% names(patient)))
  expect_equal(nrow(patient), length(unique(tgt$xyz$age)))
  # menarche is stage-coded 1 (pre) / 2 (post), not a 0/1 boolean -- a
  # regression here would silently feed calculate_sds() a bad code and
  # produce -Inf/NaN instead of a plausible SDS
  expect_true(all(patient$men[!is.na(patient$men)] %in% c(1, 2)))
  expect_true(all(is.finite(patient$men_sds[!is.na(patient$men_sds)])))
})

test_that("build_tanner_patient() returns an all-NA stub when tgt is NULL", {
  patient <- build_tanner_patient(NULL)
  expect_equal(nrow(patient), 1L)
  sds_cols <- grep("_sds$", names(patient), value = TRUE)
  expect_true(all(vapply(patient[sds_cols], function(x) all(is.na(x)), logical(1))))
})

test_that("embed_tanner() picks the sex-appropriate stage types", {
  tgt <- bdsreader::read_bds(fn, format = "3.1")
  expect_equal(bdsreader::persondata(tgt)$sex[1], "female")

  html <- embed_tanner(txt = fn)
  expect_true(grepl("Breast", html, fixed = TRUE))
  expect_false(grepl("Genital", html, fixed = TRUE))
})
