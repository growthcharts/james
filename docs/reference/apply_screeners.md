# Apply growth screeners to child data

Apply growth screeners to child data

## Usage

``` r
apply_screeners(
  txt = "",
  session = "",
  format = "1.0",
  ynames = c("hgt", "wgt", "hdc"),
  na.omit = TRUE,
  loc = "",
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

- loc:

  Deprecated. Use `session` instead.

- ...:

  Ignored

## Note

`apply_screeners()` supersedes
[`screen_growth()`](https://growthcharts.org/james/reference/screen_growth-deprecated.md)
and
[`screen_curves()`](https://growthcharts.org/james/reference/screen_curves-deprecated.md).

## Examples

``` r
fn <- system.file("testdata", "client3.json", package = "james")
apply_screeners(fn)
#>   Categorie CategorieOmschrijving Code
#> 1      1000                Lengte 1031
#> 2      2000               Gewicht 2031
#> 3      3000           Hoofdomtrek 3031
#>                                                                                                                CodeOmschrijving
#> 1 Het advies volgens de JGZ-richtlijn lengtegroei is als volgt: In principe geen verwijzing nodig, naar eigen inzicht handelen.
#> 2 Het advies volgens de JGZ-richtlijn overgewicht is als volgt: In principe geen verwijzing nodig, naar eigen inzicht handelen.
#> 3                                                               In principe geen verwijzing nodig, naar eigen inzicht handelen.
#>   Versie Leeftijd
#> 1 1.24.0    0.167
#> 2 1.24.0    0.167
#> 3 1.24.0    0.167
if (FALSE) { # \dontrun{
# first upload, then screen
library(jamesclient)
r1 <- james_post(path = "data/upload/json", txt = fn)
r2 <- james_post(path = "screeners/apply/json", loc = r1$location)
r3 <- james_post(path = "screeners/apply/json", session = r1$session)
} # }
```
