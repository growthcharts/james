# Calculates the domain specific D-score and DAZ for each visit

The function
[`draw_chart()`](https://growthcharts.org/james/reference/draw_chart.md)
plots individual data on the growth chart.

## Usage

``` r
calculate_ddomain(
  txt = "",
  session = "",
  format = "3.1",
  append = c("ddi", "gs1"),
  set = "GFCLS",
  domain = NULL,
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

- set:

  String with the name of the domainset

- domain:

  Vector of strings with names of specific domains, by default all
  domains in the set are returned.

- loc:

  Deprecated. Use `session` instead.

- ...:

  Ignored

## Value

A list of data.frames.

## Author

Iris Eekhout 2025

## Examples

``` r
fn <- system.file("testdata", "Laura_S.json", package = "james")
df <- calculate_dscore(txt = fn)
head(df, 4)
#> [1] a   n   p   d   sem daz
#> <0 rows> (or 0-length row.names)
```
