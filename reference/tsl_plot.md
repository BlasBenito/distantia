# Plot Time Series List

Plot Time Series List

## Usage

``` r
tsl_plot(
  tsl = NULL,
  columns = 1,
  xlim = NULL,
  ylim = "absolute",
  line_color = NULL,
  line_width = 1,
  text_cex = 1,
  guide = TRUE,
  guide_columns = 1,
  guide_cex = 0.8
)
```

## Arguments

- tsl:

  (required, list) Time series list. Default: NULL

- columns:

  (optional, integer) Number of columns of the multipanel plot. Default:
  1

- xlim:

  (optional, numeric vector) Numeric vector with the limits of the x
  axis. Applies to all sequences. Default: NULL

- ylim:

  (optional, numeric vector or character string) Numeric vector of
  length two with the limits of the vertical axis or a keyword. Accepted
  keywords are:

  - "absolute" (default): all time series are plotted using the overall
    data range. When this option is used, horizontal lines indicating
    the overall mean, minimum, and maximum are shown as reference.

  - "relative": each time series is plotted using its own range.
    Equivalent result can be achieved using `ylim = NULL`.

- line_color:

  (optional, character vector) vector of colors for the distance or cost
  matrix. If NULL, uses an appropriate palette generated with
  [`grDevices::palette.colors()`](https://rdrr.io/r/grDevices/palette.html).
  Default: NULL

- line_width:

  (optional, numeric vector) Width of the time series plot. Default: 1

- text_cex:

  (optional, numeric) Multiplicator of the text size. Default: 1

- guide:

  (optional, logical) If TRUE, plots a legend. Default: TRUE

- guide_columns:

  (optional, integer) Columns of the line guide. Default: 1.

- guide_cex:

  (optional, numeric) Size of the guide's text and separation between
  the guide's rows. Default: 0.7.

## Value

plot

## Examples

``` r
#simulate zoo time series
tsl <- tsl_simulate(
  cols = 3
  )

if(interactive()){

  #default plot
  tsl_plot(
    tsl = tsl
    )

  #relative vertical limits
  tsl_plot(
    tsl = tsl,
    ylim = "relative"
  )

  #changing layout
  tsl_plot(
    tsl = tsl,
    columns = 2,
    guide_columns = 2
  )

  #no legend
  tsl_plot(
    tsl = tsl,
    guide = FALSE
  )

  #changing color
  tsl_plot(
    tsl = tsl,
    line_color = c("red", "green", "blue"))

}
```
