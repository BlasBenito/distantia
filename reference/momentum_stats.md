# Stats of Dissimilarity Data Frame

Takes the output of
[`distantia()`](https://blasbenito.github.io/distantia/reference/distantia.md)
to return a data frame with one row per time series with the stats of
its dissimilarity scores with all other time series.

## Usage

``` r
momentum_stats(df = NULL)
```

## Arguments

- df:

  (required, data frame) Output of
  [`momentum()`](https://blasbenito.github.io/distantia/reference/momentum.md),
  [`momentum_ls()`](https://blasbenito.github.io/distantia/reference/momentum_ls.md),
  or
  [`momentum_dtw()`](https://blasbenito.github.io/distantia/reference/momentum_dtw.md).
  Default: NULL

## Value

data frame

## See also

Other momentum_support:
[`momentum_aggregate()`](https://blasbenito.github.io/distantia/reference/momentum_aggregate.md),
[`momentum_boxplot()`](https://blasbenito.github.io/distantia/reference/momentum_boxplot.md),
[`momentum_model_frame()`](https://blasbenito.github.io/distantia/reference/momentum_model_frame.md),
[`momentum_spatial()`](https://blasbenito.github.io/distantia/reference/momentum_spatial.md),
[`momentum_to_wide()`](https://blasbenito.github.io/distantia/reference/momentum_to_wide.md)

## Examples

``` r
tsl <- tsl_simulate(
  n = 5,
  irregular = FALSE
  )

df <- distantia(
  tsl = tsl,
  lock_step = TRUE
  )

df_stats <- distantia_stats(df = df)

df_stats
#>   name     mean      min       q1   median       q3      max        sd    range
#> 1    A 3.373642 1.792181 2.509229 3.255749 4.120162 5.190890 1.4544557 3.398708
#> 2    B 3.769669 1.792181 3.020341 3.847436 4.596763 5.591621 1.5907045 3.799440
#> 3    C 4.291115 2.748245 3.259357 4.376054 5.407812 5.664107 1.4225623 2.915862
#> 4    D 4.426128 3.763253 4.139671 4.309440 4.595897 5.322381 0.6516206 1.559127
#> 5    E 5.200088 4.353736 4.981601 5.391255 5.609743 5.664107 0.6013896 1.310371
```
