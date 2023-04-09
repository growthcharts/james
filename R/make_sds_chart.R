#' Make SDS charts
#'
#' @param title label for the marker
#' @param lat lattitude coordinate
#' @param lng longintude coordinate
#' @export
make_sds_chart <- function(title = "This is a test", lat = NULL, lng = NULL) {
  trace_0 <- stats::rnorm(100, mean = 5)
  trace_1 <- stats::rnorm(100, mean = 0)
  trace_2 <- stats::rnorm(100, mean = -5)
  x <- c(1:100)

  data <- data.frame(x, trace_0, trace_1, trace_2)

  fig <- plot_ly(data, x = ~x, y = ~trace_0, name = 'trace 0', type = 'scatter', mode = 'lines')
  fig <- fig %>% add_trace(y = ~trace_1, name = 'trace 1', mode = 'lines+markers')
  fig <- fig %>% add_trace(y = ~trace_2, name = 'trace 2', mode = 'markers')

  fig <- plotly::partial_bundle(fig)
  htmlwidgets::saveWidget(fig, "mychart.html", selfcontained = TRUE)
}
