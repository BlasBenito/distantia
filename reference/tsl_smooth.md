# Smoothing of Time Series Lists

Rolling-window and exponential smoothing of Time Series Lists.

Rolling-window smoothing This computes a statistic over a fixed-width
window of consecutive cases and replaces each central value with the
computed statistic. It is commonly used to mitigate noise in
high-frequency time series.

Exponential smoothing computes each value as the weighted average of the
current value and past smoothed values. This method is useful for
reducing noise in time series data while preserving the overall trend.

This function supports a parallelization setup via
[`future::plan()`](https://future.futureverse.org/reference/plan.html),
and progress bars provided by the package
[progressr](https://CRAN.R-project.org/package=progressr).

## Usage

``` r
tsl_smooth(tsl = NULL, window = 3, f = mean, alpha = NULL, ...)
```

## Arguments

- tsl:

  (required, list) Time series list. Default: NULL

- window:

  (optional, integer) Smoothing window width, in number of cases.
  Default: 3

- f:

  (optional, quoted or unquoted function name) Name of a standard or
  custom function to aggregate numeric vectors. Typical examples are
  `mean`, `max`,`min`, `median`, and `quantile`. Default: `mean`.

- alpha:

  (required, numeric) Exponential smoothing factor in the range (0, 1\].
  Determines the weight of the current value relative to past values. If
  not NULL, the arguments `window` and `f` are ignored, and exponential
  smoothing is performed instead. Default: NULL

- ...:

  (optional, additional arguments) additional arguments to `f`.

## Value

time series list

## See also

Other tsl_processing:
[`tsl_aggregate()`](https://blasbenito.github.io/distantia/reference/tsl_aggregate.md),
[`tsl_resample()`](https://blasbenito.github.io/distantia/reference/tsl_resample.md),
[`tsl_stats()`](https://blasbenito.github.io/distantia/reference/tsl_stats.md),
[`tsl_transform()`](https://blasbenito.github.io/distantia/reference/tsl_transform.md)

## Examples

``` r

tsl <- tsl_simulate(n = 2)

#rolling window smoothing
tsl_smooth <- tsl_smooth(
  tsl = tsl,
  window = 5,
  f = mean
)

if(interactive()){
  tsl_plot(tsl)
  tsl_plot(tsl_smooth)
}

#exponential smoothing
tsl_smooth <- tsl_smooth(
  tsl = tsl,
  alpha = 0.2
)

if(interactive()){
  tsl_plot(tsl)
  tsl_plot(tsl_smooth)
}
```
