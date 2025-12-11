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
#> gs1lgc136 gs1lgc136
#>                                                                                                                                                                                    label
#> gs1lgc136 SF136 Can your child talk about things that will happen in the future using correct language (e.g., "Tomorrow he will attend school" or "Next week we will go to the market")?
#>             tau
#> gs1lgc136 74.65
```
