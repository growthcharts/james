# Validates a growth chart code

This function checks whether `chartcode` is a available in the chart
library.

## Usage

``` r
validate_chartcode(chartcode = "", ...)
```

## Arguments

- chartcode:

  Chart code, typically something like `"NMAB"`

- ...:

  Used for authentication

## Value

A logical vector of with `length(chartcode)` elements.

## See also

[`list_charts()`](https://growthcharts.org/james/reference/list_charts.md)
