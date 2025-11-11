# Calculates the next item to administer in an adaptive test to measure the D-score. Uses the previously administered items and item scores as input.

Calculates the next item to administer in an adaptive test to measure
the D-score. Uses the previously administered items and item scores as
input.

## Usage

``` r
dcat_next(
  txt = "",
  instrument = "gs1",
  key = "gsed2510",
  p = 50,
  session = "",
  format = "3.1",
  ...
)
```

## Arguments

- txt:

  A JSON string, URL, or file with BDS data in JSON format. Data should
  conform to the BDS JGZ 3.2.5 specification.

- instrument:

  A character vector with 3-position codes of instruments that should
  match. The default is `instrument = "gs1"` for GSED SF;
  `instrument = NULL` allows for all instruments.

- key:

  String. They key identifies 1) the difficulty estimates pertaining to
  a particular Rasch model, and 2) the prior mean and standard deviation
  of the prior distribution for calculating the D-score. The default key
  `key = "gsed2510"`.

- p:

  percentage to pass the item, difficulty in percentile units.

- session:

  Optional session key if data is already uploaded to `sitehost`.

- format:

  JSON schema version, e.g., `"3.0"`. Used when uploading.

- ...:

  Ignored

## Value

A string of milestones

## Author

Iris Eekhout 2025

## Examples

``` r
txt <- system.file("examples", "example_v3.1.json", package = "bdsreader")
dcat_next(txt = txt, p = 50)
#> [1] "gs1lgc110"
```
