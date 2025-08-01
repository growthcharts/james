# JAMES - A program to monitor and interpret child growth and development.
# Copyright (C) 2025 Stef van Buuren (stef.vanbuuren@tno.nl)
# Arjan Huizing (arjan.huizing@tno.nl)
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

.onLoad <- function(libname, pkgname) {
  Sys.setenv("JWT_AUTH" = "n")
  op <- options()
  op.james <- list(
    max.print = 100000
  )
  toset <- names(op)
  options(op.james[toset])

  invisible(NULL)
}
