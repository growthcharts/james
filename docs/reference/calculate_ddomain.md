# Calculates the domain specific D-score and DAZ for each visit

The function `calculate_ddomain()` calculates five domain scores for the
D-score. Note that the domain scores may be highly variable due to the
small number of items per domain.

## Usage

``` r
calculate_ddomain(
  txt = "",
  session = "",
  format = "3.1",
  append = c("ddi", "gs1"),
  key = NULL,
  population = NULL,
  set = "GFCLS",
  domain = NULL,
  loc = "",
  ...
)
```

## Arguments

- txt:

  A JSON string, URL, or file with BDS data in JSON format. Data should
  conform to the BDS JGZ 3.2.5 specification.

- session:

  Optional session key if data is already uploaded to `sitehost`.

- format:

  JSON schema version, e.g., `"3.0"`. Used when uploading.

- append:

  Optional vector of strings indicating which instrument to base D-score
  calculations on. Currently supports `ddi` and `gs1`. Requires JSON
  schema V3.0 or later.

- key:

  String. They key identifies 1) the difficulty estimates pertaining to
  a particular Rasch model, and 2) the prior mean and standard deviation
  of the prior distribution for calculating the D-score. The default key
  `NULL` sets `key = "gsed2510"`. View `builtin_keys` for an overview of
  the available keys.

- population:

  String. The name of the reference population to calculate DAZ. Use
  `with(builtin_references, table(key, population))` to see which
  built-in references are available for `key - population` combinations.
  If not specified, the function set the default population as
  `builtin_keys$base_population[key == builtin_keys$key]`.

- set:

  String. The name of the set of domains to use. See
  `with(builtin_domaintable, table(set, domain))` for the domain names
  in each set.

- domain:

  character vector of the name of the domain(s) for which to compute the
  domain score. Per default all domains in the `set` are used .

- loc:

  Deprecated. Use `session` instead.

- ...:

  Ignored

## Value

A list of data.frames.

## Author

Iris Eekhout 2025

## Examples

``` r
fn <- system.file("testdata", "Laura_S.json", package = "james")
df <- calculate_dscore(txt = fn)
head(df, 4)
#> [1] a   n   p   d   sem daz
#> <0 rows> (or 0-length row.names)
```
