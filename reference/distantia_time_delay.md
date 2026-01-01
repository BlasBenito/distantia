# Time Delay Between Time Series

This function computes an approximation to the time-delay between pairs
of time series as the difference between observations connected by the
dynamic time warping path.

If the time series have more than 30 observations, a 5% of the cases are
omitted at each extreme of the warping path to avoid overestimating time
delays due to early misalignments.

The function returns a data frame with the names of the time series in
the columns *x* and *y*, and the modal, mean, and median of the time
delay. The modal and the median are the most generally accurate
time-delay metrics

This function requires scaled and detrended time series. Still, it might
yield non-sensical results in case of degenerate warping paths. Plotting
dubious results with \[distantia_dtw_plot())\] is always a good approach
to identify these cases.

\[distantia_dtw_plot())\]: R:distantia_dtw_plot())

## Usage

``` r
distantia_time_delay(
  tsl = NULL,
  distance = "euclidean",
  bandwidth = 1,
  directional = FALSE
)
```

## Arguments

- tsl:

  (required, time series list) list of zoo time series. Default: NULL

- distance:

  (optional, character vector) name or abbreviation of the distance
  method. Valid values are in the columns "names" and "abbreviation" of
  the dataset
  [distances](https://blasbenito.github.io/distantia/reference/distances.md).
  Default: "euclidean".

- bandwidth:

  (optional, numeric) Proportion of space at each side of the cost
  matrix diagonal (aka *Sakoe-Chiba band*) defining a valid region for
  dynamic time warping, used to control the flexibility of the warping
  path. This method prevents degenerate alignments due to differences in
  magnitude between time series when the data is not properly scaled. If
  `1` (default), DTW is unconstrained. If `0`, DTW is fully constrained
  and the warping path follows the matrix diagonal. Recommended values
  may vary depending on the nature of the data. Ignored if
  `lock_step = TRUE`. Default: 1.

- directional:

  (optional, logical) If TRUE, a directional time delay is computed as
  `x to y` and `y to x`, resulting in two rows per pair of time series.
  Otherwise, the absolute magnitude of de delay between `x` and `y` is
  returned a a single row per pair. Default: TRUE

## Value

data frame

## See also

Other distantia_support:
[`distantia_aggregate()`](https://blasbenito.github.io/distantia/reference/distantia_aggregate.md),
[`distantia_boxplot()`](https://blasbenito.github.io/distantia/reference/distantia_boxplot.md),
[`distantia_cluster_hclust()`](https://blasbenito.github.io/distantia/reference/distantia_cluster_hclust.md),
[`distantia_cluster_kmeans()`](https://blasbenito.github.io/distantia/reference/distantia_cluster_kmeans.md),
[`distantia_matrix()`](https://blasbenito.github.io/distantia/reference/distantia_matrix.md),
[`distantia_model_frame()`](https://blasbenito.github.io/distantia/reference/distantia_model_frame.md),
[`distantia_spatial()`](https://blasbenito.github.io/distantia/reference/distantia_spatial.md),
[`distantia_stats()`](https://blasbenito.github.io/distantia/reference/distantia_stats.md),
[`utils_block_size()`](https://blasbenito.github.io/distantia/reference/utils_block_size.md),
[`utils_cluster_hclust_optimizer()`](https://blasbenito.github.io/distantia/reference/utils_cluster_hclust_optimizer.md),
[`utils_cluster_kmeans_optimizer()`](https://blasbenito.github.io/distantia/reference/utils_cluster_kmeans_optimizer.md),
[`utils_cluster_silhouette()`](https://blasbenito.github.io/distantia/reference/utils_cluster_silhouette.md)

## Examples

``` r
#load two long-term temperature time series
#local scaling to focus in shape rather than values
#polynomial detrending to make them stationary
tsl <- tsl_init(
  x = cities_temperature[
    cities_temperature$name %in% c("London", "Kinshasa"),
    ],
  name = "name",
  time = "time"
) |>
  tsl_transform(
    f = f_scale_local
  ) |>
  tsl_transform(
    f = f_detrend_poly,
    degree = 35 #data years
  )


if(interactive()){
  tsl_plot(
    tsl = tsl,
    guide = FALSE
  )
}

#compute shifts
df_shift <- distantia_time_delay(
  tsl = tsl,
  directional = TRUE
)

df_shift
#>          x        y  distance units  min      q1 median modal      mean     q3
#> 1 Kinshasa   London euclidean  days -304 -215.00   -184  -212 -115.7031  89.75
#> 2   London Kinshasa euclidean  days -243  -89.75    184   212  115.7031 215.00
#>   max
#> 1 243
#> 2 304
#positive shift values indicate
#that the samples in Kinshasa
#are aligned with older samples in London.
```
