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
embed_tanner(txt = "", session = "", format = "1.0", ...)
```

## Arguments

- txt:

  A JSON string, URL, or file with BDS data in JSON format. Data should
  conform to the BDS JGZ 3.2.5 specification.

- session:

  OpenCPU session key with the uploaded data

- format:

  JSON schema version, e.g., `"3.0"`. Used when uploading.

- ...:

  Ignored

## Value

A length-1 character string: the self-contained HTML document.

## Details

When `txt`/`session` yield no target data, or the target has no pubertal
measurements at all, the chart still renders – just the reference frame,
with no patient trace – rather than the panel being hidden or the call
failing.

## See also

[`embed_chart()`](https://growthcharts.org/james/reference/embed_chart.md)

## Author

Stef van Buuren 2026

## Examples

``` r
fn <- system.file("testdata", "client_tanner.json", package = "james")
html <- embed_tanner(txt = fn)
```
