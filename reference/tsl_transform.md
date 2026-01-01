# Transform Values in Time Series Lists

Function for time series transformations without changes in data
dimensions. Generally, functions introduced via the argument `f` should
not change the dimensions of the output time series list. See
[`tsl_resample()`](https://blasbenito.github.io/distantia/reference/tsl_resample.md)
and
[`tsl_aggregate()`](https://blasbenito.github.io/distantia/reference/tsl_aggregate.md)
for transformations requiring changes in time series dimensions.

This function supports a parallelization setup via
[`future::plan()`](https://future.futureverse.org/reference/plan.html),
and progress bars provided by the package
[progressr](https://CRAN.R-project.org/package=progressr).

## Usage

``` r
tsl_transform(tsl = NULL, f = NULL, ...)
```

## Arguments

- tsl:

  (required, list) Time series list. Default: NULL

- f:

  (required, transformation function) name of a function taking a matrix
  as input. Currently, the following options are implemented, but any
  other function taking a matrix as input (for example,
  [`scale()`](https://rdrr.io/r/base/scale.html)) should work as well:

  - f_proportion: proportion computed by row.

  - f_percent: percentage computed by row.

  - f_hellinger: Hellinger transformation computed by row

  - f_scale_local: Local centering and/or scaling based on the variable
    mean and standard deviation in each time series within `tsl`.

  - f_scale_global: Global centering and/or scaling based on the
    variable mean and standard deviation across all time series within
    `tsl`.

  - f_smooth: Time series smoothing with a user defined rolling window.

  - f_detrend_difference: Differencing detrending of time series via
    [`diff()`](https://rdrr.io/r/base/diff.html).

  - f_detrend_linear: Detrending of seasonal time series via linear
    modeling.

  - f_detrend_gam: Detrending of seasonal time series via Generalized
    Additive Models.

- ...:

  (optional, additional arguments of `f`) Optional arguments for the
  transformation function.

## Value

time series list

## See also

Other tsl_processing:
[`tsl_aggregate()`](https://blasbenito.github.io/distantia/reference/tsl_aggregate.md),
[`tsl_resample()`](https://blasbenito.github.io/distantia/reference/tsl_resample.md),
[`tsl_smooth()`](https://blasbenito.github.io/distantia/reference/tsl_smooth.md),
[`tsl_stats()`](https://blasbenito.github.io/distantia/reference/tsl_stats.md)

## Examples

``` r
#two time series
tsl <- tsl_initialize(
  x = fagus_dynamics,
  name_column = "name",
  time_column = "time"
) |>
  tsl_subset(
    names = c("Spain", "Sweden"),
    colnames = c("rainfall", "temperature")
  )

if(interactive()){
  tsl_plot(
    tsl = tsl
  )
}

#centering and scaling
#-----------------------------------------
#same mean and standard deviation are used to scale each variable across all time series
tsl_scale <- tsl_transform(
  tsl = tsl,
  f = f_scale_local
)

if(interactive()){
  tsl_plot(
    tsl = tsl_scale,
    guide_columns = 3
  )
}


#rescaling to a new range
#-----------------------------------------

#rescale between -100 and 100
tsl_rescaled <- tsl_transform(
  tsl = tsl,
  f = f_rescale_local,
  new_min = -100,
  new_max = 100
)

#old range
sapply(X = tsl, FUN = range)
#>      Spain Sweden
#> [1,]   4.5   -4.7
#> [2,] 216.6  189.6

#new range
sapply(X = tsl_rescaled, FUN = range)
#>      Spain Sweden
#> [1,]  -100   -100
#> [2,]   100    100



#numeric transformations
#-----------------------------------------
#eemian pollen counts
tsl <- tsl_initialize(
  x = distantia::eemian_pollen,
  name_column = "name",
  time_column = "time"
)
#> distantia::utils_prepare_time():  duplicated time indices in 'Krumbach_I':
#> - value 6.8 replaced with 6.825.

if(interactive()){
  tsl_plot(
    tsl = tsl
  )
}

#percentages
tsl_percentage <- tsl_transform(
  tsl = tsl,
  f = f_percent
)

if(interactive()){
  tsl_plot(
    tsl = tsl_percentage
  )
}

#hellinger transformation
tsl_hellinger <- tsl_transform(
  tsl = tsl,
  f = f_hellinger
)

if(interactive()){
  tsl_plot(
    tsl = tsl_hellinger
  )
}
```
