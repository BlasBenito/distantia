# Resample Zoo Objects to a New Time

**Objective**

Time series resampling involves interpolating new values for time steps
not available in the original time series. This operation is useful to:

- Transform irregular time series into regular.

- Align time series with different temporal resolutions.

- Increase (upsampling) or decrease (downsampling) the temporal
  resolution of a time series.

On the other hand, time series resampling **should not be used** to
extrapolate new values outside of the original time range of the time
series, or to increase the resolution of a time series by a factor of
two or more. These operations are known to produce non-sensical results.

**Methods** This function offers three methods for time series
interpolation:

- "linear" (default): interpolation via piecewise linear regression as
  implemented in
  [`zoo::na.approx()`](https://rdrr.io/pkg/zoo/man/na.approx.html).

- "spline": cubic smoothing spline regression as implemented in
  [`stats::smooth.spline()`](https://rdrr.io/r/stats/smooth.spline.html).

- "loess": local polynomial regression fitting as implemented in
  [`stats::loess()`](https://rdrr.io/r/stats/loess.html).

These methods are used to fit models `y ~ x` where `y` represents the
values of a univariate time series and `x` represents a numeric version
of its time.

The functions
[`utils_optimize_spline()`](https://blasbenito.github.io/distantia/reference/utils_optimize_spline.md)
and
[`utils_optimize_loess()`](https://blasbenito.github.io/distantia/reference/utils_optimize_loess.md)
are used under the hood to optimize the complexity of the methods
"spline" and "loess" by finding the configuration that minimizes the
root mean squared error (RMSE) between observed and predicted `y`.
However, when the argument `max_complexity = TRUE`, the complexity
optimization is ignored, and a maximum complexity model is used instead.

**New time**

The argument `new_time` offers several alternatives to help define the
new time of the resulting time series:

- `NULL`: the target time series (`x`) is resampled to a regular time
  within its original time range and number of observations.

- `zoo object`: a zoo object to be used as template for resampling.
  Useful when the objective is equalizing the frequency of two separate
  zoo objects.

- `time vector`: a time vector of a class compatible with the time in
  `x`.

- `keyword`: character string defining a resampling keyword, obtained
  via `zoo_time(x, keywords = "resample")$keywords`..

- `numeric`: a single number representing the desired interval between
  consecutive samples in the units of `x` (relevant units can be
  obtained via `zoo_time(x)$units`).

**Step by Step**

The steps to resample a time series list are:

1.  The time interpolation range taken from the index of the zoo object.
    This step ensures that no extrapolation occurs during resampling.

2.  If `new_time` is provided, any values of `new_time` outside of the
    minimum and maximum interpolation times are removed to avoid
    extrapolation. If `new_time` is not provided, a regular time within
    the interpolation time range of the zoo object is generated.

3.  For each univariate time time series, a model `y ~ x`, where `y` is
    the time series and `x` is its own time coerced to numeric is
    fitted.

    - If `max_complexity == FALSE` and `method = "spline"` or
      `method = "loess"`, the model with the complexity that minimizes
      the root mean squared error between the observed and predicted `y`
      is returned.

    - If `max_complexity == TRUE` and `method = "spline"` or
      `method = "loess"`, the first valid model closest to a maximum
      complexity is returned.

4.  The fitted model is predicted over `new_time` to generate the
    resampled time series.

**Other Details**

Please use this operation with care, as there are limits to the amount
of resampling that can be done without distorting the data. The safest
option is to keep the distance between new time points within the same
magnitude of the distance between the old time points.

## Usage

``` r
zoo_resample(
  x = NULL,
  new_time = NULL,
  method = "linear",
  max_complexity = FALSE
)
```

## Arguments

- x:

  (required, zoo object) Time series to resample. Default: NULL

- new_time:

  (optional, zoo object, keyword, or time vector) New time to resample
  `x` to. The available options are:

  - NULL: a regular version of the time in `x` is generated and used for
    resampling.

  - zoo object: the index of the given zoo object is used as template to
    resample `x`.

  - time vector: a vector with new times to resample `x` to. If time in
    `x` is of class "numeric", this vector must be numeric as well.
    Otherwise, vectors of classes "Date" and "POSIXct" can be used
    indistinctly.

  - keyword: a valid keyword returned by `zoo_time(x)$keywords`, used to
    generate a time vector with the relevant units.

  - numeric of length 1: interpreted as new time interval, in the
    highest resolution units returned by `zoo_time(x)$units`.

- method:

  (optional, character string) Name of the method to resample the time
  series. One of "linear", "spline" or "loess". Default: "linear".

- max_complexity:

  (required, logical). Only relevant for methods "spline" and "loess".
  If TRUE, model optimization is ignored, and the a model of maximum
  complexity (an overfitted model) is used for resampling. Default:
  FALSE

## Value

zoo object

## See also

Other zoo_functions:
[`zoo_aggregate()`](https://blasbenito.github.io/distantia/reference/zoo_aggregate.md),
[`zoo_name_clean()`](https://blasbenito.github.io/distantia/reference/zoo_name_clean.md),
[`zoo_name_get()`](https://blasbenito.github.io/distantia/reference/zoo_name_get.md),
[`zoo_name_set()`](https://blasbenito.github.io/distantia/reference/zoo_name_set.md),
[`zoo_permute()`](https://blasbenito.github.io/distantia/reference/zoo_permute.md),
[`zoo_plot()`](https://blasbenito.github.io/distantia/reference/zoo_plot.md),
[`zoo_smooth_exponential()`](https://blasbenito.github.io/distantia/reference/zoo_smooth_exponential.md),
[`zoo_smooth_window()`](https://blasbenito.github.io/distantia/reference/zoo_smooth_window.md),
[`zoo_time()`](https://blasbenito.github.io/distantia/reference/zoo_time.md),
[`zoo_to_tsl()`](https://blasbenito.github.io/distantia/reference/zoo_to_tsl.md),
[`zoo_vector_to_matrix()`](https://blasbenito.github.io/distantia/reference/zoo_vector_to_matrix.md)

## Examples

``` r
#simulate irregular time series
x <- zoo_simulate(
  cols = 2,
  rows = 50,
  time_range = c("2010-01-01", "2020-01-01"),
  irregular = TRUE
  )

#plot time series
if(interactive()){
  zoo_plot(x)
}

#intervals between samples
x_intervals <- diff(zoo::index(x))
x_intervals
#> Time differences in days
#>  [1] 110.66667  36.88889  73.77778  36.88889 147.55556 110.66667  73.77778
#>  [8]  36.88889 110.66667  36.88889 110.66667  36.88889  73.77778  36.88889
#> [15]  36.88889 147.55556  36.88889  36.88889  36.88889  36.88889  36.88889
#> [22]  73.77778  36.88889  73.77778  73.77778  36.88889  36.88889  36.88889
#> [29] 110.66667  36.88889  36.88889  36.88889 147.55556  36.88889 221.33333
#> [36]  36.88889 147.55556  36.88889 147.55556  73.77778 110.66667  73.77778
#> [43]  36.88889  36.88889  36.88889 295.11111  73.77778  36.88889  36.88889

#create regular time from the minimum of the observed intervals
new_time <- seq.Date(
  from = min(zoo::index(x)),
  to = max(zoo::index(x)),
  by = floor(min(x_intervals))
)

new_time
#>   [1] "2010-01-01" "2010-02-06" "2010-03-14" "2010-04-19" "2010-05-25"
#>   [6] "2010-06-30" "2010-08-05" "2010-09-10" "2010-10-16" "2010-11-21"
#>  [11] "2010-12-27" "2011-02-01" "2011-03-09" "2011-04-14" "2011-05-20"
#>  [16] "2011-06-25" "2011-07-31" "2011-09-05" "2011-10-11" "2011-11-16"
#>  [21] "2011-12-22" "2012-01-27" "2012-03-03" "2012-04-08" "2012-05-14"
#>  [26] "2012-06-19" "2012-07-25" "2012-08-30" "2012-10-05" "2012-11-10"
#>  [31] "2012-12-16" "2013-01-21" "2013-02-26" "2013-04-03" "2013-05-09"
#>  [36] "2013-06-14" "2013-07-20" "2013-08-25" "2013-09-30" "2013-11-05"
#>  [41] "2013-12-11" "2014-01-16" "2014-02-21" "2014-03-29" "2014-05-04"
#>  [46] "2014-06-09" "2014-07-15" "2014-08-20" "2014-09-25" "2014-10-31"
#>  [51] "2014-12-06" "2015-01-11" "2015-02-16" "2015-03-24" "2015-04-29"
#>  [56] "2015-06-04" "2015-07-10" "2015-08-15" "2015-09-20" "2015-10-26"
#>  [61] "2015-12-01" "2016-01-06" "2016-02-11" "2016-03-18" "2016-04-23"
#>  [66] "2016-05-29" "2016-07-04" "2016-08-09" "2016-09-14" "2016-10-20"
#>  [71] "2016-11-25" "2016-12-31" "2017-02-05" "2017-03-13" "2017-04-18"
#>  [76] "2017-05-24" "2017-06-29" "2017-08-04" "2017-09-09" "2017-10-15"
#>  [81] "2017-11-20" "2017-12-26" "2018-01-31" "2018-03-08" "2018-04-13"
#>  [86] "2018-05-19" "2018-06-24" "2018-07-30" "2018-09-04" "2018-10-10"
#>  [91] "2018-11-15" "2018-12-21" "2019-01-26" "2019-03-03" "2019-04-08"
#>  [96] "2019-05-14" "2019-06-19" "2019-07-25" "2019-08-30" "2019-10-05"
diff(new_time)
#> Time differences in days
#>  [1] 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36
#> [26] 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36
#> [51] 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36
#> [76] 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36

#resample using piecewise linear regression
x_linear <- zoo_resample(
  x = x,
  new_time = new_time,
  method = "linear"
)

#resample using max complexity splines
x_spline <- zoo_resample(
  x = x,
  new_time = new_time,
  method = "spline",
  max_complexity = TRUE
)

#resample using max complexity loess
x_loess <- zoo_resample(
  x = x,
  new_time = new_time,
  method = "loess",
  max_complexity = TRUE
)


#intervals between new samples
diff(zoo::index(x_linear))
#> Time differences in days
#>  [1] 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36
#> [26] 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36
#> [51] 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36
#> [76] 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36
diff(zoo::index(x_spline))
#> Time differences in days
#>  [1] 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36
#> [26] 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36
#> [51] 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36
#> [76] 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36
diff(zoo::index(x_loess))
#> Time differences in days
#>  [1] 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36
#> [26] 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36
#> [51] 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36
#> [76] 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36

#plotting results
if(interactive()){

  par(mfrow = c(4, 1), mar = c(3,3,2,2))

  zoo_plot(
    x,
    guide = FALSE,
    title = "Original"
    )

  zoo_plot(
    x_linear,
    guide = FALSE,
    title = "Method: linear"
  )

  zoo_plot(
    x_spline,
    guide = FALSE,
    title = "Method: spline"
    )

  zoo_plot(
    x_loess,
    guide = FALSE,
    title = "Method: loess"
  )

}
```
