#' Make SDS chart and save as HTML widget
#'
#' Save the plot as `sds.html` and an external library `lib2`
#' @param title Widget title
#' @export
make_sds_chart <- function(title = "SDS plot") {
  trace_0 <- stats::rnorm(100, mean = 5)
  trace_1 <- stats::rnorm(100, mean = 0)
  x <- c(1:100)

  data <- data.frame(x, trace_0, trace_1, trace_2)

  fig <- plot_ly(data, x = ~x, y = ~trace_0, name = 'trace 0',
                 type = 'scatter', mode = 'lines')
  fig <- fig %>%
    add_trace(y = ~trace_1, name = 'trace 1', mode = 'lines+markers') %>%
    layout(title = "Standard Deviation Scores Chart",
           plot_bgcolor = "rgba(0,0,0,0)",
           paper_bgcolor = "rgba(0,0,0,0)")

  htmlwidgets::saveWidget(widget = fig, file = "sds.html",
                          selfcontained = FALSE, libdir = "lib2",
                          title = title)
  invisible(NULL)
}
