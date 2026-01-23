# Calculates the recommended van Wiechen milestones based on age and past milestones

Calculates the recommended van Wiechen milestones based on age and past
milestones

## Usage

``` r
select_vwc(
  txt = "",
  p = 90,
  n = 6,
  session = "",
  format = "1.0",
  loc = "",
  ...
)
```

## Arguments

- txt:

  A JSON string, URL or file

- p:

  Reference percentile indicating the expected probability of a positive
  van Wiechen outcome given child age. Higher values correspond with
  easier items.

- n:

  Number of van Wiechen items to suggest. By default returns all items
  within set probability limits.

- session:

  Optional session key if data is already uploaded to `sitehost`.

- format:

  String. JSON data schema version number. There are currently three
  schemas supported: `"1.0"`, `"1.1"`, `"2.0"`, `"3.0"` and `"3.1"`.
  Formats `"1.0"` and `"1.1"` are included for backward compatibility
  only. Use `format = "3.1"` for new applications.

- loc:

  Deprecated. Use `session` instead.

- ...:

  Ignored

## Value

A string of milestones

## Author

Arjan Huizing 2025

## Examples

``` r
fn <- system.file("testdata", "Laura_S.json", package = "james")
select_vwc(txt = fn, p = 50, n = 10)
#>  [1] "ddifmd027" "ddigmm073" "ddifmd023" "ddifmd024" "ddicmm050" "ddifmd026"
#>  [7] "ddicmm047" "ddigmd074" "ddigmd075" "ddicmm048"
```
