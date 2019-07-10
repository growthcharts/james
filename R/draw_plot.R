#' Constructs and plots the A4 growth chart
#'
#' This function is a wrapper of \code{groeidiagrammen::draw_plot}
#' @inheritParams groeidiagrammen::draw_plot
#' @return A grid object
#' @export
draw_plot <- function(ind, chartcode, curve_interpolation = TRUE,
                      quiet = TRUE) {

  return(process_chart(individual = ind,
                       chartcode = chartcode,
                       curve_interpolation = curve_interpolation,
                       quiet = quiet))
}
