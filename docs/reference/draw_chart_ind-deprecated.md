# Draw growth chart with individual data

The function `draw_chart_ind()` expect an input location from a previous
call, and plots the individual data on the requested growth chart.

## Usage

``` r
draw_chart_ind(loc = "", chartcode = "", curve_interpolation = TRUE, ...)
```

## Arguments

- loc:

  Deprecated. Use `session` instead.

- chartcode:

  Optional. The code of the requested growth chart.

- curve_interpolation:

  A logical indicating whether curve interpolation shoud be applied.

- ...:

  Ignored

## Note

Deprecated. Please use the more comprehensive
[`draw_chart()`](https://growthcharts.org/james/reference/draw_chart.md)
function.

## See also

[`select_chart()`](https://growthcharts.org/james/reference/select_chart.md)
[`chartplotter::process_chart()`](https://rdrr.io/pkg/chartplotter/man/process_chart.html)
