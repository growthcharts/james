# Provides a Screen growth curves according to JGZ guidelines

Provides a Screen growth curves according to JGZ guidelines

## Usage

``` r
custom_list(txt = "", session = "", format = "1.0", loc = "", ...)
```

## Arguments

- txt:

  A JSON string, URL, or file with BDS data in JSON format. Data should
  conform to the BDS JGZ 3.2.5 specification.

- session:

  Optional session key if data is already uploaded to `sitehost`.

- format:

  JSON schema version, e.g., `"3.0"`. Used when uploading.

- loc:

  Deprecated. Use `session` instead.

- ...:

  Ignored

## Value

A table with screening results

A list with custom parts

## Examples

``` r
fn <- system.file("extdata", "bds_v2.0", "smocc", "Laura_S.json", package = "jamesdemodata")
host <- "http://localhost:8080"
if (FALSE) { # \dontrun{
# first upload, then create custom list
r1 <- jamesclient::james_post(host = host, path = "data/upload", txt = fn)
loc <- jamesclient::get_url(r1, "location")
list1 <- custom_list(loc = loc)

# upload & screen
list2 <- custom_list(txt = fn)
identical(list1, list2)
} # }
```
