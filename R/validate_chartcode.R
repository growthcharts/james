# JAMES - A program to monitor and interpret child growth and development.
# Copyright (C) 2022 Stef van Buuren (stef.vanbuuren@tno.nl)
# Arjan Huizing (arjan.huizing@tno.nl)
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

#' Validates a growth chart code
#'
#' This function checks whether `chartcode` is a available
#' in the chart library.
#' @param chartcode Chart code, typically something like `"NMAB"`
#' @param \dots Used for authentication
#' @return A logical vector of with `length(chartcode)` elements.
#' @seealso [list_charts()]
#' @export
validate_chartcode <- function(chartcode = "", ...) {
  authenticate(...)
  if (is.empty(chartcode)) {
    return(FALSE)
  }
  chartcode %in% list_charts(...)$chartcode
}
