# JAMES - A program to monitor and interpret child growth and development.
# Copyright (C) 2022 Stef van Buuren (stef.vanbuuren@tno.nl)
# Arjan Huizing (arjan.huizing@tno.nl)
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

#' Selects the growth chart
#'
#' This function controls the behaviour for selecting a specific growth
#' chart based on a combination of individual data and user settings.
#' The default behaviour select preterm chart if gestational age is lower
#' or equal to 36 weeks, and determines the age group by the
#' maximum age found in the data.
#' @aliases select_chart
#' @param target A list with elements `psn` (persondata) and `xyz` (timedata).
#' @param chartgrp  The chart group: `'nl2010'`, `'preterm'`, `'who'`, `'gsed1'`,
#' `'gsed1pt'` or `character(0)`
#' @param agegrp Either `'0-15m'`, `'0-4y'`, `'1-21y'`,
#'   `'0-21y'` or `'0-4ya'`. Age group `'0-4ya'`
#'   provides the 0-4 chart with weight for age (design E).
#' @param sex Either `'male'` or `'female'`
#' @param etn Either `'netherlands'`, `'turkish'`,
#'   `'moroccan'` or `'hindustani'`
#' @param ga  Gestational age (in completed weeks)
#' @param side Either `'front'`, `'back'`, `'-hdc'` or
#'   `'both'`
#' @param language Language: `'dutch'` or `'english'` (not
#'   used)
#' @return A list with elements `chartgrp`, `chartcode`
#' and `ga`
#' @seealso [chartcatalog::create_chartcode()]
#' @export
select_chart <- function(target = NULL,
                         chartgrp = NULL,
                         agegrp = NULL,
                         sex = NULL,
                         etn = NULL,
                         ga = NULL,
                         side = NULL,
                         language = "dutch") {



  # choose defaults depending on individual
  if (!is.null(target)) {
    if (is.null(side)) side <- select_side(target)
    if (is.null(ga)) ga <- select_ga(target)
    if (is.null(chartgrp)) chartgrp <- select_chartgrp(target, side, ga)
    if (is.null(agegrp)) agegrp <- select_agegrp(target)
    if (is.null(sex)) sex <- select_sex(target)
    # NOTE: Dutch Child Health Care always starts by comparing to Dutch references
    # irrespective of ethnic background of child
    if (is.null(etn)) etn <- "nl"
  }

  # now get the chartcode
  chartcode <- create_chartcode(
    chartgrp = chartgrp, sex = sex, agegrp = agegrp, side = side,
    week = ga, etn = etn, language = language, version = ""
  )

  return(list(
    chartgrp = chartgrp,
    chartcode = chartcode,
    ga = ga
  ))
}

select_side <- function(tgt) {
  yname <- timedata(tgt)[["yname"]]
  if (any(c("hgt", "wgt", "hdc") %in% yname)) {
    return("hgt")
  }
  if (any(c("dsc") %in% yname)) {
    return("dsc")
  }
  "hgt"
}

select_ga <- function(tgt) {
  ga <- persondata(tgt)$ga
  if (is.na(ga)) {
    return(NA)
  }
  if (ga < 25) {
    return(25)
  }
  ga
}

select_chartgrp <- function(tgt, side, ga) {
  if (is.na(ga)) {
    return(ifelse(side == "dsc", "gsed1", "nl2010"))
  }
  if (side == "dsc") {
    return(ifelse(ga <= 36, "gsed1pt", "gsed1"))
  }
  ifelse(ga <= 36, "preterm", "nl2010")
}


select_agegrp <- function(tgt) {
  # automatic agegrp setting based on last age
  time <- timedata(tgt)

  # get maximum age
  x <- time$age
  max_age <- ifelse(sum(!is.na(x)), max(x, na.rm = TRUE), NA_real_)

  # assign default age group
  if (is.na(max_age)) {
    return("0-15m")
  }
  agegrp <- "0-15m"
  if (max_age > 1.25 & max_age <= 4.0) agegrp <- "0-4y"
  if (max_age > 4.0) agegrp <- "1-21y"
  agegrp
}


select_sex <- function(tgt) {
  sex <- persondata(tgt)$sex
  if (sex %in% c("male", "female")) {
    return(sex)
  }
  "male"
}

