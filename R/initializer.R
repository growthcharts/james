# JAMES - A program to monitor and interpret child growth and development.
# Copyright (C) 2022 Stef van Buuren (stef.vanbuuren@tno.nl)
# Arjan Huizing (arjan.huizing@tno.nl)
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

initializer <- function(selector, target, chartcode = "") {

  # Fall back to NJAH if there is a problem
  if (is.empty(chartcode) || is.null(target)) {
    chartcode <- "NJAH"
    selector <- "chartcode"
  }

  parsed <- parse_chartcode(chartcode)
  choices <- parsed

  choices$chartcode <- chartcode
  choices$chartgrp <- initialize_chartgrp(parsed)
  choices$agegrp <- initialize_agegrp(parsed)
  choices$side <- initialize_side(parsed)
  choices$dnr <- initialize_dnr(
    parsed,
    selector,
    target,
    choices$chartgrp,
    choices$agegrp
  )
  choices$slider_list <- initialize_slider_list(choices$dnr)
  choices$period <- initialize_period(
    target,
    choices$dnr,
    choices$agegrp
  )
  choices$accordion <- initialize_accordion(target)
  choices$week <- target$psn$ga

  choices
}

initialize_chartgrp <- function(parsed) {
  switch(EXPR = tolower(parsed$population),
         nl = "nl2010",
         tu = "nl2010",
         ma = "nl2010",
         hs = "nl2010",
         ds = "nl2010",
         pt = "preterm",
         whoblue = "who",
         whopink = "who",
         ""
  )
}

initialize_agegrp <- function(parsed) {
  switch(EXPR = parsed$design,
         A = "0-15m",
         B = "0-4y",
         C = "1-21y",
         D = "0-21y",
         E = "0-4y",
         ""
  )
}

initialize_side <- function(parsed) {
  side <- parsed$side
  if (side == "-hdc") side <- "back"
  side
}

initialize_dnr <- function(parsed, selector, target, chartgrp, agegrp) {
  # default if nothing is set
  dnr <- "0-2"

  # Determine dnr on chartcode if user initialized chartcode
  if (selector == "chartcode") {
    return(switch(EXPR = chartgrp,
                  nl2010 = switch(EXPR = agegrp,
                                  "0-15m" = "0-2",
                                  "0-4y"  = "2-4",
                                  "1-21y" = "4-18",
                                  "0-21y" = "4-18",
                                  "0-2"
                  ),
                  who = switch(EXPR = agegrp,
                               "0-15m" = "0-2",
                               "0-4y"  = "2-4",
                               "1-21y" = "4-18",
                               "0-21y" = "4-18",
                               "0-2"
                  ),
                  preterm = switch(EXPR = agegrp,
                                   "0-15m" = "0-2",
                                   "0-4y"  = "2-4",
                                   "1-21y" = "4-18",
                                   "0-21y" = "4-18"
                  ),
                  "0-2"
    ))
  }
  # Determine dnr based on the uploaded data
  if (selector == "data") {
    # get maximum age
    max_age <- get_max_age(target)
    dnr <- "0-2"
    if (!is.na(max_age)) {
      if (max_age > 2.0) dnr <- "2-4"
      if (max_age > 4.0) dnr <- "4-18"
    }
  }
  dnr
}

initialize_slider_list <- function(dnr) {
  switch(
    dnr,
    "0-2"  = "0_2",
    "2-4"  = "0_4",
    "4-18" = "0_29",
    smocc = "0_2",
    lollypop = "0_4",
    terneuzen = "0_29",
    pops = "0_19",
    "0_2"
  )
}

initialize_period <- function(target, dnr, agegrp) {
  # period 1: first breakpoint equal to larger than last observed age
  brk <- get_breakpoints(dnr)

  # get maximum age from the data
  max_age <- get_max_age(target)

  # period 1
  period1 <- NA_real_
  if (!is.na(max_age)) period1 <- brk$label[max_age <= brk$age][1L]
  if (is.na(period1)) period1 <- "0w"

  # period 2: last breakpoint on the requested chart
  period2 <- switch(
    EXPR = agegrp,
    "0-15m" = "14m",
    "0-4y"  = "45m",
    "1-21y" = "18y",
    "0-21y" = "18y",
    "14m"
  )

  c(period1, period2)
}

initialize_accordion <- function(target) {
  # check for hgt, wgt and hdc
  yname <- "hgt"
  if (!is.null(target)) {
    yname <- timedata(target)[["yname"]]
  }
  has_growth <- any(c("hgt", "wgt", "hdc") %in% yname)
  has_dev <- any("dsc" %in% yname)

  if (has_growth && has_dev) {
    return("all")
  }
  if (has_growth) {
    return("groei")
  }
  if (has_dev) {
    return("ontwikkeling")
  }
  return("all")
}
