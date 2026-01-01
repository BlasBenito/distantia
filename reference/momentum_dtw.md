# Dynamic Time Warping Variable Importance Analysis of Multivariate Time Series Lists

Minimalistic but slightly faster version of
[`momentum()`](https://blasbenito.github.io/distantia/reference/momentum.md)
to compute dynamic time warping importance analysis with the "robust"
setup in multivariate time series lists.

## Usage

``` r
momentum_dtw(tsl = NULL, distance = "euclidean")
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

data frame:

- `x`: name of the time series `x`.

- `y`: name of the time series `y`.

- `psi`: psi score of `x` and `y`.

- `variable`: name of the individual variable.

- `importance`: importance score of the variable.

- `effect`: interpretation of the "importance" column, with the values
  "increases similarity" and "decreases similarity".

## See also

Other momentum:
[`momentum()`](https://blasbenito.github.io/distantia/reference/momentum.md),
[`momentum_ls()`](https://blasbenito.github.io/distantia/reference/momentum_ls.md)

## Examples

``` r
tsl <- tsl_initialize(
  x = distantia::albatross,
  name_column = "name",
  time_column = "time"
) |>
  tsl_transform(
    f = f_scale_global
  )

df <- momentum_dtw(
  tsl = tsl,
  distance = "euclidean"
  )

#focus on important columns
df[, c(
  "x",
  "y",
  "variable",
  "importance",
  "effect"
  )]
#>       x    y    variable  importance               effect
#> 1  X132 X134           x   89.721187 decreases similarity
#> 2  X132 X134           y  101.305396 decreases similarity
#> 3  X132 X134       speed  -28.286386 increases similarity
#> 4  X132 X134 temperature   78.130508 decreases similarity
#> 5  X132 X134     heading  -43.644053 increases similarity
#> 6  X132 X136           x   15.687570 decreases similarity
#> 7  X132 X136           y   82.867368 decreases similarity
#> 8  X132 X136       speed  -67.196851 increases similarity
#> 9  X132 X136 temperature  382.039900 decreases similarity
#> 10 X132 X136     heading -104.245839 increases similarity
#> 11 X132 X153           x  467.261463 decreases similarity
#> 12 X132 X153           y  159.727491 decreases similarity
#> 13 X132 X153       speed  -44.549191 increases similarity
#> 14 X132 X153 temperature   -4.016121 increases similarity
#> 15 X132 X153     heading  -88.852346 increases similarity
#> 16 X134 X136           x   36.205194 decreases similarity
#> 17 X134 X136           y   90.757712 decreases similarity
#> 18 X134 X136       speed  -61.923595 increases similarity
#> 19 X134 X136 temperature  348.244258 decreases similarity
#> 20 X134 X136     heading  -96.737145 increases similarity
#> 21 X134 X153           x  761.132445 decreases similarity
#> 22 X134 X153           y   26.329542 decreases similarity
#> 23 X134 X153       speed  -62.801312 increases similarity
#> 24 X134 X153 temperature  -23.264433 increases similarity
#> 25 X134 X153     heading  -76.874072 increases similarity
#> 26 X136 X153           x  530.402462 decreases similarity
#> 27 X136 X153           y   24.217594 decreases similarity
#> 28 X136 X153       speed  -67.659029 increases similarity
#> 29 X136 X153 temperature  255.711643 decreases similarity
#> 30 X136 X153     heading -119.877355 increases similarity
```
