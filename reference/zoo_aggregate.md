# Aggregate Cases in Zoo Time Series

Aggregate Cases in Zoo Time Series

## Usage

``` r
zoo_aggregate(x = NULL, new_time = NULL, f = mean, ...)
```

## Arguments

- x:

  (required, zoo object) Time series to aggregate. Default: NULL

- new_time:

  (optional, zoo object, keyword, or time vector) New time to aggregate
  `x` to. The available options are:

  - NULL: the highest resolution keyword returned by
    `zoo_time(x)$keywords` is used to generate a new time vector to
    aggregate `x`.

  - zoo object: the index of the given zoo object is used as template to
    aggregate `x`.

  - time vector: a vector with new times to resample `x` to. If time in
    `x` is of class "numeric", this vector must be numeric as well.
    Otherwise, vectors of classes "Date" and "POSIXct" can be used
    indistinctly.

  - keyword: a valid keyword returned by `zoo_time(x)$keywords`, used to
    generate a time vector with the relevant units.

  - numeric of length 1: interpreted as new time interval, in the
    highest resolution units returned by `zoo_time(x)$units`.

- f:

  (optional, quoted or unquoted function name) Name of a standard or
  custom function to aggregate numeric vectors. Typical examples are
  `mean`, `max`,`min`, `median`, and `quantile`. Default: `mean`.

- ...:

  (optional, additional arguments) additional arguments to `f`.

## Value

zoo object

## See also

Other zoo_functions:
[`zoo_name_clean()`](https://blasbenito.github.io/distantia/reference/zoo_name_clean.md),
[`zoo_name_get()`](https://blasbenito.github.io/distantia/reference/zoo_name_get.md),
[`zoo_name_set()`](https://blasbenito.github.io/distantia/reference/zoo_name_set.md),
[`zoo_permute()`](https://blasbenito.github.io/distantia/reference/zoo_permute.md),
[`zoo_plot()`](https://blasbenito.github.io/distantia/reference/zoo_plot.md),
[`zoo_resample()`](https://blasbenito.github.io/distantia/reference/zoo_resample.md),
[`zoo_smooth_exponential()`](https://blasbenito.github.io/distantia/reference/zoo_smooth_exponential.md),
[`zoo_smooth_window()`](https://blasbenito.github.io/distantia/reference/zoo_smooth_window.md),
[`zoo_time()`](https://blasbenito.github.io/distantia/reference/zoo_time.md),
[`zoo_to_tsl()`](https://blasbenito.github.io/distantia/reference/zoo_to_tsl.md),
[`zoo_vector_to_matrix()`](https://blasbenito.github.io/distantia/reference/zoo_vector_to_matrix.md)

## Examples

``` r
#full range of calendar dates
x <- zoo_simulate(
  rows = 1000,
  time_range = c(
    "0000-01-01",
    as.character(Sys.Date())
    )
)

#plot time series
if(interactive()){
  zoo_plot(x)
}


#find valid aggregation keywords
x_time <- zoo_time(x)
x_time$keywords
#> [[1]]
#> [1] "millennia" "centuries" "decades"   "years"     "quarters" 
#> 

#mean value by millennia (extreme case!!!)
x_millennia <- zoo_aggregate(
  x = x,
  new_time = "millennia",
  f = mean
)

if(interactive()){
  zoo_plot(x_millennia)
}

#max value by centuries
x_centuries <- zoo_aggregate(
  x = x,
  new_time = "centuries",
  f = max
)

if(interactive()){
  zoo_plot(x_centuries)
}

#quantile 0.75 value by centuries
x_centuries <- zoo_aggregate(
  x = x,
  new_time = "centuries",
  f = stats::quantile,
  probs = 0.75 #argument of stats::quantile()
)

if(interactive()){
  zoo_plot(x_centuries)
}
```
