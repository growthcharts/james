# JAMES - A program to monitor and interpret child growth and development.
# Copyright (C) 2025 Stef van Buuren (stef.vanbuuren@tno.nl)
# Arjan Huizing (arjan.huizing@tno.nl)
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

#' Draw an interactive, embeddable Tanner pubertal-stage chart
#'
#' `embed_tanner()` is the Tanner-chart counterpart to [embed_chart()]:
#' it returns a self-contained HTML document (a `plotly` widget) as a
#' character string, retrievable at the session's `R/.val/text` path and
#' meant for embedding via `<iframe srcdoc="...">`. Unlike `embed_chart()`,
#' there is exactly one chart, so there is no `chartcode`/multi-chart
#' dispatch.
#'
#' When `txt`/`session` yield no target data, or the target has no
#' pubertal measurements at all, the chart still renders -- just the
#' reference frame, with no patient trace -- rather than the panel being
#' hidden or the call failing.
#'
#' The chart title includes the patient id (e.g. "... - Patient 1234")
#' whenever one is available. bdsreader codes an unset client id as -1,
#' not `NA`; that sentinel is detected and treated as no-id, so the
#' title correctly omits the suffix rather than showing "- Patient -1".
#' Use `patient_id` to override the id shown regardless of what the
#' uploaded data carries.
#'
#' `sex` defaults to `NULL`, which derives sex from the target's own
#' persondata (falling back to `"male"` when there is no target at all).
#' Pass `"male"`/`"female"` explicitly to override that -- e.g. jamesapp's
#' Tanner panel follows the UI's geslacht radio button rather than
#' whatever sex happens to be in the uploaded data, so a user can preview
#' the reference frame for either sex regardless of the patient record.
#'
#' `traces`/`stage_lines` control which stage types' patient-data traces
#' and reference lines, respectively, are visible when the chart first
#' renders -- see `tannerly::plot_stadia_ly()`. Both are comma-separated
#' strings of raw Tanner `varName`s (`"gen"`, `"phb"`, `"tv"` for male
#' patients; `"bre"`, `"phg"`, `"men"` for female), since this endpoint
#' takes multipart/form-data rather than R vectors. Leaving either `""`
#' (the default) keeps `plot_stadia_ly()`'s own defaults: all three
#' traces visible, no reference lines. A type not listed still gets a
#' legend entry -- viewers can always toggle it on/off by hand.
#'
#' @inheritParams draw_chart
#' @param sex Optional. `"male"` or `"female"`. Overrides the sex derived
#' from the target's persondata when supplied; see Details.
#' @param traces Optional. Comma-separated raw Tanner `varName`s (see
#' Details) whose patient-data trace starts visible.
#' @param stage_lines Optional. Comma-separated raw Tanner `varName`s
#' (see Details) whose reference lines start visible.
#' @param patient_id Optional. Overrides the patient id shown in the
#' chart title ("Tanner pubertal stages - Patient <id>") -- both the id
#' derived from the uploaded data's persondata and bdsreader's -1
#' "no id" sentinel (which is otherwise suppressed, see Details). Pass
#' `NA` to force the title back to its no-id form.
#' @return A length-1 character string: the self-contained HTML document.
#' @author Stef van Buuren 2026
#' @seealso [embed_chart()]
#' @keywords server
#' @examples
#' fn <- system.file("testdata", "client_tanner.json", package = "james")
#' html <- embed_tanner(txt = fn)
#' html <- embed_tanner(txt = fn, sex = "female")
#' html <- embed_tanner(txt = fn, traces = "gen", stage_lines = "gen")
#' html <- embed_tanner(txt = fn, patient_id = "1234")
#' @export
embed_tanner <- function(txt = "", session = "", format = "1.0", sex = NULL,
                          traces = "", stage_lines = "", patient_id = NULL, ...) {
  authenticate(...)

  tgt <- get_tgt(txt = txt, session = session, format = format)
  patient <- build_tanner_patient(tgt, patient_id = patient_id)
  sex_code <- if (!is.null(sex)) {
    sex[1L]
  } else if (!is.null(tgt)) {
    bdsreader::persondata(tgt)$sex[1]
  } else {
    "male"
  }
  sex <- if (identical(sex_code, "female")) "F" else "M"

  # "" (the default) must become NULL, not character(0) -- plot_stadia_ly()
  # treats NULL as "use my own default" (all traces / no stage lines) but
  # character(0) as "show nothing", which is not the same thing for traces.
  split_varnames <- function(x) {
    x <- trimws(strsplit(x, ",", fixed = TRUE)[[1L]])
    x <- x[nzchar(x)]
    if (length(x) == 0L) NULL else x
  }

  # #F7F7F7 matches jamesapp's own .graph/#plotDiv panel background (see
  # inst/www/css/main.css), so the chart's outer margin blends into the
  # panel instead of showing a white edge around the rounded frame.
  fig <- tannerly::plot_stadia_ly(
    patient,
    sex = sex,
    bgcolor = "#F7F7F7",
    traces = split_varnames(traces),
    stage_lines = split_varnames(stage_lines)
  )

  # Colored to match plot_stadia_ly()'s own percentile bands ("10% late"
  # foreground / "1% late" background), and vertically centered in the
  # "1% late" band -- the chart's outermost, bottom-most band -- rather
  # than add_logo()'s bottom-margin default. yr/qnorm(0.005) mirror
  # plot_stadia_ly()'s own axis range and band boundary (tannerly does
  # not currently expose either as parameters).
  logo_sizey <- 0.08
  yr <- c(-3.24, 3.24)
  band_1pct_late <- c(yr[1], stats::qnorm(0.005))
  band_mid_paper <- (mean(band_1pct_late) - yr[1]) / diff(yr)
  plot_area_width_px <- 900 - 60 - 20
  shift_left_paper <- 10 / plot_area_width_px
  fig <- multikaart::add_logo(
    fig,
    foreground_color = "#FFCFCF",
    background_color = "#FFAFAF",
    x = 0.99 - shift_left_paper,
    y = band_mid_paper - logo_sizey / 2,
    sizex = 0.08,
    sizey = logo_sizey
  )

  widget <- multikaart::unwrap_widget(fig)
  tmp <- tempfile(fileext = ".html")
  on.exit(unlink(tmp))
  multikaart::save_widget_cdn(widget, tmp)
  paste(readLines(tmp, warn = FALSE), collapse = "\n")
}

