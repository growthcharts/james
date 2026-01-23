# Calculates the D-score and DAZ for each visit

The function `calculate_dscore()` calculate the D-score for early child
development.

## Usage

``` r
calculate_dscore(
  txt = "",
  session = "",
  format = "3.1",
  append = c("ddi", "gs1"),
  key = NULL,
  population = NULL,
  output = c("table", "last_visit", "last_dscore"),
  loc = "",
  ...
)
```

## Arguments

- txt:

  A JSON string, URL or file

- session:

  Optional session key if data is already uploaded to `sitehost`.

- format:

  String. JSON data schema version number. There are currently three
  schemas supported: `"1.0"`, `"1.1"`, `"2.0"`, `"3.0"` and `"3.1"`.
  Formats `"1.0"` and `"1.1"` are included for backward compatibility
  only. Use `format = "3.1"` for new applications.

- append:

  Optional vector of strings indicating which instrument to base D-score
  calculations on. Currently supports `ddi` and `gs1`. Requires JSON
  schema V3.0 or later.

- key:

  String. They key identifies 1) the difficulty estimates pertaining to
  a particular Rasch model, and 2) the prior mean and standard deviation
  of the prior distribution for calculating the D-score. The default key
  `NULL` sets `key = "gsed2510"`. View `builtin_keys` for an overview of
  the available keys.

- population:

  String. The name of the reference population to calculate DAZ. Use
  `with(builtin_references, table(key, population))` to see which
  built-in references are available for `key - population` combinations.
  If not specified, the function set the default population as
  `builtin_keys$base_population[key == builtin_keys$key]`.

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

Stef van Buuren 2020-2026

## Examples

``` r
fn <- system.file("testdata", "Laura_S.json", package = "james")
df <- calculate_dscore(txt = fn)
head(df, 4)
#> [1] a   n   p   d   sem daz
#> <0 rows> (or 0-length row.names)
```
