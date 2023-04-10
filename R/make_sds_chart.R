#' Make SDS chart and save as HTML widget
#'
#' Save the plot as `sds.html` and an external library `lib2`
#' @param title Widget title
#' @param background Widget background
#' @export
make_sds_chart <- function(title = "SDS plot", background = "#F7F7F7") {
  trace_0 <- stats::rnorm(100, mean = 5)
  trace_1 <- stats::rnorm(100, mean = 0)
  trace_2 <- stats::rnorm(100, mean = -5)
  x <- c(1:100)

  data <- data.frame(x, trace_0, trace_1, trace_2)

  fig <- plot_ly(data, x = ~x, y = ~trace_0, name = 'trace 0', type = 'scatter', mode = 'lines')
  fig <- fig %>% add_trace(y = ~trace_1, name = 'trace 1', mode = 'lines+markers')
  fig <- fig %>% add_trace(y = ~trace_2, name = 'trace 2', mode = 'markers')

  htmlwidgets::saveWidget(widget = fig, file = "sds.html",
                          selfcontained = FALSE, libdir = "lib2",
                          background = background, title = title)
  invisible(NULL)
}
