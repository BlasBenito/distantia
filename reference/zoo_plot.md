# Plot Zoo Time Series

Plot Zoo Time Series

## Usage

``` r
zoo_plot(
  x = NULL,
  line_color = NULL,
  line_width = 1,
  xlim = NULL,
  ylim = NULL,
  title = NULL,
  xlab = NULL,
  ylab = NULL,
  text_cex = 1,
  guide = TRUE,
  guide_position = "topright",
  guide_cex = 0.8,
  vertical = FALSE,
  subpanel = FALSE
)
```

## Arguments

- x:

  (required, zoo object) zoo time series. Default: NULL

- line_color:

  (optional, character vector) vector of colors for the distance or cost
  matrix. If NULL, uses an appropriate palette generated with
  [`grDevices::palette.colors()`](https://rdrr.io/r/grDevices/palette.html).
  Default: NULL

- line_width:

  (optional, numeric vector) Width of the time series lines. Default: 1

- xlim:

  (optional, numeric vector) Numeric vector with the limits of the x
  axis. Default: NULL

- ylim:

  (optional, numeric vector) Numeric vector with the limits of the x
  axis. Default: NULL

- title:

  (optional, character string) Main title of the plot. If NULL, it's set
  to the name of the time series. Default: NULL

- xlab:

  (optional, character string) Title of the x axis. Disabled if
  `subpanel` or `vertical` are TRUE. If NULL, the word "Time" is used.
  Default: NULL

- ylab:

  (optional, character string) Title of the x axis. Disabled if
  `subpanel` or `vertical` are TRUE. If NULL, it is left empty. Default:
  NULL

- text_cex:

  (optional, numeric) Multiplicator of the text size. Default: 1

- guide:

  (optional, logical) If TRUE, plots a legend. Default: TRUE

- guide_position:

  (optional, vector of xy coordinates or character string). This is a
  condensed version of the `x` and `y` arguments of the
  [`graphics::legend()`](https://rdrr.io/r/graphics/legend.html)
  function. Coordinates (in the range 0 1) or keyword to position the
  legend. Accepted keywords are: "bottomright", "bottom", "bottomleft",
  "left", "topleft", "top", "topright", "right" and "center". Default:
  "topright".

- guide_cex:

  (optional, numeric) Size of the guide's text and separation between
  the guide's rows. Default: 0.7.

- vertical:

  (optional, logical) For internal use within the package in multipanel
  plots. Switches the plot axes. Disabled if `subpanel = FALSE`.
  Default: FALSE

- subpanel:

  (optional, logical) For internal use within the package in multipanel
  plots. Strips down the plot for a sub-panel. Default: FALSE

## Value

A plot.

## See also

Other zoo_functions:
[`zoo_aggregate()`](https://blasbenito.github.io/distantia/reference/zoo_aggregate.md),
[`zoo_name_clean()`](https://blasbenito.github.io/distantia/reference/zoo_name_clean.md),
[`zoo_name_get()`](https://blasbenito.github.io/distantia/reference/zoo_name_get.md),
[`zoo_name_set()`](https://blasbenito.github.io/distantia/reference/zoo_name_set.md),
[`zoo_permute()`](https://blasbenito.github.io/distantia/reference/zoo_permute.md),
[`zoo_resample()`](https://blasbenito.github.io/distantia/reference/zoo_resample.md),
[`zoo_smooth_exponential()`](https://blasbenito.github.io/distantia/reference/zoo_smooth_exponential.md),
[`zoo_smooth_window()`](https://blasbenito.github.io/distantia/reference/zoo_smooth_window.md),
[`zoo_time()`](https://blasbenito.github.io/distantia/reference/zoo_time.md),
[`zoo_to_tsl()`](https://blasbenito.github.io/distantia/reference/zoo_to_tsl.md),
[`zoo_vector_to_matrix()`](https://blasbenito.github.io/distantia/reference/zoo_vector_to_matrix.md)

## Examples

``` r
#simulate zoo time series
x <- zoo_simulate()

if(interactive()){

  zoo_plot(
    x = x,
    xlab = "Date",
    ylab = "Value",
    title = "My time series"
  )

}
```
