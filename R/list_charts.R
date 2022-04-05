# JAMES - A program to monitor and interpret child growth and development.
# Copyright (C) 2022 Stef van Buuren (stef.vanbuuren@tno.nl)
# Arjan Huizing (arjan.huizing@tno.nl)
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

#' List available growth charts
#'
#' @param chartgrp Optional. String chart group name, e.g. `chartgrp = "who"`.
#' If omitted, `list_charts()` return all charts groups.
#' @param \dots Not used
#' @return A \code{data.frame} with eight columns:
#' \describe{
#' \item{\code{chartgrp}}{Chart group code}
#' \item{\code{chartcode}}{Unique chart code}
#' \item{\code{population}}{Population code: DS (Down Syndrome), HS (Hindostanic),
#' MA (Morrocan), NL (Dutch), PT (Preterm), TU (Turkish), WHOblue (WHO male),
#' WHOpink (WHO female)}
#' \item{\code{sex}}{Either \code{"male"}  or \code{"female"}}
#' \item{\code{design}}{Chart design A: 0-15m, B: 0-4y (WFH), C: 1-21y, D: 0-21y, E: 0-4y (WFA)}
#' \item{\code{side}}{Outcome measure: hgt (height), wgt (weight), hdc (head circumference),
#' wfh (weight for height), bmi (body mass index), front (multiple), back (multiple),
#' -hdc (back, no head circumference)}
#' \item{\code{language}}{Chart language: dutch}
#' \item{\code{week}}{Weeks of gestation 25-36, or missing (>= 37 weeks)}
#' }
#' @examples
#' # list all available charts
#' list_charts()
#' @export
list_charts <- function(chartgrp = NULL, ...) {
  authenticate(...)
  chartbox::list_charts(chartgrp = chartgrp)
}
