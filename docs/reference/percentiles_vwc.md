# Provides additional information on percentiles of D-score and age in months for the percentiles 2, 10, 50, 90 and 98. User either provides known van Wiechen milestones, or information to calculate the recommended van Wiechen milestones based on age and past milestones.

Provides additional information on percentiles of D-score and age in
months for the percentiles 2, 10, 50, 90 and 98. User either provides
known van Wiechen milestones, or information to calculate the
recommended van Wiechen milestones based on age and past milestones.

## Usage

``` r
percentiles_vwc(
  txt = "",
  p = 90,
  n = 6,
  vwc = NULL,
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

- vwc:

  Vector of string values matching van Wiechen milestones. Bypasses
  calculations and directly supply the milestones of interest

- session:

  Optional session key if data is already uploaded to `sitehost`.

- format:

  JSON schema version, e.g., `"3.0"`. Used when uploading.

- loc:

  Deprecated. Use `session` instead.

- ...:

  Ignored

## Value

A table.

## Author

Arjan Huizing 2025

## Examples

``` r
fn <- system.file("testdata", "Laura_S.json", package = "james")
percentiles_vwc(txt = fn, p = 50, n = 3)
#> # A tibble: 3 × 11
#>   item         D2   D10   D50   D90   D98    A2   A10   A50   A90   A98
#>   <chr>     <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
#> 1 ddifmd027  60.8  64.4  69    73.6  77.2  20.9  24.7  30.5    NA    NA
#> 2 ddigmm073  58.9  62.5  67.1  71.7  75.3  19.1  22.6  28.0    NA    NA
#> 3 ddicmm050  61.3  64.9  69.5  74.1  77.7  21.4  25.2  31.2    NA    NA
```
