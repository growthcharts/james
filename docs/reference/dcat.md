# Applies the adaptive test algorithm to determine the next step: administer the next item or stop test and return D-score.

Applies the adaptive test algorithm to determine the next step:
administer the next item or stop test and return D-score.

## Usage

``` r
dcat(
  txt = "",
  instrument = "gs1",
  key = NULL,
  population = NULL,
  p = 50,
  min_length = 0,
  sem_rule = 1.726,
  session = "",
  format = "3.1",
  ...
)
```

## Arguments

- txt:

  A JSON string, URL or file

- instrument:

  character vector with instrument names to use to select items

- key:

  String. They key identifies 1) the difficulty estimates pertaining to
  a particular Rasch model, and 2) the prior mean and standard deviation
  of the prior distribution for calculating the D-score. The default key
  `NULL` sets `key = "gsed2510"`. View
  [`dscore::builtin_keys`](https://d-score.github.io/dscore/reference/builtin_keys.html)
  for an overview of the available keys.

- population:

  String. Name of the reference population

- p:

  percentage to pass the item, difficulty in percentile units

- min_length:

  numeric value for minimum number of items to administer, default is
  set to `min_length = 0`.

- sem_rule:

  numeric target for sem can be estimated based on Cohen's d from
  `sem_rule()`.

- session:

  Optional session key if data is already uploaded to `sitehost`.

- format:

  String. JSON data schema version number. There are currently three
  schemas supported: `"1.0"`, `"1.1"`, `"2.0"`, `"3.0"` and `"3.1"`.
  Formats `"1.0"` and `"1.1"` are included for backward compatibility
  only. Use `format = "3.1"` for new applications.

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
#> [1] "gs1lgc119"
txt <- "~/OneDrive - TNO/Documents/GitHub/james/data-raw/test_data.json"
dcat(txt = txt, p = 50)
#> [1] "gs1cgc127"
```
