# Uploads, parses, converts and stores data on the server

Uploads JSON data that adhere to the BDS-format, parses its contents,
converts it to a list with elements `psn` and `xyz`, and stores the
result on the server for further processing. The function is useful for
caching input data over multiple requests to `OpenCPU`. The cached data
feed into other JAMES functions by means of the `session` header in the
response. The server wipes the cached data after 2 hours.

## Usage

``` r
upload_data(
  txt = "",
  auto_format = TRUE,
  format = "1.0",
  schema = NULL,
  validate = FALSE,
  append_ddi = FALSE,
  intermediate = FALSE,
  verbose = FALSE,
  ...
)
```

## Arguments

- txt:

  A JSON string, URL or file

- auto_format:

  Logical. Should the format be read from the data? Default is `TRUE`.

- format:

  String. JSON data schema version number. There are currently three
  schemas supported: `"1.0"`, `"1.1"`, `"2.0"`, `"3.0"` and `"3.1"`.
  Formats `"1.0"` and `"1.1"` are included for backward compatibility
  only. Use `format = "3.1"` for new applications.

- schema:

  A file name (optionally including the path) with the JSON validation
  schema. The `schema` argument overrides `format`. The function
  extracts the version number for the basename, and overwrites the
  `format` argument by version number.

- validate:

  Logical. Should the JSON-input be validated against the JSON-schema?
  The default (`FALSE`) bypasses checking. Set `validate = TRUE` to
  obtain diagnostic information from the
  [`jsonvalidate::json_validate()`](https://docs.ropensci.org/jsonvalidate/reference/json_validate.html)
  function.

- append_ddi:

  Should the DDI responses be appended? (only used for JSON schema V1.0
  and V2.0)

- intermediate:

  Logical. If `TRUE` the function writes JSON files with intermediate
  result to the working directory. 1. `input.json`: the JSON input
  data; 2. `bds.json`: a data frame with info per BDS; 3. `ddi.json`:
  result of recoding BDS into GSED item names; 4. `psn.json`: known
  fixed child covariates; 5. `xy.json`: time-varying variables.

- verbose:

  Show verbose output for
  [`centile::y2z()`](https://rdrr.io/pkg/centile/man/y2z.html)

- ...:

  Used for additional parameters

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
p <- upload_data(fn)
```
