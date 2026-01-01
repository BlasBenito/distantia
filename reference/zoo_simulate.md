# Simulate a Zoo Time Series

Generates simulated zoo time series.

## Usage

``` r
zoo_simulate(
  name = "A",
  cols = 5,
  rows = 100,
  time_range = c("2010-01-01", "2020-01-01"),
  data_range = c(0, 1),
  seasons = 0,
  na_fraction = 0,
  independent = FALSE,
  irregular = TRUE,
  seed = NULL
)
```

## Arguments

- name:

  (optional, character string) Name of the zoo object, to be stored in
  the attribute "name". Default: "A"

- cols:

  (optional, integer) Number of time series. Default: 5

- rows:

  (optional, integer) Length of the time series. Minimum is 10, but
  maximum is not limited. Very large numbers might crash the R session.
  Default: 100

- time_range:

  (optional character or numeric vector) Interval of the time series.
  Either a character vector with dates in format YYYY-MM-DD or or a
  numeric vector. If there is a mismatch between `time_range` and `rows`
  (for example, the number of days in `time_range` is smaller than
  `rows`), the upper value in `time_range` is adapted to `rows`.
  Default: c("2010-01-01", "2020-01-01")

- data_range:

  (optional, numeric vector of length 2) Extremes of the simulated time
  series values. The simulated time series are independently adjusted to
  random values within the provided range. Default: c(0, 1)

- seasons:

  (optional, integer) Number of seasons in the resulting time series.
  The maximum number of seasons is computed as `floor(rows/3)`. Default:
  0

- na_fraction:

  (optional, numeric) Value between 0 and 0.5 indicating the approximate
  fraction of NA data in the simulated time series. Default: 0.

- independent:

  (optional, logical) If TRUE, each new column in a simulated time
  series is averaged with the previous column. Irrelevant when
  `cols <= 2`, and hard to perceive in the output when `seasons > 0`.
  Default: FALSE

- irregular:

  (optional, logical) If TRUE, the time series is created with 20
  percent more rows, and a random 20 percent of rows are removed at
  random. Default: TRUE

- seed:

  (optional, integer) Random seed used to simulate the zoo object.
  Default: NULL

## Value

zoo object

## See also

Other simulate_time_series:
[`tsl_simulate()`](https://blasbenito.github.io/distantia/reference/tsl_simulate.md)

## Examples

``` r
#generates a different time series on each execution when 'seed = NULL'
x <- zoo_simulate()

#returns a zoo object
class(x)
#> [1] "zoo"

#time series names are uppercase letters
#this attribute is not defined in the zoo class and might be lost during data transformations
attributes(x)$name
#> [1] "A"

#column names are lowercase letters
names(x)
#> [1] "a" "b" "c" "d" "e"

#plotting methods
if(interactive()){

  #plot time series with default zoo method
  plot(x)

  #plot time series with distantia
  zoo_plot(
    x = x,
    xlab = "Date",
    ylab = "Value",
    title = "My time series"
  )

}
```
