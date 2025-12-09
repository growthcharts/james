# Calculates the D-score and DAZ for each visit

The function
[`draw_chart()`](https://growthcharts.org/james/reference/draw_chart.md)
plots individual data on the growth chart.

## Usage

``` r
calculate_dscore(
  txt = "",
  session = "",
  format = "3.1",
  append = c("ddi", "gs1"),
  output = c("table", "last_visit", "last_dscore"),
  loc = "",
  ...
)
```

## Arguments

- txt:

  A JSON string, URL, or file with BDS data in JSON format. Data should
  conform to the BDS JGZ 3.2.5 specification.

- session:

  Optional session key if data is already uploaded to `sitehost`.

- format:

  JSON schema version, e.g., `"3.0"`. Used when uploading.

- append:

  Optional vector of strings indicating which instrument to base D-score
  calculations on. Currently supports `ddi` and `gs1`. Requires JSON
  schema V3.0 or later.

- output:

  A string, either `"table"`, `"last_visit"` or '`"last_dscore"`
  specifying the result. The default `"table"` returns with columns:
  `"date"` (date), `"x"` (age), `"y"` (D-score) and `"z"` (DAZ). The
  number of rows equals to the number of visits. If `output` equals
  `"last_visit"` the function returns only the last row. If `output`
  equals `"last_dscore"` the function returns only the D-score from the
  last row.

- loc:

  Deprecated. Use `session` instead.

- ...:

  Ignored

## Value

A table, row or scalar.

## Author

Stef van Buuren 2020

## Examples

``` r
fn <- system.file("testdata", "Laura_S.json", package = "james")
df <- calculate_dscore(txt = fn)
head(df, 4)
#> [1] a   n   p   d   sem daz
#> <0 rows> (or 0-length row.names)
```
