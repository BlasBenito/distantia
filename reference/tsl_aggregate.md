# Aggregate Time Series List Over Time Periods

Time series aggregation involves grouping observations and summarizing
group values with a statistical function. This operation is useful to:

- Decrease (downsampling) the temporal resolution of a time series.

- Highlight particular states of a time series over time. For example, a
  daily temperature series can be aggregated by month using `max` to
  represent the highest temperatures each month.

- Transform irregular time series into regular.

This function aggregates time series lists **with overlapping times**.
Please check such overlap by assessing the columns "begin" and "end " of
the data frame resulting from `df <- tsl_time(tsl = tsl)`. Aggregation
will be limited by the shortest time series in your time series list. To
aggregate non-overlapping time series, please subset the individual
components of `tsl` one by one either using
[`tsl_subset()`](https://blasbenito.github.io/distantia/reference/tsl_subset.md)
or the syntax `tsl = my_tsl[[i]]`.

**Methods**

Any function returning a single number from a numeric vector can be used
to aggregate a time series list. Quoted and unquoted function names can
be used. Additional arguments to these functions can be passed via the
argument `...`. Typical examples are:

- `mean` or `"mean"`: see [`mean()`](https://rdrr.io/r/base/mean.html).

- `median` or `"median"`: see
  [`stats::median()`](https://rdrr.io/r/stats/median.html).

- `quantile` or "quantile": see
  [`stats::quantile()`](https://rdrr.io/r/stats/quantile.html).

- `min` or `"min"`: see [`min()`](https://rdrr.io/r/base/Extremes.html).

- `max` or `"max"`: see [`max()`](https://rdrr.io/r/base/Extremes.html).

- `sd` or `"sd"`: to compute standard deviation, see
  [`stats::sd()`](https://rdrr.io/r/stats/sd.html).

- `var` or `"var"`: to compute the group variance, see
  [`stats::var()`](https://rdrr.io/r/stats/cor.html).

- `length` or `"length"`: to compute group length.

- `sum` or `"sum"`: see [`sum()`](https://rdrr.io/r/base/sum.html).

This function supports a parallelization setup via
[`future::plan()`](https://future.futureverse.org/reference/plan.html),
and progress bars provided by the package
[progressr](https://CRAN.R-project.org/package=progressr).

## Usage

``` r
tsl_aggregate(tsl = NULL, new_time = NULL, f = mean, ...)
```

## Arguments

- tsl:

  (required, list) Time series list. Default: NULL

- new_time:

  (required, numeric, numeric vector, Date vector, POSIXct vector, or
  keyword) Definition of the aggregation pattern. The available options
  are:

  - numeric vector: only for the "numeric" time class, defines the
    breakpoints for time series aggregation.

  - "Date" or "POSIXct" vector: as above, but for the time classes
    "Date" and "POSIXct." In any case, the input vector is coerced to
    the time class of the `tsl` argument.

  - numeric: defines fixed time intervals in the units of `tsl` for time
    series aggregation. Used as is when the time class is "numeric", and
    coerced to integer and interpreted as days for the time classes
    "Date" and "POSIXct".

  - keyword (see
    [`utils_time_units()`](https://blasbenito.github.io/distantia/reference/utils_time_units.md)):
    the common options for the time classes "Date" and "POSIXct" are:
    "millennia", "centuries", "decades", "years", "quarters", "months",
    and "weeks". Exclusive keywords for the "POSIXct" time class are:
    "days", "hours", "minutes", and "seconds". The time class "numeric"
    accepts keywords coded as scientific numbers, from "1e8" to "1e-8".

- f:

  (required, function name) Name of function taking a vector as input
  and returning a single value as output. Typical examples are `mean`,
  `max`,`min`, `median`, and `quantile`. Default: `mean`.

- ...:

  (optional) further arguments for `f`.

## Value

time series list

## See also

[`zoo_aggregate()`](https://blasbenito.github.io/distantia/reference/zoo_aggregate.md)

Other tsl_processing:
[`tsl_resample()`](https://blasbenito.github.io/distantia/reference/tsl_resample.md),
[`tsl_smooth()`](https://blasbenito.github.io/distantia/reference/tsl_smooth.md),
[`tsl_stats()`](https://blasbenito.github.io/distantia/reference/tsl_stats.md),
[`tsl_transform()`](https://blasbenito.github.io/distantia/reference/tsl_transform.md)

## Examples

``` r
# yearly aggregation
#----------------------------------
#long-term monthly temperature of 20 cities
tsl <- tsl_initialize(
  x = cities_temperature,
  name_column = "name",
  time_column = "time"
)

#plot time series
if(interactive()){
  tsl_plot(
    tsl = tsl[1:4],
    guide_columns = 4
  )
}

#check time features
tsl_time(tsl)[, c("name", "resolution", "units")]
#>                name resolution units
#> 1           Bangkok    30.4381  days
#> 2            Bogotá    30.4381  days
#> 3             Cairo    30.4381  days
#> 4             Dhaka    30.4381  days
#> 5  Ho Chi Minh City    30.4381  days
#> 6          Istanbul    30.4381  days
#> 7           Jakarta    30.4381  days
#> 8           Karachi    30.4381  days
#> 9          Kinshasa    30.4381  days
#> 10            Lagos    30.4381  days
#> 11             Lima    30.4381  days
#> 12           London    30.4381  days
#> 13      Los Angeles    30.4381  days
#> 14           Manila    30.4381  days
#> 15           Moscow    30.4381  days
#> 16            Paris    30.4381  days
#> 17   Rio De Janeiro    30.4381  days
#> 18         Shanghai    30.4381  days
#> 19        São Paulo    30.4381  days
#> 20            Tokyo    30.4381  days

#aggregation: mean yearly values
tsl_year <- tsl_aggregate(
  tsl = tsl,
  new_time = "year",
  f = mean
)

#' #check time features
tsl_time(tsl_year)[, c("name", "resolution", "units")]
#>                name resolution units
#> 1           Bangkok     365.25  days
#> 2            Bogotá     365.25  days
#> 3             Cairo     365.25  days
#> 4             Dhaka     365.25  days
#> 5  Ho Chi Minh City     365.25  days
#> 6          Istanbul     365.25  days
#> 7           Jakarta     365.25  days
#> 8           Karachi     365.25  days
#> 9          Kinshasa     365.25  days
#> 10            Lagos     365.25  days
#> 11             Lima     365.25  days
#> 12           London     365.25  days
#> 13      Los Angeles     365.25  days
#> 14           Manila     365.25  days
#> 15           Moscow     365.25  days
#> 16            Paris     365.25  days
#> 17   Rio De Janeiro     365.25  days
#> 18         Shanghai     365.25  days
#> 19        São Paulo     365.25  days
#> 20            Tokyo     365.25  days

if(interactive()){
  tsl_plot(
    tsl = tsl_year[1:4],
    guide_columns = 4
  )
}


# other supported keywords
#----------------------------------

#simulate full range of calendar dates
tsl <- tsl_simulate(
  n = 2,
  rows = 1000,
  time_range = c(
    "0000-01-01",
    as.character(Sys.Date())
  )
)

#mean value by millennia (extreme case!!!)
tsl_millennia <- tsl_aggregate(
  tsl = tsl,
  new_time = "millennia",
  f = mean
)

if(interactive()){
  tsl_plot(tsl_millennia)
}

#max value by centuries
tsl_century <- tsl_aggregate(
  tsl = tsl,
  new_time = "century",
  f = max
)

if(interactive()){
  tsl_plot(tsl_century)
}

#quantile 0.75 value by centuries
tsl_centuries <- tsl_aggregate(
  tsl = tsl,
  new_time = "centuries",
  f = stats::quantile,
  probs = 0.75 #argument of stats::quantile()
)
```
