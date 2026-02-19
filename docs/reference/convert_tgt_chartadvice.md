# Derive advice on chart choice from data

The function loads individual data from an url, calculates the chartcode
and returns a list of parsed chartcode and age range of the data. The
function is called at initialization to automate setting of proper chart
and analysis defaults according to the child data.

## Usage

``` r
convert_tgt_chartadvice(
  txt = "",
  session = "",
  format = "1.0",
  chartcode = "",
  selector = c("data", "chartcode"),
  loc = "",
  ind_loc = "",
  ...
)
```

## Arguments

- txt:

  A JSON string, URL, or file with BDS data in JSON format. Data should
  conform to the BDS JGZ 3.2.5 specification.

- session:

  OpenCPU session key with the uploaded data

- format:

  JSON schema version, e.g., `"3.0"`. Used when uploading.

- chartcode:

  Optional. The code of the requested growth chart.

- selector:

  Either `"chartcode"`, `"data"` or `"derive"`. The function can
  calculate the chart code by looking at the child data (method
  `"data"`) or user input (method `"derive"`). More in detail, the
  following behaviour decides between growth charts:

  `"data"`

  :   Calculate chart code from the individual data. This setting
      chooses the "optimal" chart for a given individual set of data.

  `"derive"`

  :   Calculate chart code from a combination of user data: `chartgrp`,
      `agegrp`, `side`, `sex`, `etn`, `ga`. The method does not use
      individual data. Use this setting when chart choice needs to be
      reactive on user input.

  `"chartcode"`

  :   Take string specified in `chartcode`

  If there is a valid `tgt` object, then the function simply obeys the
  `selector` setting. If no valid `tgt` object is found, the
  `"chartcode"` argument is taken. However, if the `"chartcode"` is
  empty, then the function selects method `"derive"`.

- loc:

  Deprecated. Use `session` instead.

- ind_loc:

  Legacy. Will disappear in Nov 2022. Use `loc` instead.

- ...:

  Ignored

## Value

A list with the following elements

- `population`:

  A string identifying the population, e.g. `'NL'`,`'MA'`, `'TU'` or
  `'PT'`.

- `sex`:

  A string `"male"`, `"female"` or `"undifferentiated"`.

- `design`:

  A letter indicating the chart design: `'A'` = 0-15m, `'B'` = 0-4y,
  `'C'` = 1-21y, `'D'` = 0-21y, `'E'` = 0-4ya.

- `side`:

  A string indicating the side or `yname`: `'front'`, `'back'`,
  `'both'`, `'hgt'`, `'wgt'`, `'hdc'`, `'bmi'`, `'wfh'`

- `language`:

  The language in which the chart is drawn. Currently only `"dutch"`
  charts are implemented, but for `population == "PT"` we may also have
  `"english"`.

- `week`:

  A scalar indicating the gestational age at birth. Only used if
  `population == "PT"`.

- `chartcode`:

  A string indicating the chart code.

- `chartgrp`:

  A string indicating the chart group, either `"nl2010"`, `"preterm"`,
  `"who"`, `"gsed1"`, `"gsed1pt"`.

- `agegrp`:

  A string indicating the age group, either `"0-15m"`, `"0-4y"`,
  `"1-21y"` or `"0-21y"`.

- `dnr`:

  A string indicating the donor dataset for matching, either `"smocc"`,
  `"lollypop"`, `"terneuzen"` or `"pops"`.

- `slider_list`:

  A string indicating the set of slider labels, either `"0_2"`, `"0_4"`
  or `"0_29"`.

- `period`:

  A character vector of two elements, indicating the first and last
  period for the matching analysis, e.g. like `c("3m", "14m")`.

## See also

[`chartcatalog::parse_chartcode()`](https://rdrr.io/pkg/chartcatalog/man/parse_chartcode.html)

## Author

Stef van Buuren 2020

## Examples

``` r
test25 <- system.file("extdata/bds_v3.0/test/test25.json", package = "jamesdemodata")
james:::convert_tgt_chartadvice(txt = test25)
#> $population
#> [1] "WHOpink"
#> 
#> $sex
#> [1] "female"
#> 
#> $design
#> [1] "A"
#> 
#> $side
#> [1] "dsc"
#> 
#> $language
#> [1] "dutch"
#> 
#> $week
#> [1] 39
#> 
#> $chartcode
#> [1] "WMADN40"
#> 
#> $chartgrp
#> [1] "who"
#> 
#> $agegrp
#> [1] "0-15m"
#> 
#> $dnr
#> [1] "0-2"
#> 
#> $slider_list
#> [1] "0_2"
#> 
#> $period
#> [1] "14m" "14m"
#> 
#> $accordion
#> [1] "ontwikkeling"
#> 
```
