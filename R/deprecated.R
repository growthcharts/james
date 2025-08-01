# JAMES - A program to monitor and interpret child growth and development.
# Copyright (C) 2025 Stef van Buuren (stef.vanbuuren@tno.nl)
# Arjan Huizing (arjan.huizing@tno.nl)
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

#' Convert json BSD data for single individual to class individual
#'
#' @note Deprecated. Use [upload_data()] instead.
#' @name convert_bds_ind-deprecated
#' @inheritParams bdsreader::read_bds
#' @return A list with elements `psn` (persondata) and `xyz` (timedata).
#' @author Stef van Buuren 2021
#' @examples
#' fn <- system.file("testdata", "client3.json", package = "james")
#' p <- convert_bds_ind(fn)
#' @keywords server
#' @export
convert_bds_ind <- function(txt = "", format = "1.0", ...) {
  authenticate(...)
  .Deprecated("upload_data",
              msg = "convert_bds_ind() is deprecated and will disappear in Nov 2022. Please use upload_data() instead."
  )
  upload_data(txt = txt, format = format, ...)
}


#' Provides a Screen growth curves according to JGZ guidelines
#'
#' @inheritParams request_site
#' @inheritParams bdsreader::read_bds
#' @return A table with screening results
#' @return A list with custom parts
#' @examples
#' fn <- system.file("extdata", "bds_v2.0", "smocc", "Laura_S.json", package = "jamesdemodata")
#' host <- "http://localhost"
#' \dontrun{
#' # first upload, then create custom list
#' r1 <- jamesclient::james_post(host = host, path = "data/upload", txt = fn)
#' loc <- jamesclient::get_url(r1, "location")
#' list1 <- custom_list(loc = loc)
#'
#' # upload & screen
#' list2 <- custom_list(txt = fn)
#' identical(list1, list2)
#' }
#' @export
custom_list <- function(txt = "", session = "", format = "1.0", loc = "", ...) {
  authenticate(...)

  .Deprecated("request_blend",
              msg = "custom_list() is deprecated. Please use request_blend(..., blend = 'allegro') instead.")

  if (!missing(loc)) {
    warning("Argument loc is deprecated and will disappear in Nov 2022; please use session instead.",
            call. = FALSE
    )
    session <- loc2session(loc)
  }
  return(list(session = session))
}



#' Convert bds-format data to individual and return growth chart
#'
#' The function `draw_chart_bds()` convert bds data into an object
#' of class individual, and then draws the
#' individual data on the requested growth chart.
#' Superseded by [draw_chart()].
#' @name draw_chart_bds-deprecated
#' @param txt   A JSON string, URL or file
#' @param selector Legacy addition to solve a problem in jgzApp. See
#' `draw_chart` for interpretation. The default is set to
#' `"chartcode"`.
#' @param \dots For `draw_chart_bds`, additional parameter passed
#'   down to `fromJSON(txt, ...)`, `new("xyz",... )` and
#'   `new("bse",... )`. Useful parameters are `models =
#'   "bsmodel"` for setting the broken stick model, or `call =
#'   as.call(...)` for setting proper reference standards.
#' @inheritParams chartplotter::process_chart
#' @inheritParams bdsreader::set_schema
#' @examples
#' fn <- system.file("testdata", "client3.json", package = "james")
#' g <- draw_chart_bds(txt = fn)
#' @keywords server
#' @export
draw_chart_bds <- function(txt = "", format = "1.0",
                           chartcode = "",
                           curve_interpolation = TRUE,
                           selector = "chartcode", ...) {
  authenticate(...)

  # legacy
  .Deprecated("draw_chart",
              msg = "draw_chart_bds() is deprecated and will disappear in Nov 2022. Please use draw_chart() instead."
  )

  draw_chart(
    txt = txt, format = format, chartcode = chartcode,
    curve_interpolation = curve_interpolation,
    selector = selector,
    ...
  )
}


#' Draw growth chart with individual data
#'
#' The function `draw_chart_ind()` expect an input location from
#' a previous call, and plots the individual data on the requested
#' growth chart.
#' @name draw_chart_ind-deprecated
#' @inheritParams draw_chart
#' @note Deprecated. Please use the more comprehensive [draw_chart()]
#' function.
#' @seealso [select_chart()]
#' [chartplotter::process_chart()]
#' @keywords server
#' @export
draw_chart_ind <- function(loc = "", chartcode = "",
                           curve_interpolation = TRUE, ...) {
  authenticate(...)
  .Deprecated("draw_chart",
              msg = "draw_chart_ind() is deprecated and will disappear in Nov 2022. Please use draw_chart() instead."
  )

  # legacy
  draw_chart(
    loc = loc, chartcode = chartcode,
    curve_interpolation = curve_interpolation,
    ...
  )
}

