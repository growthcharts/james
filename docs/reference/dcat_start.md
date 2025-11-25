# Calculates the start item from age for an adaptive test to measure D-score.

Calculates the start item from age for an adaptive test to measure
D-score.

## Usage

``` r
dcat_start(
  txt = "",
  instrument = "gs1",
  key = "gsed2510",
  population = "",
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

- population:

  String. Name of the reference population.

- p:

  percentage to pass the item, difficulty in percentile units.

- session:

  Optional session key if data is already uploaded to `sitehost`.

- format:

  JSON schema version, e.g., `"3.0"`. Used when uploading.

- ...:

  Ignored

## Value

A string of milestones.

## Author

Iris Eekhout 2025

## Examples

``` r
fn <- system.file("examples", "example_v3.1.json", package = "bdsreader")
dcat_start(txt = fn, p = 50)
#>                item
#> gs1cgc128 gs1cgc128
#>                                                                                                                                                                                                                label
#> gs1cgc128 SF128 Does your child understand the term 'longest'? For example, if you ask him/her to choose 'which is the longest of 3 objects?' (e.g. 3 spoons or sticks), would he/she be able to choose the longest?
#>             tau
#> gs1cgc128 73.47
```
