# Screen growth curves according to JGZ guidelines

Screen growth curves according to JGZ guidelines

## Usage

``` r
screen_growth(
  txt = "",
  loc = "",
  format = "1.0",
  ynames = c("hgt", "wgt", "hdc"),
  na.omit = TRUE,
  ...
)
```

## Arguments

- txt:

  A JSON string, URL or file

- loc:

  Deprecated. Use `session` instead.

- format:

  String. JSON data schema version number. There are currently three
  schemas supported: `"1.0"`, `"1.1"`, `"2.0"`, `"3.0"` and `"3.1"`.
  Formats `"1.0"` and `"1.1"` are included for backward compatibility
  only. Use `format = "3.1"` for new applications.

- ynames:

  Character vector identifying the measures to be screened. By default,
  `ynames = c("hgt", "wgt", "hdc")`.

- na.omit:

  A logical indicating whether records with a missing `x` (age) or `y`
  (yname) should be removed. Defaults to `TRUE`.

- ...:

  Ignored

## Examples

``` r
host <- "http://localhost:8080"
fn <- system.file("testdata", "client3.json", package = "james")

if (FALSE) { # \dontrun{
# first upload, then screen
r1 <- jamesclient::james_post(path = "data/upload", txt = fn)
location <- jamesclient::get_url(r1, "location")
location
screen_growth(loc = location)

session <- jamesclient::get_url(r1, "session")
session
screen_growth(session = session)

# upload & screen
screen_growth(fn)
} # }
```
