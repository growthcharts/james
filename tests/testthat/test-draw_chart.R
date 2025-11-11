# curvematching problem
# Error in eval(predvars, data, env) : object 'hgt_z_0' not found

# the following code gave: Error in eval(predvars, data, env) : object 'hgt_z_0' not found
# chartplotter 0.32.0 resolved this error
library(jamesclient)
fn <- path.expand("~/Package/james/notes/Voorbeelddossier.txt")
js <- read_json_js(fn)
test_that("Matches do not condition on yname when there are no brokenstick estimates", {
  expect_silent(james::draw_chart(
    txt = js,
    chartcode = c(""),
    selector = c("derive"),
    chartgrp = c("preterm"),
    agegrp = c("0-15m"),
    sex = c("female"),
    etn = c("nl"),
    ga = 27L,
    side = c("hgt"),
    curve_interpolation = TRUE,
    quiet = TRUE,
    dnr = c("0-2"),
    lo = "4w",
    hi = c("14m"),
    nmatch = 10L,
    exact_sex = TRUE,
    exact_ga = FALSE,
    show_future = FALSE,
    show_realized = FALSE,
    draw_grob = FALSE
  ))
})
