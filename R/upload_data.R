# JAMES - A program to monitor and interpret child growth and development.
# Copyright (C) 2022 Stef van Buuren (stef.vanbuuren@tno.nl)
# Arjan Huizing (arjan.huizing@tno.nl)
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

#' Uploads, parses, converts and stores data on the server
#'
#' Uploads JSON data that adhere to the BDS-format, parses its
#' contents, converts it to a list with elements `psn` and `xyz`,
#' and stores the result on the server for further processing.
#' The function is useful for caching input data over multiple requests to
#' `OpenCPU`. The cached data feed into other JAMES functions by means
#' of the `session` header in the response. The server wipes the
#' cached data after 2 hours.
#' @inheritParams bdsreader::read_bds
#' @param \dots Used for additional parameters
#' @return A list with elements `psn` (persondata) and `xyz` (timedata).
#' @author Stef van Buuren 2021
#' @seealso [bdsreader::read_bds()]
#'          [jsonlite::fromJSON()]
#' @examples
#' fn <- system.file("testdata", "client3.json", package = "james")
#' p <- upload_data(fn)
#' @keywords server
#' @export
upload_data <- function(txt = "",
                        auto_format = TRUE,
                        format = "1.0",
                        schema = NULL,
                        validate = FALSE,
                        append_ddi = FALSE,
                        intermediate = FALSE,
                        verbose = FALSE,
                        ...) {
  authenticate(...)
  read_bds(txt = txt,
           auto_format = auto_format,
           format = format,
           schema = schema,
           validate = validate,
           append_ddi = append_ddi,
           intermediate = intermediate,
           verbose = verbose,
           ...)
}
