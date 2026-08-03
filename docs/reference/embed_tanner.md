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
embed_tanner(txt = "", session = "", format = "1.0", sex = NULL, ...)
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

- ...:

  Ignored

## Value

A length-1 character string: the self-contained HTML document.

## Details

When `txt`/`session` yield no target data, or the target has no pubertal
measurements at all, the chart still renders – just the reference frame,
with no patient trace – rather than the panel being hidden or the call
failing.

`sex` defaults to `NULL`, which derives sex from the target's own
persondata (falling back to `"male"` when there is no target at all).
Pass `"male"`/`"female"` explicitly to override that – e.g. jamesapp's
Tanner panel follows the UI's geslacht radio button rather than whatever
sex happens to be in the uploaded data, so a user can preview the
reference frame for either sex regardless of the patient record.

## See also

[`embed_chart()`](https://growthcharts.org/james/reference/embed_chart.md)

## Author

Stef van Buuren 2026

## Examples

``` r
fn <- system.file("testdata", "client_tanner.json", package = "james")
html <- embed_tanner(txt = fn)
html <- embed_tanner(txt = fn, sex = "female")
```
