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

  A JSON string, URL, or file with BDS data in JSON format. Data should
  conform to the BDS JGZ 3.2.5 specification.

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

  JSON schema version, e.g., `"3.0"`. Used when uploading.

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
#> [1] "ddifmd027\nddigmm073\nddifmd023\nddifmd024\nddicmm050\nddifmd026\nddicmm047\nddigmd074\nddigmd075\nddicmm048"
```
