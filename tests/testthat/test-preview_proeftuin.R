# T_1017.json's weight series ends with a dateless measurement
# ({"value": 4000}, no "date"), which surfaces as a row with NA age in
# tgt$xyz. preview_screeners() truncates the time series per occasion via
# tgt$xyz$age <= age; before the fix, NA <= age evaluated to NA (not
# FALSE), so that row was kept in every occasion's cut regardless of
# yname, ultimately crashing growthscreener's downstream
# `if (any(repeated))` check.
fn <- system.file(
  "extdata",
  "bds_v3.0",
  "terneuzen",
  "T_1017.json",
  package = "jamesdemodata"
)
txt <- paste(readLines(fn), collapse = "\n")

test_that("preview_screeners handles a dateless measurement for another yname", {
  expect_no_error(
    res <- preview_screeners(txt = txt, format = "3.0", ynames = c("hgt", "wgt"))
  )
  expect_gt(nrow(res), 0)
  expect_false(anyNA(res$Code))
})
