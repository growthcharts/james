# Preview the child data JAMES uses internally

Experimental "Proeftuin" endpoint: returns the person- or time-level
data exactly as `bdsreader` parses it, for inspection in the app.

## Usage

``` r
preview_persondata(txt = "", session = "", format = "1.0", ...)

preview_timedata(txt = "", session = "", format = "1.0", ...)
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

- ...:

  Ignored

## Value

A data frame.

## See also

[`bdsreader::persondata()`](https://rdrr.io/pkg/bdsreader/man/persondata.html),
[`bdsreader::timedata()`](https://rdrr.io/pkg/bdsreader/man/timedata.html)

## Author

Stef van Buuren 2026

## Examples

``` r
fn <- system.file("testdata", "client3.json", package = "james")
preview_persondata(fn)
#> # A tibble: 1 × 16
#>      id name      dob        dobf       dobm       src   dnr   sex     gad    ga
#>   <int> <chr>     <date>     <date>     <date>     <chr> <chr> <chr> <dbl> <dbl>
#> 1    -1 fa308134… 2018-10-11 1995-07-04 1990-12-02 1234  NA    fema…   189    27
#> # ℹ 6 more variables: smo <int>, bw <dbl>, hgtm <dbl>, hgtf <dbl>, agem <dbl>,
#> #   etn <chr>
preview_timedata(fn)
#> # A tibble: 11 × 8
#>       age xname yname zname zref                        x     y      z
#>     <dbl> <chr> <chr> <chr> <chr>                   <dbl> <dbl>  <dbl>
#>  1 0.167  age   bmi   bmi_z nl_1997_bmi_female_nl  0.167  11.1  -3.77 
#>  2 0.0849 age   bmi   bmi_z nl_1997_bmi_female_nl  0.0849  8.66 -5.72 
#>  3 0.167  age   hdc   hdc_z nl_2012_hdc_female_27  0.167  30.5  -0.913
#>  4 0.0849 age   hdc   hdc_z nl_2012_hdc_female_27  0.0849 27    -0.709
#>  5 0.167  age   hgt   hgt_z nl_2012_hgt_female_27  0.167  43.5   0.047
#>  6 0.0849 age   hgt   hgt_z nl_2012_hgt_female_27  0.0849 38    -0.158
#>  7 0.167  hgt   wfh   wfh_z nl_2012_wfh_female_   43.5     2.1   0.326
#>  8 0.0849 hgt   wfh   wfh_z nl_2012_wfh_female_   38       1.25 -0.001
#>  9 0.167  age   wgt   wgt_z nl_2012_wgt_female_27  0.167   2.1   0.015
#> 10 0.0849 age   wgt   wgt_z nl_2012_wgt_female_27  0.0849  1.25 -0.203
#> 11 0      age   wgt   wgt_z nl_2012_wgt_female_27  0       0.99  0.19 
preview_persondata()
#> data frame with 0 columns and 0 rows
```
