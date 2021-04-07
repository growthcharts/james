#' Selects the growth chart
#'
#' This function controls the behavior for selecting a specific growth
#' chart based on a combination of individual data and user settings.
#' The default behavior select preterm chart if gestational age is lower
#' or equal to 36 weeks, and determines the age group by the
#' maximum age found in the data.
#' @aliases select_chart
#' @param target A tibble with a `person` attribute, or `NULL`.
#' @param chartgrp  The chart group: `'nl2010'`, `'preterm'`, `'who'`
#' or `character(0)`
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
#' @examples
#' # data("installed.cabinets", package = "jamestest")
#' # ind <- installed.cabinets[[3]][[1]]
#' # select_chart(tgt)
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
    if (is.null(agegrp)) agegrp <- select_agegrp(target)
    if (is.null(chartgrp)) chartgrp <- select_chartgrp(target)
    if (is.null(ga)) ga <- select_ga(target)
    if (is.null(sex)) sex <- select_sex(target)
    if (is.null(etn)) etn <- "nl"
    if (is.null(side)) side <- select_side(target)
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

select_chartgrp <- function(tgt) {
  # automatic chartgrp setting based on ga
  ga <- persondata(tgt)$ga
  if (is.na(ga)) {
    return("nl2010")
  }
  ifelse(ga <= 36, "preterm", "nl2010")
}

select_agegrp <- function(tgt) {
  # automatic agegrp setting based on last age

  # get maximum age
  x <- tgt$age
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

select_ga <- function(tgt) {
  ga <- persondata(tgt)$ga
  if (is.na(ga)) {
    return(32)
  }
  if (ga < 25) {
    return(25)
  }
  ga
}

select_sex <- function(tgt) {
  sex <- persondata(tgt)$sex
  if (sex %in% c("male", "female")) {
    return(sex)
  }
  "male"
}

select_side <- function(tgt) {
  yname <- tgt$yname
  if (any(c("hgt", "wgt", "hdc") %in% yname)) {
    return("hgt")
  }
  if (any(c("dsc") %in% yname)) {
    return("dsc")
  }
  "hgt"
}
