# Draw an interactive, embeddable Tanner pubertal-stage chart

`embed_tanner()` is the Tanner-chart counterpart to
[`embed_chart()`](https://growthcharts.org/james/reference/embed_chart.md):
it returns a self-contained HTML document (a `plotly` widget) as a
character string, retrievable at the session's `R/.val/text` path and
meant for embedding via `<iframe srcdoc="...">`. Unlike
[`embed_chart()`](https://growthcharts.org/james/reference/embed_chart.md),
there is exactly one chart, so there is no `chartcode`/multi-chart
dispatch.

## Usage

``` r
embed_tanner(
  txt = "",
  session = "",
  format = "1.0",
  sex = NULL,
  traces = "",
  stage_lines = "",
  patient_id = NULL,
  ...
)
```

## Arguments

- txt:

  A JSON string, URL, or file with BDS data in JSON format. Data should
  conform to the BDS JGZ 3.2.5 specification.

- session:

  OpenCPU session key with the uploaded data

- format:

  JSON schema version, e.g., `"3.0"`. Used when uploading.

- sex:

  Optional. `"male"` or `"female"`. Overrides the sex derived from the
  target's persondata when supplied; see Details.

- traces:

  Optional. Comma-separated raw Tanner `varName`s (see Details) whose
  patient-data trace starts visible.

- stage_lines:

  Optional. Comma-separated raw Tanner `varName`s (see Details) whose
  reference lines start visible.

- patient_id:

  Optional. Overrides the patient id shown in the chart title ("Tanner
  pubertal stages - Patient ") – both the id derived from the uploaded
  data's persondata and bdsreader's -1 "no id" sentinel (which is
  otherwise suppressed, see Details). Pass `NA` to force the title back
  to its no-id form.

- ...:

  Ignored

## Value

A length-1 character string: the self-contained HTML document.

## Details

When `txt`/`session` yield no target data, or the target has no pubertal
measurements at all, the chart still renders – just the reference frame,
with no patient trace – rather than the panel being hidden or the call
failing.

The chart title includes the patient id (e.g. "... - Patient 1234")
whenever one is available. bdsreader codes an unset client id as -1, not
`NA`; that sentinel is detected and treated as no-id, so the title
correctly omits the suffix rather than showing "- Patient -1". Use
`patient_id` to override the id shown regardless of what the uploaded
data carries.

`sex` defaults to `NULL`, which derives sex from the target's own
persondata (falling back to `"male"` when there is no target at all).
Pass `"male"`/`"female"` explicitly to override that – e.g. jamesapp's
Tanner panel follows the UI's geslacht radio button rather than whatever
sex happens to be in the uploaded data, so a user can preview the
reference frame for either sex regardless of the patient record.

`traces`/`stage_lines` control which stage types' patient-data traces
and reference lines, respectively, are visible when the chart first
renders – see
[`tannerly::plot_stadia_ly()`](https://rdrr.io/pkg/tannerly/man/plot_stadia_ly.html).
Both are comma-separated strings of raw Tanner `varName`s (`"gen"`,
`"phb"`, `"tv"` for male patients; `"bre"`, `"phg"`, `"men"` for
female), since this endpoint takes multipart/form-data rather than R
vectors. Leaving either `""` (the default) keeps `plot_stadia_ly()`'s
own defaults: all three traces visible, no reference lines. A type not
listed still gets a legend entry – viewers can always toggle it on/off
by hand.

## See also

[`embed_chart()`](https://growthcharts.org/james/reference/embed_chart.md)

## Author

Stef van Buuren 2026

## Examples

``` r
fn <- system.file("testdata", "client_tanner.json", package = "james")
html <- embed_tanner(txt = fn)
html <- embed_tanner(txt = fn, sex = "female")
html <- embed_tanner(txt = fn, traces = "gen", stage_lines = "gen")
html <- embed_tanner(txt = fn, patient_id = "1234")
```
