# Request a tab10 session URL for personalised risk communication

Uploads BDS data to the server (reusing the same upload mechanism as
[`upload_data()`](https://growthcharts.org/james/reference/upload_data.md))
and constructs a URL to a standalone `tab10` deployment with the
resulting session key attached. Callers (e.g. `jamesapp`) use the
returned URL to hand off control to `tab10`, which retrieves the
uploaded data itself via the session's `/rda` path.

## Usage

``` r
request_tab10(
  txt = "",
  sitehost = "",
  tab10host = "",
  session = "",
  format = "3.0",
  ...
)
```

## Arguments

- txt:

  A JSON string, URL, or file with BDS data in JSON format. Data should
  conform to the BDS JGZ 3.2.5 specification.

- sitehost:

  The JAMES server that receives the upload (the same host serving this
  very endpoint). Defaults to `"http://localhost:8080"` if not
  specified.

- tab10host:

  The server hosting the `tab10` Shiny app, e.g.
  `"https://james.groeidiagrammen.nl/tab10"`. Defaults to `sitehost`
  with a `/tab10` path appended.

- session:

  Optional session key if data is already uploaded to `sitehost` (e.g.
  by a prior
  [`request_site()`](https://growthcharts.org/james/reference/request_site.md)
  call). When given, `txt` is ignored and no new upload happens –
  `tab10` retrieves the data itself via the existing session's `/rda`
  path, so the same session key already used for `/site` can be handed
  to `tab10` as-is.

- format:

  JSON schema version, e.g., `"3.0"`. Used when uploading.

## Value

A character string URL pointing to the `tab10` app with a `?session=`
query parameter, or, if no session could be obtained, the bare
`tab10host` URL.

## See also

[`request_site()`](https://growthcharts.org/james/reference/request_site.md),
[`upload_data()`](https://growthcharts.org/james/reference/upload_data.md)

## Author

Stef van Buuren 2026

## Examples

``` r
fn <- system.file("testdata", "client3.json", package = "james")
if (FALSE) { # \dontrun{
url <- request_tab10(txt = fn, sitehost = "http://localhost:8080")
url
} # }
```
