initializer <- function(selector, individual, chartcode = "") {
  if (is.empty(chartcode)) return(NULL)

  parsed   <- parse_chartcode(chartcode)
  choices  <- parsed

  choices$chartcode <- chartcode
  choices$chartgrp <- initialize_chartgrp(parsed)
  choices$agegrp   <- initialize_agegrp(parsed)
  choices$side     <- initialize_side(parsed)
  choices$dnr      <- initialize_dnr(parsed,
                                     selector,
                                     individual,
                                     choices$chartgrp,
                                     choices$agegrp)
  choices$slider_list <- initialize_slider_list(choices$dnr)
  choices$period   <- initialize_period(individual,
                                        choices$dnr,
                                        choices$agegrp)
  choices$accordion <- initialize_accordion(individual)

  choices
}

initialize_chartgrp <- function(parsed) {
  switch(EXPR = tolower(parsed$population),
         nl = "nl2010",
         tu = "nl2010",
         ma = "nl2010",
         hs = "nl2010",
         pt = "preterm",
         whoblue = "who",
         whopink = "who",
         "")
}

initialize_agegrp <- function(parsed) {
  switch(EXPR = parsed$design,
         A = "0-15m",
         B = "0-4y",
         C = "1-21y",
         D = "0-21y",
         E = "0-4y",
         "")
}

initialize_side <- function(parsed) {
  side <- parsed$side
  if (side == "-hdc") side = "back"
  side
}

initialize_dnr <- function(parsed, selector, individual, chartgrp, agegrp) {
  # Determine dnr on chartcode if user initialized chartcode
  if (selector == "chartcode")
    return(switch(EXPR = chartgrp,
                  nl2010 = switch(EXPR = agegrp,
                                  "0-15m" = "smocc",
                                  "0-4y"  = "lollypop.term",
                                  "1-21y" = "terneuzen",
                                  "0-21y" = "terneuzen",
                                  "smocc"),
                  who    = switch(EXPR = agegrp,
                                  "0-15m" = "smocc",
                                  "0-4y"  = "lollypop.term",
                                  "1-21y" = "terneuzen",
                                  "0-21y" = "terneuzen",
                                  "smocc"),
                  preterm = switch(EXPR = agegrp,
                                   "0-15m" = "lollypop.preterm",
                                   "0-4y"  = "lollypop.preterm",
                                   "1-21y" = "terneuzen",
                                   "0-21y" = "terneuzen"),
                  "smocc"))
  # Determine dnr based on the uploaded data
  if (selector == "data") {
    last_age <- get_range(individual)[2L]
    dnr <- "smocc"
    if (!is.na(last_age)) {
      if (chartgrp %in% c("nl2010", "who")) {
        if (last_age > 2.0) dnr = "lollypop.term"
        if (last_age > 4.0) dnr = "terneuzen"
      }
      if (chartgrp %in% "preterm") {
        dnr <- "lollypop.preterm"
        if (last_age > 4.0) dnr = "terneuzen"
      }
    }
  }
  dnr
}

initialize_slider_list <- function(dnr) {
  switch(dnr,
         smocc = "0_2",
         lollypop.preterm = "0_4",
         lollypop.term = "0_4",
         terneuzen = "0_29",
         "0_2")
}

initialize_period <- function(individual, dnr, agegrp) {
  # period 1: first breakpoint equal to larger than last observed age
  brk <- get_breakpoints(dnr)
  last_age <- get_range(individual)[2L]
  period1 <- brk$label[last_age <= brk$age][1L]
  if (is.na(period1)) period1 <- "0w"

  # period 2: last breakpoint on the requested chart
  period2 <- switch(EXPR = agegrp,
                    "0-15m" = "14m",
                    "0-4y"  = "45m",
                    "1-21y" = "18y",
                    "0-21y" = "18y",
                    "14m")

  c(period1, period2)
}

initialize_accordion <- function(individual) {
  # check for hgt, wgt and hdc
  groei <- any(!is.na(slot(individual, "hgt")@y),
               !is.na(slot(individual, "wgt")@y),
               !is.na(slot(individual, "hdc")@y))
  # check for dsc
  ontwikkeling <- any(!is.na(slot(individual, "dsc")@y))

  if (groei & ontwikkeling) return("all")
  if (groei) return("groei")
  if (ontwikkeling) return("ontwikkeling")
  return("all")
}
