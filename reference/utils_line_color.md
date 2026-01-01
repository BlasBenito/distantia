# Handles Line Colors for Sequence Plots

This is an internal function, but can be used to better understand how
line colors are handled within other plotting functions.

## Usage

``` r
utils_line_color(x = NULL, line_color = NULL)
```

## Arguments

- x:

  (required, sequence) zoo object or time series list. Default: NULL

- line_color:

  (optional, character vector) vector of colors for the time series
  columns. Selected palette depends on the number of columns to plot.
  Default: NULL

## Value

color vector

## See also

Other internal_plotting:
[`color_continuous()`](https://blasbenito.github.io/distantia/reference/color_continuous.md),
[`color_discrete()`](https://blasbenito.github.io/distantia/reference/color_discrete.md),
[`utils_color_breaks()`](https://blasbenito.github.io/distantia/reference/utils_color_breaks.md),
[`utils_line_guide()`](https://blasbenito.github.io/distantia/reference/utils_line_guide.md),
[`utils_matrix_guide()`](https://blasbenito.github.io/distantia/reference/utils_matrix_guide.md),
[`utils_matrix_plot()`](https://blasbenito.github.io/distantia/reference/utils_matrix_plot.md)
