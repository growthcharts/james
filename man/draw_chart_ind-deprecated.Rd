% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/deprecated.R
\name{draw_chart_ind-deprecated}
\alias{draw_chart_ind-deprecated}
\alias{draw_chart_ind}
\title{Draw growth chart with individual data}
\usage{
draw_chart_ind(loc = "", chartcode = "", curve_interpolation = TRUE, ...)
}
\arguments{
\item{loc}{Alternative to \code{txt}. Location where input data is uploaded.
Argument \code{loc} is deprecated and will disappear in Nov 2022; please
use \code{session} instead.}

\item{chartcode}{Optional. The code of the requested growth chart.}

\item{curve_interpolation}{A logical indicating whether curve
interpolation shoud be applied.}

\item{...}{Ignored}
}
\description{
The function \code{draw_chart_ind()} expect an input location from
a previous call, and plots the individual data on the requested
growth chart.
}
\note{
Deprecated. Please use the more comprehensive \code{\link[=draw_chart]{draw_chart()}}
function.
}
\seealso{
\code{\link[=select_chart]{select_chart()}}
\code{\link[chartplotter:process_chart]{chartplotter::process_chart()}}
}
\keyword{server}
