# JAMES - A program to monitor and interpret child growth and development.
# Copyright (C) 2025 Stef van Buuren (stef.vanbuuren@tno.nl)
# Arjan Huizing (arjan.huizing@tno.nl)
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

#' List the available growth screeners
#'
#' @param ynames Character vector identifying the measures to be
#' screened. By default, `ynames = c("hgt", "wgt", "hdc")`.
#' @param \dots Used for authentication, passed down to [growthscreener::list_screeners()].
#' @examples
#' head(list_screeners(ynames = "hgt"), 2)
#' @export
list_screeners <- function(ynames = c("hgt", "wgt", "hdc"), ...) {
  authenticate(...)
  growthscreener::list_screeners(ynames = ynames, ...)
}
