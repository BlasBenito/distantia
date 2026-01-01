# Momentum Boxplot

Boxplot of a data frame returned by
[`momentum()`](https://blasbenito.github.io/distantia/reference/momentum.md)
summarizing the contribution to similarity (negative) and/or
dissimilarity (positive) of individual variables across all time series.

## Usage

``` r
momentum_boxplot(df = NULL, fill_color = NULL, f = median, text_cex = 1)
```

## Arguments

- df:

  (required, data frame) Output of
  [`momentum()`](https://blasbenito.github.io/distantia/reference/momentum.md),
  [`momentum_ls()`](https://blasbenito.github.io/distantia/reference/momentum_ls.md),
  or
  [`momentum_dtw()`](https://blasbenito.github.io/distantia/reference/momentum_dtw.md).
  Default: NULL

- fill_color:

  (optional, character vector) boxplot fill color. Default: NULL

- f:

  (optional, function) Function to summarize psi scores (for example,
  `mean`) when there are several combinations of parameters in `df`.
  Ignored when there is a single combination of arguments in the input.
  Default: `mean`

- text_cex:

  (optional, numeric) Multiplier of the text size. Default: 1

## Value

boxplot

## See also

Other momentum_support:
[`momentum_aggregate()`](https://blasbenito.github.io/distantia/reference/momentum_aggregate.md),
[`momentum_model_frame()`](https://blasbenito.github.io/distantia/reference/momentum_model_frame.md),
[`momentum_spatial()`](https://blasbenito.github.io/distantia/reference/momentum_spatial.md),
[`momentum_stats()`](https://blasbenito.github.io/distantia/reference/momentum_stats.md),
[`momentum_to_wide()`](https://blasbenito.github.io/distantia/reference/momentum_to_wide.md)

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

df <- momentum(
  tsl = tsl,
  lock_step = TRUE
  )

momentum_boxplot(
  df = df
  )
```
