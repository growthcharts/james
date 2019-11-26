#' Constructs and plots the A4 growth chart
#'
#' This function is a wrapper of \code{chartplotter::process_chart}
#' @inheritParams chartplotter::process_chart
#' @return A grid object
#' @export
draw_plot <- function(individual,
                      chartcode,
                      curve_interpolation = TRUE,
                      quiet = TRUE,
                      con = NULL,
                      dnr = NULL,
                      period = numeric(0),
                      nmatch = 0L,
                      user_model = 2L,
                      exact_sex = TRUE,
                      exact_ga = FALSE,
                      break_ties = TRUE,
                      show_realized = FALSE,
                      show_future = FALSE,
                      clip = TRUE) {

  process_chart(individual = individual,
                chartcode = chartcode,
                curve_interpolation = curve_interpolation,
                quiet = quiet,
                con = con,
                dnr = dnr,
                period = period,
                nmatch = nmatch,
                user_model = user_model,
                exact_sex = exact_sex,
                exact_ga = exact_ga,
                break_ties = break_ties,
                show_realized = show_realized,
                show_future = show_future,
                clip = clip)
}
