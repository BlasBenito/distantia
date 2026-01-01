# Lock-Step Variable Importance Analysis of Multivariate Time Series Lists

Minimalistic but slightly faster version of
[`momentum()`](https://blasbenito.github.io/distantia/reference/momentum.md)
to compute lock-step importance analysis in multivariate time series
lists.

## Usage

``` r
momentum_ls(tsl = NULL, distance = "euclidean")
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
[`momentum_dtw()`](https://blasbenito.github.io/distantia/reference/momentum_dtw.md)

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

df <- momentum_ls(
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
#> 1  X132 X134           x  245.695881 decreases similarity
#> 2  X132 X134           y  220.966902 decreases similarity
#> 3  X132 X134       speed  -39.219394 increases similarity
#> 4  X132 X134 temperature   20.212756 decreases similarity
#> 5  X132 X134     heading  -64.096435 increases similarity
#> 6  X132 X136           x  167.362857 decreases similarity
#> 7  X132 X136           y  179.922707 decreases similarity
#> 8  X132 X136       speed  -57.142101 increases similarity
#> 9  X132 X136 temperature  269.816263 decreases similarity
#> 10 X132 X136     heading -101.695710 increases similarity
#> 11 X132 X153           x  420.716726 decreases similarity
#> 12 X132 X153           y  193.801511 decreases similarity
#> 13 X132 X153       speed  -42.230768 increases similarity
#> 14 X132 X153 temperature  -17.262427 increases similarity
#> 15 X132 X153     heading  -79.506956 increases similarity
#> 16 X134 X136           x  172.225082 decreases similarity
#> 17 X134 X136           y  187.120048 decreases similarity
#> 18 X134 X136       speed  -61.142823 increases similarity
#> 19 X134 X136 temperature  253.045256 decreases similarity
#> 20 X134 X136     heading  -91.739169 increases similarity
#> 21 X134 X153           x  569.430986 decreases similarity
#> 22 X134 X153           y  163.217249 decreases similarity
#> 23 X134 X153       speed  -46.222266 increases similarity
#> 24 X134 X153 temperature    4.694732 decreases similarity
#> 25 X134 X153     heading  -88.399757 increases similarity
#> 26 X136 X153           x  507.615364 decreases similarity
#> 27 X136 X153           y   56.695744 decreases similarity
#> 28 X136 X153       speed  -65.451610 increases similarity
#> 29 X136 X153 temperature  240.905381 decreases similarity
#> 30 X136 X153     heading -116.246193 increases similarity
```
