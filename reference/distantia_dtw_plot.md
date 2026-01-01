# Two-Way Dissimilarity Plots of Time Series Lists

Plots two sequences, their distance or cost matrix, their least cost
path, and all relevant values used to compute dissimilarity.

Unlike
[`distantia()`](https://blasbenito.github.io/distantia/reference/distantia.md),
this function does not accept vectors as inputs for the arguments to
compute dissimilarity (`distance`, `diagonal`, and `weighted`), and only
plots a pair of sequences at once.

The argument `lock_step` is not available because this plot does not
make sense in such a case.

## Usage

``` r
distantia_dtw_plot(
  tsl = NULL,
  distance = "euclidean",
  diagonal = TRUE,
  bandwidth = 1,
  matrix_type = "cost",
  matrix_color = NULL,
  path_width = 1,
  path_color = "black",
  diagonal_width = 1,
  diagonal_color = "white",
  line_color = NULL,
  line_width = 1,
  text_cex = 1
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

- diagonal:

  (optional, logical vector). If TRUE, diagonals are included in the
  dynamic time warping computation. Default: TRUE

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

- matrix_type:

  (optional, character string): one of "cost" or "distance" (the
  abbreviation "dist" is accepted as well). Default: "cost".

- matrix_color:

  (optional, character vector) vector of colors for the distance or cost
  matrix. If NULL, uses the palette "Zissou 1" provided by the function
  [`grDevices::hcl.colors()`](https://rdrr.io/r/grDevices/palettes.html).
  Default: NULL

- path_width:

  (optional, numeric) width of the least cost path. Default: 1

- path_color:

  (optional, character string) color of the least-cost path. Default:
  "black"

- diagonal_width:

  (optional, numeric) width of the diagonal. Set to 0 to remove the
  diagonal line. Default: 0.5

- diagonal_color:

  (optional, character string) color of the diagonal. Default: "white"

- line_color:

  (optional, character vector) Vector of colors for the time series
  plot. If not provided, defaults to a subset of `matrix_color`.

- line_width:

  (optional, numeric vector) Width of the time series plot. Default: 1

- text_cex:

  (optional, numeric) Multiplier of the text size. Default: 1

## Value

multipanel plot

## See also

Other distantia:
[`distantia()`](https://blasbenito.github.io/distantia/reference/distantia.md),
[`distantia_dtw()`](https://blasbenito.github.io/distantia/reference/distantia_dtw.md),
[`distantia_ls()`](https://blasbenito.github.io/distantia/reference/distantia_ls.md)

## Examples

``` r
#three time series
#climate and ndvi in Fagus sylvatica stands in Spain, Germany, and Sweden
#convert to time series list
#scale and center to neutralize effect of different scales in temperature, rainfall, and ndvi
tsl <- tsl_initialize(
  x = fagus_dynamics,
  name_column = "name",
  time_column = "time"
) |>
  tsl_transform(
    f = f_scale_global #see help(f_scale_global)
  )

if(interactive()){
  tsl_plot(
    tsl = tsl,
    guide_columns = 3
    )
}

#visualize dynamic time warping
if(interactive()){

  #plot pair with cost matrix (default)
  distantia_dtw_plot(
    tsl = tsl[c("Spain", "Sweden")] #only two time series!
  )

  #plot pair with distance matrix
  distantia_dtw_plot(
    tsl = tsl[c("Spain", "Sweden")],
    matrix_type = "distance"
  )

  #plot pair with different distance
  distantia_dtw_plot(
    tsl = tsl[c("Spain", "Sweden")],
    distance = "manhattan", #sed data(distances)
    matrix_type = "distance"
  )


  #with different colors
  distantia_dtw_plot(
    tsl = tsl[c("Spain", "Sweden")],
    matrix_type = "distance",
    matrix_color = grDevices::hcl.colors(
      n = 100,
      palette = "Inferno"
    ),
    path_color = "white",
    path_width = 2,
    line_color = grDevices::hcl.colors(
      n = 3, #same as variables in tsl
      palette = "Inferno"
    )
  )

}
```
