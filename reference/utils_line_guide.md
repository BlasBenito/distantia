# Guide for Time Series Plots

Guide for Time Series Plots

## Usage

``` r
utils_line_guide(
  x = NULL,
  position = "topright",
  line_color = NULL,
  line_width = 1,
  length = 1,
  text_cex = 0.7,
  guide_columns = 1,
  subpanel = FALSE
)
```

## Arguments

- x:

  (required, sequence) a zoo time series or a time series list. Default:
  NULL

- position:

  (optional, vector of xy coordinates or character string). This is a
  condensed version of the `x` and `y` arguments of the
  [`graphics::legend()`](https://rdrr.io/r/graphics/legend.html)
  function. Coordinates (in the range 0 1) or keyword to position the
  legend. Accepted keywords are: "bottomright", "bottom", "bottomleft",
  "left", "topleft", "top", "topright", "right" and "center". Default:
  "topright".

- line_color:

  (optional, character vector) vector of colors for the time series
  columns. If NULL, uses the palette "Zissou 1" provided by the function
  [`grDevices::hcl.colors()`](https://rdrr.io/r/grDevices/palettes.html).
  Default: NULL

- line_width:

  (optional, numeric vector) Widths of the time series lines. Default: 1

- length:

  (optional, numeric) maps to the argument `seg.len` of
  [`graphics::legend()`](https://rdrr.io/r/graphics/legend.html). Length
  of the lines drawn in the legend. Default: 1

- text_cex:

  (optional, numeric) Multiplier of the text size. Default: 0.7

- guide_columns:

  (optional, integer) Number of columns in which to set the legend
  items. Default: 1.

- subpanel:

  (optional, logical) internal argument used when generating the
  multipanel plot produced by
  [`distantia_dtw_plot()`](https://blasbenito.github.io/distantia/reference/distantia_dtw_plot.md).

## Value

plot

## See also

Other internal_plotting:
[`color_continuous()`](https://blasbenito.github.io/distantia/reference/color_continuous.md),
[`color_discrete()`](https://blasbenito.github.io/distantia/reference/color_discrete.md),
[`utils_color_breaks()`](https://blasbenito.github.io/distantia/reference/utils_color_breaks.md),
[`utils_line_color()`](https://blasbenito.github.io/distantia/reference/utils_line_color.md),
[`utils_matrix_guide()`](https://blasbenito.github.io/distantia/reference/utils_matrix_guide.md),
[`utils_matrix_plot()`](https://blasbenito.github.io/distantia/reference/utils_matrix_plot.md)

## Examples

``` r
x <- zoo_simulate()

if(interactive()){

  zoo_plot(x, guide = FALSE)

  utils_line_guide(
    x = x,
    position = "right"
  )

}
```
