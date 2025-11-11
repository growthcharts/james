# Calculates the D-score and DAZ for each visit

The function
[`draw_chart()`](https://growthcharts.org/james/reference/draw_chart.md)
plots individual data on the growth chart.

## Usage

``` r
calculate_dscore(
  txt = "",
  session = "",
  format = "1.0",
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
#> # A tibble: 4 × 9
#>     age xname yname zname zref                      x     y      z date    
#>   <dbl> <chr> <chr> <chr> <chr>                 <dbl> <dbl>  <dbl> <chr>   
#> 1 0.101 age   dsc   dsc_z ph_2023_dsc_female_40 0.101  15.7 -0.058 19890227
#> 2 0.159 age   dsc   dsc_z ph_2023_dsc_female_40 0.159  18.0  0.022 19890320
#> 3 0.236 age   dsc   dsc_z ph_2023_dsc_female_40 0.236  20.9 -0.018 19890417
#> 4 0.485 age   dsc   dsc_z ph_2023_dsc_female_40 0.485  25.9 -1.48  19890717
```
