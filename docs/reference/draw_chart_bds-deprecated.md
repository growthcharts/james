# Convert bds-format data to individual and return growth chart

The function `draw_chart_bds()` convert bds data into an object of class
individual, and then draws the individual data on the requested growth
chart. Superseded by
[`draw_chart()`](https://growthcharts.org/james/reference/draw_chart.md).

## Usage

``` r
draw_chart_bds(
  txt = "",
  format = "1.0",
  chartcode = "",
  curve_interpolation = TRUE,
  selector = "chartcode",
  ...
)
```

## Arguments

- txt:

  A JSON string, URL or file

- format:

  String. JSON data schema version number. There are currently three
  schemas supported: `"1.0"`, `"1.1"`, `"2.0"`, `"3.0"` and `"3.1"`.
  Formats `"1.0"` and `"1.1"` are included for backward compatibility
  only. Use `format = "3.1"` for new applications.

- chartcode:

  A string with chart code

- curve_interpolation:

  A logical indicating whether curve interpolation shoud be applied.

- selector:

  Legacy addition to solve a problem in jgzApp. See `draw_chart` for
  interpretation. The default is set to `"chartcode"`.

- ...:

  For `draw_chart_bds`, additional parameter passed down to
  `fromJSON(txt, ...)`, `new("xyz",... )` and `new("bse",... )`. Useful
  parameters are `models = "bsmodel"` for setting the broken stick
  model, or `call = as.call(...)` for setting proper reference
  standards.

## Examples

``` r
fn <- system.file("testdata", "client3.json", package = "james")
g <- draw_chart_bds(txt = fn)
#> Warning: draw_chart_bds() is deprecated and will disappear in Nov 2022. Please use draw_chart() instead.
```
