# List the available growth screeners

List the available growth screeners

## Usage

``` r
list_screeners(ynames = c("hgt", "wgt", "hdc"), ...)
```

## Arguments

- ynames:

  Character vector identifying the measures to be screened. By default,
  `ynames = c("hgt", "wgt", "hdc")`.

- ...:

  Used for authentication, passed down to
  [`growthscreener::list_screeners()`](https://growthcharts.org/growthscreener/reference/list_screeners.html).

## Examples

``` r
head(list_screeners(ynames = "hgt"), 2)
#>   Versie yname Categorie CategorieOmschrijving                   JGZRichtlijn
#> 1 1.24.0   hgt      1000  Lengte naar leeftijd JGZ-Richtlijn Lengtegroei 2019
#> 2 1.24.0   hgt      1000  Lengte naar leeftijd JGZ-Richtlijn Lengtegroei 2019
#>   Code                                                    CodeOmschrijving
#> 1 1010   Het advies kan niet worden bepaald. Voer de zwangerschapsduur in.
#> 2 1011 Het advies kan niet worden bepaald. Voer de vorige lengtemeting in.
```
