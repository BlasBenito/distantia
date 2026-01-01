# Resample Time Series Lists to a New Time

**Objective**

Time series resampling interpolates new values for time steps not
available in the original time series. This operation is useful to:

- Transform irregular time series into regular.

- Align time series with different temporal resolutions.

- Increase (upsampling) or decrease (downsampling) the temporal
  resolution of a time series.

Time series resampling **should not be used** to extrapolate new values
outside of the original time range of the time series, or to increase
the resolution of a time series by a factor of two or more. These
operations are known to produce non-sensical results.

**Warning**: This function resamples time series lists **with
overlapping times**. Please check such overlap by assessing the columns
"begin" and "end " of the data frame resulting from
`df <- tsl_time(tsl = tsl)`. Resampling will be limited by the shortest
time series in your time series list. To resample non-overlapping time
series, please subset the individual components of `tsl` one by one
either using
[`tsl_subset()`](https://blasbenito.github.io/distantia/reference/tsl_subset.md)
or the syntax `tsl = my_tsl[[i]]`.

**Methods**

This function offers three methods for time series interpolation:

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

- `time series list`: a time series list to be used as template. The
  range of overlapping dates and the average resolution are used to
  generate the new resampling time. This method cannot be used to align
  two time series lists, unless the template is resampled beforehand.

- `time vector`: a time vector of a class compatible with the time in
  `x`.

- `keyword`: character string defining a resampling keyword, obtained
  via `zoo_time(x, keywords = "resample")$keywords`..

- `numeric`: a single number representing the desired interval between
  consecutive samples in the units of `x` (relevant units can be
  obtained via `zoo_time(x)$units`).

**Step by Step**

The steps to resample a time series list are:

1.  The time interpolation range is computed from the intersection of
    all times in `tsl`. This step ensures that no extrapolation occurs
    during resampling, but it also makes resampling of non-overlapping
    time series impossible.

2.  If `new_time` is provided, any values of `new_time` outside of the
    minimum and maximum interpolation times are removed to avoid
    extrapolation. If `new_time` is not provided, a regular time within
    the interpolation time range with the length of the shortest time
    series in `tsl` is generated.

3.  For each univariate time time series, a model `y ~ x`, where `y` is
    the time series and `x` is its own time coerced to numeric is
    fitted.

    - If `max_complexity == FALSE`, the model with the complexity that
      minimizes the root mean squared error between the observed and
      predicted `y` is returned.

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

This function supports a parallelization setup via
[`future::plan()`](https://future.futureverse.org/reference/plan.html),
and progress bars provided by the package
[progressr](https://CRAN.R-project.org/package=progressr).

## Usage

``` r
tsl_resample(
  tsl = NULL,
  new_time = NULL,
  method = "linear",
  max_complexity = FALSE
)
```

## Arguments

- tsl:

  (required, list) Time series list. Default: NULL

- new_time:

  (required, zoo object, time series list, character string, time
  vector, numeric) New time to resample to. If a time vector is
  provided, it must be of a class compatible with the time of `tsl`. If
  a zoo object or time series list is provided, its time is used as a
  template to resample `tsl`. Valid resampling keywords (see
  [`tsl_time()`](https://blasbenito.github.io/distantia/reference/tsl_time.md))
  are allowed. Numeric values are interpreted as interval widths in the
  time units of the time series. If NULL, irregular time series are
  predicted into a regular version of their own time. Default: NULL

- method:

  (optional, character string) Name of the method to resample the time
  series. One of "linear", "spline" or "loess". Default: "linear".

- max_complexity:

  (required, logical). Only relevant for methods "spline" and "loess".
  If TRUE, model optimization is ignored, and the a model of maximum
  complexity (an overfitted model) is used for resampling. Default:
  FALSE

## Value

time series list

## See also

[`zoo_resample()`](https://blasbenito.github.io/distantia/reference/zoo_resample.md)

Other tsl_processing:
[`tsl_aggregate()`](https://blasbenito.github.io/distantia/reference/tsl_aggregate.md),
[`tsl_smooth()`](https://blasbenito.github.io/distantia/reference/tsl_smooth.md),
[`tsl_stats()`](https://blasbenito.github.io/distantia/reference/tsl_stats.md),
[`tsl_transform()`](https://blasbenito.github.io/distantia/reference/tsl_transform.md)

## Examples

``` r
#generate irregular time series
tsl <- tsl_simulate(
  n = 2,
  rows = 100,
  irregular = TRUE
)

if(interactive()){
  tsl_plot(tsl)
}


#range of times between samples
tsl_time_summary(tsl)[
  c(
    "units",
    "resolution_min",
    "resolution_max"
    )
  ]
#> $units
#> [1] "days"
#> 
#> $resolution_min
#> [1] 158.7826
#> 
#> $resolution_max
#> [1] 9.340153
#> 

#resample to regular using linear interpolation
tsl_regular <- tsl_resample(
  tsl = tsl
)
#> distantia::utils_new_time(): resampling 'tsl' to its average resolution.

if(interactive()){
  tsl_plot(tsl_regular)
}

#check new resolution
tsl_time_summary(tsl_regular)[
  c(
    "units",
    "resolution_min",
    "resolution_max"
  )
]
#> $units
#> [1] "days"
#> 
#> $resolution_min
#> [1] 40.40449
#> 
#> $resolution_max
#> [1] 40.40449
#> 

#resample using keywords

#valid resampling keywords
tsl_time_summary(
  tsl = tsl,
  keywords = "resample"
)$keywords
#> [1] "years"    "quarters" "months"   "weeks"   

#by month
tsl_months <- tsl_resample(
  tsl = tsl,
  new_time = "months"
)

if(interactive()){
  tsl_plot(tsl_months)
}

#by week
tsl_weeks <- tsl_resample(
  tsl = tsl,
  new_time = "weeks"
)

if(interactive()){
  tsl_plot(tsl_weeks)
}

#resample using time interval

#get relevant units
tsl_time(tsl)$units
#> [1] "days" "days"

#resampling to 15 days intervals
tsl_15_days <- tsl_resample(
  tsl = tsl,
  new_time = 15 #days
)

tsl_time_summary(tsl_15_days)[
  c(
    "units",
    "resolution_min",
    "resolution_max"
  )
]
#> $units
#> [1] "days"
#> 
#> $resolution_min
#> [1] 15
#> 
#> $resolution_max
#> [1] 15
#> 

if(interactive()){
  tsl_plot(tsl_15_days)
}

#aligning two time series listsç

#two time series lists with different time ranges
tsl1 <- tsl_simulate(
  n = 2,
  rows = 80,
  time_range = c("2010-01-01", "2020-01-01"),
  irregular = TRUE
)

tsl2 <- tsl_simulate(
  n = 2,
  rows = 120,
  time_range = c("2005-01-01", "2024-01-01"),
  irregular = TRUE
)

#check time features
tsl_time_summary(tsl1)[
  c(
    "begin",
    "end",
    "resolution_min",
    "resolution_max"
  )
]
#> $begin
#> [1] "2010-01-28"
#> 
#> $end
#> [1] "2019-10-25"
#> 
#> $resolution_min
#> [1] 218.8464
#> 
#> $resolution_max
#> [1] 13.47601
#> 

tsl_time_summary(tsl2)[
  c(
    "begin",
    "end",
    "resolution_min",
    "resolution_max"
  )
]
#> $begin
#> [1] "2005-02-15"
#> 
#> $end
#> [1] "2023-12-13"
#> 
#> $resolution_min
#> [1] 347.7059
#> 
#> $resolution_max
#> [1] 15.11765
#> 

#tsl1 to regular
tsl1_regular <- tsl_resample(
  tsl = tsl1
)
#> distantia::utils_new_time(): resampling 'tsl' to its average resolution.

#tsl2 resampled to time of tsl1_regular
tsl2_regular <- tsl_resample(
  tsl = tsl2,
  new_time = tsl1_regular
)

#check alignment
tsl_time_summary(tsl1_regular)[
  c(
    "begin",
    "end",
    "resolution_min",
    "resolution_max"
  )
]
#> $begin
#> [1] "2010-03-09"
#> 
#> $end
#> [1] "2019-10-10"
#> 
#> $resolution_min
#> [1] 53.06061
#> 
#> $resolution_max
#> [1] 53.06061
#> 

tsl_time_summary(tsl2_regular)[
  c(
    "begin",
    "end",
    "resolution_min",
    "resolution_max"
  )
]
#> $begin
#> [1] "2010-05-01"
#> 
#> $end
#> [1] "2019-10-10"
#> 
#> $resolution_min
#> [1] 53.06061
#> 
#> $resolution_max
#> [1] 53.06061
#> 
```
