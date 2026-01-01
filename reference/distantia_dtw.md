# Dynamic Time Warping Dissimilarity Analysis of Time Series Lists

Minimalistic but slightly faster version of
[`distantia()`](https://blasbenito.github.io/distantia/reference/distantia.md)
to compute dynamic time warping dissimilarity scores using diagonal
least cost paths.

## Usage

``` r
distantia_dtw(tsl = NULL, distance = "euclidean")
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

## Value

data frame with columns:

- `x`: time series name.

- `y`: time series name.

- `distance`: name of the distance metric.

- `psi`: psi dissimilarity of the sequences `x` and `y`.

## See also

Other distantia:
[`distantia()`](https://blasbenito.github.io/distantia/reference/distantia.md),
[`distantia_dtw_plot()`](https://blasbenito.github.io/distantia/reference/distantia_dtw_plot.md),
[`distantia_ls()`](https://blasbenito.github.io/distantia/reference/distantia_ls.md)

## Examples

``` r
#load fagus_dynamics as tsl
#global centering and scaling
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

#dynamic time warping dissimilarity analysis
df_dtw <- distantia_dtw(
  tsl = tsl,
  distance = "euclidean"
)

df_dtw[, c("x", "y", "psi")]
#>         x      y       psi
#> 2 Germany Sweden 0.8437535
#> 1 Germany  Spain 1.3533551
#> 3   Spain Sweden 1.4640024

#visualize dynamic time warping
if(interactive()){

  distantia_dtw_plot(
    tsl = tsl[c("Spain", "Sweden")],
    distance = "euclidean"
  )

}

```
