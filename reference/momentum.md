# Contribution of Individual Variables to Time Series Dissimilarity

This function measures the contribution of individual variables to the
dissimilarity between pairs of time series to help answer the question
*what makes two time series more or less similar?*

Three key values are required to assess individual variable
contributions:

- **psi**: dissimilarity when all variables are considered.

- **psi_only_with**: dissimilarity when using only the target variable.

- **psi_without**: dissimilarity when removing the target variable.

The values `psi_only_with` and `psi_without` can be computed in two
different ways defined by the argument `robust`.

- `robust = FALSE`: This method replicates the importance algorithm
  released with the first version of the package, and it is only
  recommended when the goal to compare new results with previous
  studies. It normalizes `psi_only_with` and `psi_without` using the
  least cost path obtained from the individual variable. As different
  variables may have different least cost paths for the same time
  series, normalization values may change from variable to variable,
  making individual importance scores harder to compare.

- `robust = TRUE` (default, recommended): This a novel version of the
  importance algorithm that yields more stable and comparable solutions.
  It uses the least cost path of the complete time series to normalize
  `psi_only_with` and `psi_without`, making importance scores of
  separate variables fully comparable.

The individual importance score of each variable (column "importance" in
the output data frame) is based on different expressions depending on
the `robust` argument, even when `lock_step = TRUE`:

- `robust = FALSE`: Importance is computed as
  `((psi - psi_without) * 100)/psi` and interpreted as "change in
  similarity when a variable is removed".

- `robust = TRUE`: Importance is computed as
  `((psi_only_with - psi_without) * 100)/psi` and interpreted as
  "relative dissimilarity induced by the variable expressed as a
  percentage".

In either case, positive values indicate that the variable contributes
to dissimilarity, while negative values indicate a net contribution to
similarity.

This function allows computing dissimilarity between pairs of time
series using different combinations of arguments at once. For example,
when the argument `distance` is set to `c("euclidean", "manhattan")`,
the output data frame will show two dissimilarity scores for each pair
of time series, one based on euclidean distances, and another based on
manhattan distances. The same happens for most other parameters.

This function supports a parallelization setup via
[`future::plan()`](https://future.futureverse.org/reference/plan.html),
and progress bars provided by the package
[progressr](https://CRAN.R-project.org/package=progressr).

## Usage

``` r
momentum(
  tsl = NULL,
  distance = "euclidean",
  diagonal = TRUE,
  bandwidth = 1,
  lock_step = FALSE,
  robust = TRUE
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

- lock_step:

  (optional, logical vector) If TRUE, time series captured at the same
  times are compared sample wise (with no dynamic time warping).
  Requires time series in argument `tsl` to be fully aligned, or it will
  return an error. Default: FALSE.

- robust:

  (required, logical). If TRUE (default), importance scores are computed
  using the least cost path of the complete time series as reference.
  Setting it to FALSE allows to replicate importance scores of the
  previous versions of this package. This option is irrelevant when
  `lock_step = TRUE`. Default: TRUE

## Value

data frame:

- `x`: name of the time series `x`.

- `y`: name of the time series `y`.

- `psi`: psi score of `x` and `y`.

- `variable`: name of the individual variable.

- `importance`: importance score of the variable.

- `effect`: interpretation of the "importance" column, with the values
  "increases similarity" and "decreases similarity".

- `psi_only_with`: psi score of the variable.

- `psi_without`: psi score without the variable.

- `psi_difference`: difference between `psi_only_with` and
  `psi_without`.

- `distance`: name of the distance metric.

- `diagonal`: value of the argument `diagonal`.

- `lock_step`: value of the argument `lock_step`.

- `robust`: value of the argument `robust`.

## See also

Other momentum:
[`momentum_dtw()`](https://blasbenito.github.io/distantia/reference/momentum_dtw.md),
[`momentum_ls()`](https://blasbenito.github.io/distantia/reference/momentum_ls.md)

## Examples

``` r
#progress bar
# progressr::handlers(global = TRUE)

tsl <- tsl_initialize(
  x = distantia::albatross,
  name_column = "name",
  time_column = "time"
) |>
  tsl_transform(
    f = f_scale_global
  )

df <- momentum(
  tsl = tsl,
  lock_step = TRUE #to speed-up example
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
