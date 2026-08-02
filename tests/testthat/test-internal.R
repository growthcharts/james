test_that("is.empty() treats NA as empty instead of erroring", {
  # nchar(NA) is NA, not 0 -- an unguarded nchar(x[1L]) == 0L on NA
  # returns NA rather than TRUE/FALSE, which breaks every
  # `if (is.empty(...))` call site with "missing value where TRUE/FALSE
  # needed". OpenCPU parses an empty POST field (e.g. txt=) as NA, not
  # "", so this is the actual shape of "no value supplied" seen over
  # real HTTP, not just a defensive edge case.
  expect_true(james:::is.empty(NA))
  expect_true(james:::is.empty(NA_character_))
  expect_true(james:::is.empty(""))
  expect_true(james:::is.empty(NULL))
  expect_false(james:::is.empty("abc"))
})

test_that("get_tgt() with an OpenCPU-style NA txt/session returns NULL, not an error", {
  expect_null(james:::get_tgt(txt = NA, session = NA))
  expect_null(james:::get_tgt(txt = NA_character_, session = NA_character_))
})
