# Uploads, parses, converts and stores data on the server for further processing

Uploads JSON data that adhere to the BDS-format, parses its contents,
converts it to a list with elements `psn` and `xyz`, and stores the
result on the server for further processing. The function is useful for
caching input data over multiple requests to `OpenCPU`. The cached data
feed into other JAMES functions by means of the `"loc"` argument. The
server wipes the cached data after 2 hours.

## Usage

``` r
fetch_loc(txt = "", ...)
```

## Arguments

- txt:

  A JSON string, URL or file

- ...:

  Ignored

## Value

A list with elements `psn` (persondata) and `xyz` (timedata).

## See also

[`bdsreader::read_bds()`](https://rdrr.io/pkg/bdsreader/man/read_bds.html)
[`jsonlite::fromJSON()`](https://jeroen.r-universe.dev/jsonlite/reference/fromJSON.html)

## Author

Stef van Buuren 2021

## Examples

``` r
fn <- system.file("testdata", "client3.json", package = "james")
p <- fetch_loc(fn)
#> Warning: fetch_loc() is deprecated and will disappear in Nov 2022. Please use upload_data() instead.
```
