# Request site containing personalised charts

Constructs a URL to a JAMES site showing a personalised growth chart.
Optionally uploads the data to the server and returns a session-based
URL.

## Usage

``` r
request_site(
  txt = "",
  sitehost = "",
  endpointhost = sitehost,
  session = "",
  format = "3.0",
  upload = TRUE,
  loc = "",
  display = list(),
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

- endpointhost:

  The server the site's `ocpu.rpc()` calls should target. Defaults to
  `sitehost`, i.e. the same server renders the site and serves its JAMES
  endpoints (today's setup). Set this when `sitehost` serves a
  standalone `jamesapp` deployment that talks to a JAMES endpoints
  server on a different host: the returned URL then carries an extra
  `?ocpuhost=` query parameter that `jamesapp`'s
  `opencpu-0.5-james-0.1.js` reads to point its RPC calls at
  `endpointhost` instead of assuming same-origin.

- session:

  Optional session key if data is already uploaded to `sitehost`.

- format:

  JSON schema version, e.g., `"3.0"`. Used when uploading.

- upload:

  Logical. If `TRUE`, uploads `txt` and returns URL with `?session=`. If
  `FALSE`, appends `?txt=` directly (not recommended).

- loc:

  Deprecated. Use `session` instead.

- display:

  A named list of display defaults, appended as extra query parameters
  so an API consumer can set them without the end user having to click
  through the site's "Instellingen" panel. Recognised names:

  `interactive`

  : Logical. Show the interactive (plotly) chart instead of the default
    fixed (grid) one.

  `interpolation`

  : Logical. Show the child's curve interpolated between observations.
    Defaults to `TRUE` in the site itself.

  `size`

  : Integer. Display size in pixels (400-1000) of the interactive
    (plotly) chart only – the fixed (grid) chart keeps its own fixed
    sizes, since its server-rendered SVG text doesn't scale with the
    requested width/height.

  Unset elements are omitted, leaving the site's own defaults in place.

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
url <- "https://james.groeidiagrammen.nl/ocpu/library/james/testdata/client3.json"
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

# set display defaults (interactive chart, no interpolation, 600px)
# without the user having to click through Instellingen
site <- request_site(
  sitehost = host, txt = fn,
  display = list(interactive = TRUE, interpolation = FALSE, size = 600)
)
site
# browseURL(site)
} # }
```
