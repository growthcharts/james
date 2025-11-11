# Selects the growth chart

This function controls the behaviour for selecting a specific growth
chart based on a combination of individual data and user settings. The
default behaviour select preterm chart if gestational age is lower or
equal to 36 weeks, and determines the age group by the maximum age found
in the data.

## Usage

``` r
select_chart(
  target = NULL,
  chartgrp = NULL,
  agegrp = NULL,
  sex = NULL,
  etn = NULL,
  ga = NULL,
  side = NULL,
  language = "dutch"
)
```

## Arguments

- target:

  A list with elements `psn` (persondata) and `xyz` (timedata).

- chartgrp:

  The chart group: `'nl2010'`, `'preterm'`, `'who'`, `'gsed1'`,
  `'gsed1pt'` or `character(0)`

- agegrp:

  Either `'0-15m'`, `'0-4y'`, `'1-21y'`, `'0-21y'` or `'0-4ya'`. Age
  group `'0-4ya'` provides the 0-4 chart with weight for age (design E).

- sex:

  Either `'male'` or `'female'`

- etn:

  Either `'netherlands'`, `'turkish'`, `'moroccan'` or `'hindustani'`

- ga:

  Gestational age (in completed weeks)

- side:

  Either `'front'`, `'back'`, `'-hdc'` or `'both'`

- language:

  Language: `'dutch'` or `'english'` (not used)

## Value

A list with elements `chartgrp`, `chartcode` and `ga`

## See also

[`chartcatalog::create_chartcode()`](https://rdrr.io/pkg/chartcatalog/man/create_chartcode.html)
