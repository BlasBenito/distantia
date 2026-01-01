# Aggregate `momentum()` Data Frames Across Parameter Combinations

The function
[`momentum()`](https://blasbenito.github.io/distantia/reference/momentum.md)
allows variable importance assessments based on several combinations of
arguments at once. For example, when the argument `distance` is set to
`c("euclidean", "manhattan")`, the output data frame will show two
importance scores for each pair of compared time series and variable,
one based on euclidean distances, and another based on manhattan
distances.

This function computes importance stats across combinations of
parameters.

If there are no different combinations of arguments in the input data
frame, no aggregation happens, but all parameter columns are removed.

## Usage

``` r
momentum_aggregate(df = NULL, f = mean, ...)
```

## Arguments

- df:

  (required, data frame) Output of
  [`momentum()`](https://blasbenito.github.io/distantia/reference/momentum.md),
  [`momentum_ls()`](https://blasbenito.github.io/distantia/reference/momentum_ls.md),
  or
  [`momentum_dtw()`](https://blasbenito.github.io/distantia/reference/momentum_dtw.md).
  Default: NULL

- f:

  (optional, function) Function to summarize psi scores (for example,
  `mean`) when there are several combinations of parameters in `df`.
  Ignored when there is a single combination of arguments in the input.
  Default: `mean`

- ...:

  (optional, arguments of `f`) Further arguments to pass to the function
  `f`.

## Value

data frame

## See also

Other momentum_support:
[`momentum_boxplot()`](https://blasbenito.github.io/distantia/reference/momentum_boxplot.md),
[`momentum_model_frame()`](https://blasbenito.github.io/distantia/reference/momentum_model_frame.md),
[`momentum_spatial()`](https://blasbenito.github.io/distantia/reference/momentum_spatial.md),
[`momentum_stats()`](https://blasbenito.github.io/distantia/reference/momentum_stats.md),
[`momentum_to_wide()`](https://blasbenito.github.io/distantia/reference/momentum_to_wide.md)

## Examples

``` r
#three time series
#climate and ndvi in Fagus sylvatica stands in Spain, Germany, and Sweden
tsl <- tsl_initialize(
  x = fagus_dynamics,
  name_column = "name",
  time_column = "time"
) |>
  tsl_transform(
    f = f_scale_global
  )

if(interactive()){
  tsl_plot(
    tsl = tsl,
    guide_columns = 3
    )
}

#momentum with multiple parameter combinations
#-------------------------------------
df <- momentum(
  tsl = tsl,
  distance = c("euclidean", "manhattan"),
  lock_step = TRUE
)

df[, c(
  "x",
  "y",
  "distance",
  "importance"
)]
#>          x      y  distance  importance
#> 1  Germany  Spain euclidean   0.2418284
#> 2  Germany  Spain euclidean  19.0510522
#> 3  Germany  Spain euclidean -30.8149446
#> 4  Germany Sweden euclidean  28.5397361
#> 5  Germany Sweden euclidean  -4.8452329
#> 6  Germany Sweden euclidean -25.0116076
#> 7    Spain Sweden euclidean -22.9123967
#> 8    Spain Sweden euclidean   9.7321092
#> 9    Spain Sweden euclidean  12.5019490
#> 10 Germany  Spain manhattan   1.9009353
#> 11 Germany  Spain manhattan  21.1547021
#> 12 Germany  Spain manhattan -29.7277090
#> 13 Germany Sweden manhattan  29.2499494
#> 14 Germany Sweden manhattan  -3.4448911
#> 15 Germany Sweden manhattan -26.6846263
#> 16   Spain Sweden manhattan -25.0802330
#> 17   Spain Sweden manhattan  10.7646398
#> 18   Spain Sweden manhattan  12.7421868

#aggregation using means
df <- momentum_aggregate(
  df = df,
  f = mean
)

df
#>          x      y       psi    variable  importance               effect
#> 1  Germany  Spain 1.3061327         evi   0.2418284 decreases similarity
#> 2  Germany  Spain 1.3061327    rainfall  19.0510522 decreases similarity
#> 3  Germany  Spain 1.3061327 temperature -30.8149446 increases similarity
#> 4  Germany Sweden 0.8576700         evi  28.5397361 decreases similarity
#> 5  Germany Sweden 0.8576700    rainfall  -4.8452329 increases similarity
#> 6  Germany Sweden 0.8576700 temperature -25.0116076 increases similarity
#> 7    Spain Sweden 1.4708497         evi -22.9123967 increases similarity
#> 8    Spain Sweden 1.4708497    rainfall   9.7321092 decreases similarity
#> 9    Spain Sweden 1.4708497 temperature  12.5019490 decreases similarity
#> 10 Germany  Spain 1.2698922         evi   1.9009353 decreases similarity
#> 11 Germany  Spain 1.2698922    rainfall  21.1547021 decreases similarity
#> 12 Germany  Spain 1.2698922 temperature -29.7277090 increases similarity
#> 13 Germany Sweden 0.8591195         evi  29.2499494 decreases similarity
#> 14 Germany Sweden 0.8591195    rainfall  -3.4448911 increases similarity
#> 15 Germany Sweden 0.8591195 temperature -26.6846263 increases similarity
#> 16   Spain Sweden 1.4890286         evi -25.0802330 increases similarity
#> 17   Spain Sweden 1.4890286    rainfall  10.7646398 decreases similarity
#> 18   Spain Sweden 1.4890286 temperature  12.7421868 decreases similarity
#>    psi_difference psi_without psi_only_with
#> 1      0.00315860   1.2848422     1.2880008
#> 2      0.24883203   1.1566276     1.4054596
#> 3     -0.40248408   1.3910532     0.9885691
#> 4      0.24477676   0.7873060     1.0320827
#> 5     -0.04155611   0.8829917     0.8414356
#> 6     -0.21451706   0.9099069     0.6953898
#> 7     -0.33700692   1.5557210     1.2187141
#> 8      0.14314470   1.4286475     1.5717922
#> 9      0.18388488   1.4493101     1.6331950
#> 10     0.02413983   1.2638610     1.2880008
#> 11     0.26864192   1.1368177     1.4054596
#> 12    -0.37750987   1.3660790     0.9885691
#> 13     0.25129201   0.7807907     1.0320827
#> 14    -0.02959573   0.8710313     0.8414356
#> 15    -0.22925282   0.9246426     0.6953898
#> 16    -0.37345183   1.5921659     1.2187141
#> 17     0.16028856   1.4115036     1.5717922
#> 18     0.18973480   1.4434602     1.6331950
```
