#' Selects the growth chart
#'
#' This function controls the behavior for selecting a specific growth
#' chart based on a combination of individual data and user settings.
#' The default behavior select preterm chart if gestational age is lower
#' or equal to 36 weeks, and determines the age group by the
#' maximum age found in the data.
#' @aliases select_chart
#' @param ind An S4 object of class \code{individual} containing
#'   data of the individual, or \code{NULL}.
#' @param chartgrp  The chart group: \code{'nl2010'}, \code{'preterm'}, \code{'who'}
#' or \code{character(0)}
#' @param agegrp Either \code{'0-15m'}, \code{'0-4y'}, \code{'1-21y'},
#'   \code{'0-21y'} or \code{'0-4ya'}. Age group \code{'0-4ya'}
#'   provides the 0-4 chart with weight for age (design E).
#' @param sex Either \code{'male'} or \code{'female'}
#' @param etn Either \code{'netherlands'}, \code{'turkish'},
#'   \code{'moroccan'} or \code{'hindustani'}
#' @param ga  Gestational age (in completed weeks)
#' @param side Either \code{'front'}, \code{'back'}, \code{'-hdc'} or
#'   \code{'both'}
#' @param language Language: \code{'dutch'} or \code{'english'} (not
#'   used)
#' @return A list with elements \code{chartgrp}, \code{chartcode}
#' and \code{ga}
#' @seealso \code{\link[chartcatalog]{create_chartcode}},
#'   \code{\link[minihealth]{individualAN-class}}
#' @examples
#' data("installed.cabinets", package = "jamestest")
#' ind <- installed.cabinets[[3]][[1]]
#' select_chart(ind)
#' @export
select_chart <- function(ind = NULL,
                         chartgrp = NULL,
                         agegrp = NULL,
                         sex = NULL,
                         etn = NULL,
                         ga = NULL,
                         side = "hgt",
                         language = "dutch") {

  # choose defaults depending on individual
  if (!is.null(ind)) {
    if (is.null(agegrp)) agegrp <- select_agegrp(ind)
    if (is.null(chartgrp)) chartgrp <- select_chartgrp(ind)
    if (is.null(ga)) ga <- select_ga(ind)
    if (is.null(sex)) sex <- select_sex(ind)
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

select_chartgrp <- function(ind) {
  # automatic chartgrp setting based on ga
  ga <- slot(ind, "ga")
  if (is.na(ga)) {
    return("nl2010")
  }
  ifelse(ga <= 36, "preterm", "nl2010")
}

select_agegrp <- function(ind) {
  # automatic agegrp setting based on last age
  # get maximum age
  max_age <- get_range(ind)[2L]

  # assign default age group
  if (is.na(max_age)) {
    return("0-15m")
  }
  agegrp <- "0-15m"
  if (max_age > 1.25 & max_age <= 4.0) agegrp <- "0-4y"
  if (max_age > 4.0) agegrp <- "1-21y"
  agegrp
}

select_ga <- function(ind) {
  ga <- slot(ind, "ga")
  if (is.na(ga)) {
    return(32)
  }
  if (ga < 25) {
    return(25)
  }
  ga
}

select_sex <- function(ind) {
  sex <- slot(ind, "sex")
  if (sex %in% c("male", "female")) {
    return(sex)
  }
  return("male")
}
