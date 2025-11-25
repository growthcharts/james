# Convert json BSD data for single individual to class individual

Convert json BSD data for single individual to class individual

## Usage

``` r
convert_bds_ind(txt = "", format = "1.0", ...)
```

## Arguments

- txt:

  A JSON string, URL or file

- format:

  String. JSON data schema version number. There are currently three
  schemas supported: `"1.0"`, `"1.1"`, `"2.0"`, `"3.0"` and `"3.1"`.
  Formats `"1.0"` and `"1.1"` are included for backward compatibility
  only. Use `format = "3.1"` for new applications.

- ...:

  Ignored

## Value

A list with elements `psn` (persondata) and `xyz` (timedata).

## Note

Deprecated. Use
[`upload_data()`](https://growthcharts.org/james/reference/upload_data.md)
instead.

## Author

Stef van Buuren 2021

## Examples

``` r
fn <- system.file("testdata", "client3.json", package = "james")
p <- convert_bds_ind(fn)
#> Warning: convert_bds_ind() is deprecated and will disappear in Nov 2022. Please use upload_data() instead.
```