#' Uploads, parses, converts and stores data on the server for further processing
#'
#' Uploads JSON data that adhere to the BDS-format, parses its
#' contents, converts it to a list with elements `psn` and `xyz`,
#' and stores the result on the server for further processing.
#' The function is useful for caching input data over multiple requests to
#' `OpenCPU`. The cached data feed into other JAMES functions by means
#' of the `"loc"` argument. The server wipes the cached data after 2 hours.
#' @name fetch_loc-deprecated
#' @inheritParams bdsreader::read_bds
#' @return A list with elements `psn` (persondata) and `xyz` (timedata).
#' @author Stef van Buuren 2021
#' @seealso [bdsreader::read_bds()]
#'          [jsonlite::fromJSON()]
#' @examples
#' fn <- system.file("testdata", "client3.json", package = "james")
#' p <- fetch_loc(fn)
#' @keywords server
#' @export
fetch_loc <- function(txt = "",
                      ...) {
  authenticate(...)
  .Deprecated("upload_data",
              msg = "fetch_loc() is deprecated and will disappear in Nov 2022. Please use upload_data() instead.")
  upload_data(txt = txt, ...)
}

#' Screen growth curves according to JGZ guidelines
#'
#' @name screen_curves-deprecated
#' @inheritParams request_site
#' @inheritParams bdsreader::read_bds
#' @param location Legacy for `loc`
#' @param legacy Logical indicating whether legacy should be done.
#' @return A JSON string containing a table with screening results
#' @note Deprecated for consistency. Function returns JSON, whereas all other
#' functions return the R object. The alternative [screen_growth()]
#' requests only results from screening. The alternative [custom_list()]
#' produces the same list as `screen_curves`, but does not convert the
#' result to JSON.
#' @examples
#' # # example json
#' # fn <- system.file("testdata", "client3.json", package = "james")
#' # fn <- system.file("testdata", "Laura_S_dev.json", package = "james")
#' #
#' # # first upload, then screen
#' # r1 <- jamesclient::james_post(path = "data/upload", txt = fn)
#' # location <- jamesclient::get_url(r1, "location")
#' # location
#' # screen_curves(loc = location)
#' #
#' # # upload & screen
#' # screen_curves(fn)
#' @export
screen_curves <- function(txt = "", loc = "", location = "", format = "1.0",
                          legacy = TRUE, ...) {
  authenticate(...)
  .Deprecated("apply_screeners",
              msg = "screen_curves() is deprecated and will disappear in Nov 2022. Please use apply_screeners() instead."
  )
  # legacy
  if (!is.empty(location)) loc <- location
  if (legacy) {
    toJSON(custom_list(txt = txt, loc = loc, ...))
  } else {
    toJSON(screen_curves_ind(ind = get_tgt(txt = txt, loc = loc, format = format),
                             ...))
  }
}

#' Screen growth curves according to JGZ guidelines
#'
#' @name screen_growth-deprecated
#' @inheritParams bdsreader::read_bds
#' @inheritParams request_site
#' @param ynames Character vector identifying the measures to be
#' screened. By default, `ynames = c("hgt", "wgt", "hdc")`.
#' @param na.omit A logical indicating whether records with a missing
#' `x` (age) or `y` (yname) should be removed. Defaults to
#' `TRUE`.
#' @examples
#' host <- "http://localhost"
#' fn <- system.file("testdata", "client3.json", package = "james")
#'
#' \dontrun{
#' # first upload, then screen
#' r1 <- jamesclient::james_post(path = "data/upload", txt = fn)
#' location <- jamesclient::get_url(r1, "location")
#' location
#' screen_growth(loc = location)
#'
#' session <- jamesclient::get_url(r1, "session")
#' session
#' screen_growth(session = session)
#'
#' # upload & screen
#' screen_growth(fn)
#' }
#' @export
screen_growth <- function(txt = "",
                          loc = "",
                          format = "1.0",
                          ynames = c("hgt", "wgt", "hdc"),
                          na.omit = TRUE,
                          ...) {
  authenticate(...)
  .Deprecated("apply_screeners",
              msg = "screen_growth() is deprecated. Please use apply_screeners() instead.")
  screen_curves_ind(ind = get_tgt(txt = txt, loc = loc, format = format),
                    ynames = ynames,
                    na.omit = na.omit,
                    ...)
}
