# Preview growth screener results at every measurement occasion

Experimental "Proeftuin" endpoint: unlike
[`apply_screeners()`](https://growthcharts.org/james/reference/apply_screeners.md),
which screens once using the single most recent measurement per `yname`
(with all earlier ones as context), this re-screens at every occasion,
truncating the time series to that occasion and treating it as if it
were the most recent one. This surfaces how the advice for each measure
would have read at each point in time, not just the current one.

## Usage

``` r
preview_screeners(
  txt = "",
  session = "",
  format = "1.0",
  ynames = c("hgt", "wgt", "hdc"),
  na.omit = TRUE,
  ...
)
```

## Arguments

- txt:

  A JSON string, URL or file

- session:

  Optional session key if data is already uploaded to `sitehost`.

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

## Value

A data frame with one row per (measure, occasion) combination, sorted by
`CategorieOmschrijving` and descending `Leeftijd` (most recent occasion
first).

## See also

[`apply_screeners()`](https://growthcharts.org/james/reference/apply_screeners.md)

## Author

Stef van Buuren 2026

## Examples

``` r
fn <- system.file("testdata", "client3.json", package = "james")
preview_screeners(fn)
#>   Categorie CategorieOmschrijving Code
#> 5      2000               Gewicht 2031
#> 4      2000               Gewicht 2013
#> 3      2000               Gewicht 2012
#> 7      3000           Hoofdomtrek 3031
#> 6      3000           Hoofdomtrek 3022
#> 2      1000                Lengte 1031
#> 1      1000                Lengte 1025
#>                                                                 CodeOmschrijving
#> 5                In principe geen verwijzing nodig, naar eigen inzicht handelen.
#> 4   Het advies kan niet worden bepaald. Voer de lengte bij de eerdere meting in.
#> 3 Het advies kan niet worden bepaald. Voer het gewicht bij de eerdere meting in.
#> 7                In principe geen verwijzing nodig, naar eigen inzicht handelen.
#> 6  Het advies kan niet worden bepaald.  Voer de datum van een eerdere meting in.
#> 2                In principe geen verwijzing nodig, naar eigen inzicht handelen.
#> 1                                 Kan de SDS van de eerdere meting niet bepalen.
#>   Versie Leeftijd
#> 5 1.28.0   0.1670
#> 4 1.28.0   0.0849
#> 3 1.28.0   0.0000
#> 7 1.28.0   0.1670
#> 6 1.28.0   0.0849
#> 2 1.28.0   0.1670
#> 1 1.28.0   0.0849
```