# Builds the wide, one-row-per-visit-age data frame that
# tannerly::plot_stadia_ly() expects, from a bdsreader target's xyz.
# Returns a stub frame with all *_sds columns present-but-NA when tgt is
# NULL, so plot_stadia_ly()'s own `present` logic degrades to a
# reference-frame-only chart rather than erroring.
#
# The "men" (menarche) yname is stage-coded 1 = pre-menarche,
# 2 = post-menarche -- the same 1-indexed convention every other Tanner
# stage type uses, and the coding tanner::calculate_sds() requires (it
# indexes tanner::nl1997_lines$men's M1/M2 columns directly). This is
# NOT a 0/1 boolean; a 0 here would silently produce a nonsense SDS.
build_tanner_patient <- function(tgt, patient_id = NULL) {
  pubertal_types <- list(
    M = c(gen = "gen", phb = "phb", tv = "tv"),
    F = c(bre = "bre", phg = "phg", men = "men")
  )
  cols <- unique(unlist(pubertal_types))

  if (is.null(tgt)) {
    id <- if (!is.null(patient_id)) patient_id[1L] else NA_integer_
    stub <- data.frame(id = id, age = NA_real_)
    for (col in cols) {
      stub[[col]] <- NA_real_
      stub[[paste0(col, "_sds")]] <- NA_real_
    }
    return(stub)
  }

  xyz <- tgt$xyz[tgt$xyz$yname %in% cols, , drop = FALSE]
  # bdsreader codes "no client id" as -1, not NA; plot_stadia_ly() only
  # suppresses its "- Patient <id>" title suffix for NA, so an unset id
  # would otherwise render literally as "- Patient -1". patient_id, when
  # supplied, overrides whatever id the uploaded data carries (or lacks).
  id <- tgt$psn$id[1]
  if (identical(id, -1L) || identical(id, -1)) id <- NA_integer_
  if (!is.null(patient_id)) id <- patient_id[1L]

  if (nrow(xyz) == 0L) {
    stub <- data.frame(id = id, age = NA_real_)
    for (col in cols) {
      stub[[col]] <- NA_real_
      stub[[paste0(col, "_sds")]] <- NA_real_
    }
    return(stub)
  }

  wide <- tidyr::pivot_wider(
    xyz,
    id_cols = "age",
    names_from = "yname",
    values_from = "y"
  )

  patient <- data.frame(id = id, age = wide$age)
  for (col in cols) {
    patient[[col]] <- if (col %in% names(wide)) wide[[col]] else NA_real_
    patient[[paste0(col, "_sds")]] <- tanner::calculate_sds(
      patient$age,
      patient[[col]],
      col
    )
  }
  patient
}
