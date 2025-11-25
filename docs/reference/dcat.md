# Applies the adaptive test algorithm to determine the next step: administer the next item or stop test and return D-score.

Applies the adaptive test algorithm to determine the next step:
administer the next item or stop test and return D-score.

## Usage

``` r
dcat(
  txt = "",
  instrument = "gs1",
  key = "gsed2510",
  population = NULL,
  p = 50,
  sem_rule = 1.726,
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

- sem_rule:

  numeric target for sem can be estimated based on Cohen's d from
  `sem_rule()`.

- session:

  Optional session key if data is already uploaded to `sitehost`.

- format:

  JSON schema version, e.g., `"3.0"`. Used when uploading.

- ...:

  Ignored

## Value

A string with an item name or a table.

## Author

Iris Eekhout 2025

## Examples

``` r
txt <- system.file("examples", "example_v3.1.json", package = "bdsreader")
dcat(txt = txt, p = 50)
#> [1] "gs1lgc110"
```
