# Screen growth curves according to JGZ guidelines

Screen growth curves according to JGZ guidelines

## Usage

``` r
screen_curves(
  txt = "",
  loc = "",
  location = "",
  format = "1.0",
  legacy = TRUE,
  ...
)
```

## Arguments

- txt:

  A JSON string, URL, or file with BDS data in JSON format. Data should
  conform to the BDS JGZ 3.2.5 specification.

- loc:

  Deprecated. Use `session` instead.

- location:

  Legacy for `loc`

- format:

  JSON schema version, e.g., `"3.0"`. Used when uploading.

- legacy:

  Logical indicating whether legacy should be done.

- ...:

  Ignored

## Value

A JSON string containing a table with screening results

## Note

Deprecated for consistency. Function returns JSON, whereas all other
functions return the R object. The alternative
[`screen_growth()`](https://growthcharts.org/james/reference/screen_growth-deprecated.md)
requests only results from screening. The alternative
[`custom_list()`](https://growthcharts.org/james/reference/custom_list.md)
produces the same list as `screen_curves`, but does not convert the
result to JSON.

## Examples

``` r
# # example json
# fn <- system.file("testdata", "client3.json", package = "james")
# fn <- system.file("testdata", "Laura_S_dev.json", package = "james")
#
# # first upload, then screen
# r1 <- jamesclient::james_post(path = "data/upload", txt = fn)
# location <- jamesclient::get_url(r1, "location")
# location
# screen_curves(loc = location)
#
# # upload & screen
# screen_curves(fn)
```
