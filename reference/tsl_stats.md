# Summary Statistics of Time Series Lists

This function computes a variety of summary statistics for each time
series and numeric column within a time series list. The statistics
include common metrics such as minimum, maximum, quartiles, mean,
standard deviation, range, interquartile range, skewness, kurtosis, and
autocorrelation for specified lags.

For irregular time series, autocorrelation computation is performed
after regularizing the time series via interpolation with
[`zoo_resample()`](https://blasbenito.github.io/distantia/reference/zoo_resample.md).
This regularization does not affect the computation of all other stats.

This function supports a parallelization setup via
[`future::plan()`](https://future.futureverse.org/reference/plan.html),
and progress bars provided by the package
[progressr](https://CRAN.R-project.org/package=progressr).

## Usage

``` r
tsl_stats(tsl = NULL, lags = 1L)
```

## Arguments

- tsl:

  (required, list) Time series list. Default: NULL

- lags:

  (optional, integer) An integer specifying the number of
  autocorrelation lags to compute. If NULL, autocorrelation computation
  is disabled. Default: 1.

## Value

data frame:

- name: name of the zoo object.

- rows: rows of the zoo object.

- columns: columns of the zoo object.

- time_units: time units of the zoo time series (see
  [`zoo_time()`](https://blasbenito.github.io/distantia/reference/zoo_time.md)).

- time_begin: beginning time of the time series.

- time_end: end time of the time series.

- time_length: total length of the time series, expressed in time units.

- time_resolution: average distance between consecutive observations

- variable: name of the variable, a column of the zoo object.

- min: minimum value of the zoo column.

- q1: first quartile (25th percentile).

- median: 50th percentile.

- q3: third quartile (75th percentile).

- max: maximum value.

- mean: average value.

- sd: standard deviation.

- range: range of the variable, computed as max - min.

- iq_range: interquartile range of the variable, computed as q3 - q1.

- skewness: asymmetry of the variable distribution.

- kurtosis:"tailedness" of the variable distribution.

- ac_lag_1, ac_lag_2, ...: autocorrelation values for the specified
  lags.

## See also

Other tsl_processing:
[`tsl_aggregate()`](https://blasbenito.github.io/distantia/reference/tsl_aggregate.md),
[`tsl_resample()`](https://blasbenito.github.io/distantia/reference/tsl_resample.md),
[`tsl_smooth()`](https://blasbenito.github.io/distantia/reference/tsl_smooth.md),
[`tsl_transform()`](https://blasbenito.github.io/distantia/reference/tsl_transform.md)

## Examples

``` r

#three time series
#climate and ndvi in Fagus sylvatica stands in Spain, Germany, and Sweden
tsl <- tsl_initialize(
  x = fagus_dynamics,
  name_column = "name",
  time_column = "time"
)


#stats computation
df <- tsl_stats(
  tsl = tsl,
  lags = 3
  )

df
#>      name    variable NA_count     min        q1   median         q3      max
#> 1 Germany         evi        0  0.0689  0.328025  0.44070   0.581550   0.7528
#> 2   Spain         evi        0  0.1828  0.271000  0.34525   0.466925   0.6434
#> 3  Sweden         evi        0  0.0413  0.203850  0.30580   0.608775   0.8764
#> 4 Germany    rainfall        0  3.6000 37.450000 55.95000  76.850000 144.1000
#> 5   Spain    rainfall        0 11.3000 55.650000 78.50000 117.550000 216.6000
#> 6  Sweden    rainfall        0  8.3000 40.775000 59.25000  82.075000 189.6000
#> 7 Germany temperature        0 -1.9000  4.900000 10.40000  16.900000  23.2000
#> 8   Spain temperature        0  4.5000  8.700000 12.60000  17.700000  21.7000
#> 9  Sweden temperature        0 -4.7000  3.200000  8.15000  14.300000  20.0000
#>         mean         sd    range  iq_range    skewness   kurtosis  ac_lag_1
#> 1  0.4475370  0.1467074   0.6839  0.253525 -0.05783267 -1.0177517 0.7320740
#> 2  0.3687245  0.1170178   0.4606  0.195925  0.28642807 -1.1547325 0.7786569
#> 3  0.3890579  0.2116391   0.8351  0.404925  0.27701665 -1.5166381 0.7640670
#> 4 58.7157407 27.8993379 140.5000 39.400000  0.51192914 -0.1499229 0.1538267
#> 5 91.1606481 48.1853638 205.3000 61.900000  0.75359061 -0.2612889 0.3746936
#> 6 64.7592593 32.5032507 181.3000 41.300000  0.87978813  0.7386146 0.2996549
#> 7 10.6861111  6.7015369  25.1000 12.000000 -0.05073437 -1.3166755 0.8177223
#> 8 13.0263889  4.7681695  17.2000  9.000000  0.04692060 -1.3981559 0.8236847
#> 9  8.5263889  6.5337833  24.7000 11.100000 -0.04126297 -1.3096657 0.8301333
#>      ac_lag_2     ac_lag_3
#> 1  0.40592841  0.013433802
#> 2  0.43763156  0.009986400
#> 3  0.41031957 -0.007017265
#> 4 -0.05836706 -0.049548715
#> 5  0.14053009 -0.052349298
#> 6  0.08426556 -0.061084475
#> 7  0.46288511  0.003767174
#> 8  0.45926908 -0.005029601
#> 9  0.47075257  0.006574696
```
