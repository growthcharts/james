# Request site containing personalised charts

Constructs a URL to a JAMES site showing a personalised growth chart.
Optionally uploads the data to the server and returns a session-based
URL.

## Usage

``` r
request_site(
  txt = "",
  sitehost = "",
  session = "",
  format = "3.0",
  upload = TRUE,
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

- format:

  JSON schema version, e.g., `"3.0"`. Used when uploading.

- upload:

  Logical. If `TRUE`, uploads `txt` and returns URL with `?session=`. If
  `FALSE`, appends `?txt=` directly (not recommended).

- loc:

  Deprecated. Use `session` instead.

- ...:

  Ignored

## Value

A character string URL pointing to the personalised JAMES site.

## See also

[`jamesclient::james_post()`](https://rdrr.io/pkg/jamesclient/man/james_post.html),
[`jamesclient::get_url()`](https://rdrr.io/pkg/jamesclient/man/get_url.html)

## Examples

``` r
fn <- system.file("testdata", "client3.json", package = "james")
js <- jsonlite::toJSON(jsonlite::fromJSON(fn), auto_unbox = TRUE)
url <- "https://groeidiagrammen.nl/ocpu/library/james/testdata/client3.json"
host <- "http://localhost:8080"
host <- "https://james.groeidiagrammen.nl"

# solutions that upload the data and create a URL with the `?session=` query parameter
if (FALSE) { # \dontrun{
# upload file - works with docker on localhost
site <- request_site(sitehost = host, txt = fn)
# browseURL(site)

# upload JSON string
site <- request_site(sitehost = host, txt = js)
site
# browseURL(site)

# upload URL
site <- request_site(sitehost = host, txt = url)
site
# browseURL(site)

# same, but in two steps, starting from file name
# this also works for js and url
resp <- jamesclient::james_post(path = "data/upload", txt = fn)
session <- resp$session
site <- request_site(sitehost = host, session = session)
site
# browseURL(site)

# solutions that create an immediate ?txt=[..data..] query
# this method does not create a cache on the server
site <- request_site(sitehost = host, txt = js, upload = FALSE)
# browseURL(site)
} # }
```
