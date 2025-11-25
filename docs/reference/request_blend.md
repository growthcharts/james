# Provides multiple outputs in one request

Function `request_blend()` acts as a one-stop-shop to obtain multiple
outputs through one request.

## Usage

``` r
request_blend(
  txt = "",
  sitehost = "",
  session = "",
  blend = "standard",
  loc = "",
  ...
)
```

## Arguments

- txt:

  A JSON string, URL, or file with BDS data in JSON format. Data should
  conform to the BDS JGZ 3.2.5 specification.

- sitehost:

  The server that renders the site. Defaults to
  `"http://localhost:8080"` if not specified.

- session:

  Optional session key if data is already uploaded to `sitehost`.

- blend:

  A string indicating the requested blend. The default (`"standard"`)
  returns the results of the standard end points that produces tables.
  Graphs are currently not supported.

- loc:

  Deprecated. Use `session` instead.

- ...:

  Ignored

## Value

The default `blend = "standard"` return a list with the following
components:

- `txt`:

  String, file or URL with child data

- `session`:

  Session with uploaded child data

- `child`:

  Processed child level data

- `time`:

  Processed time level data

- `screeners`:

  Results from application of screeners to child data

- `site`:

  URL with personalised child data

## Examples

``` r
if (FALSE) { # \dontrun{
fn <- system.file("extdata", "bds_v2.0", "smocc", "Laura_S.json", package = "jamesdemodata")
results <- request_blend(txt = fn)
} # }
```
