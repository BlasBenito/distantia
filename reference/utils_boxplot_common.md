# Common Boxplot Component of `distantia_boxplot()` and `momentum_boxplot()`

Common Boxplot Component of
[`distantia_boxplot()`](https://blasbenito.github.io/distantia/reference/distantia_boxplot.md)
and
[`momentum_boxplot()`](https://blasbenito.github.io/distantia/reference/momentum_boxplot.md)

## Usage

``` r
utils_boxplot_common(
  variable = NULL,
  value = NULL,
  fill_color = NULL,
  f = median,
  main = NULL,
  xlab = NULL,
  ylab = NULL,
  text_cex = 1
)
```

## Arguments

- variable:

  (required, character vector) vector with variable or time series
  names. Default: NULL

- value:

  (required, numeric vector) vector of numeric values to compute the
  boxplot for. Must have the same length as `variable`. Default: NULL

- fill_color:

  (optional, character vector) boxplot fill color. Default: NULL

- f:

  (optional, function) function used to aggregate the input data frame
  and arrange the boxes. One of `mean` or `median`. Default: `median`.

- main:

  (optional, string) boxplot title. Default: NULL

- xlab:

  (optional, string) x axis label. Default: NULL

- ylab:

  (optional, string) y axis label. Default: NULL

- text_cex:

  (optional, numeric) Multiplier of the text size. Default: 1

## Value

boxplot

## See also

Other internal:
[`utils_check_args_distantia()`](https://blasbenito.github.io/distantia/reference/utils_check_args_distantia.md),
[`utils_check_args_matrix()`](https://blasbenito.github.io/distantia/reference/utils_check_args_matrix.md),
[`utils_check_args_momentum()`](https://blasbenito.github.io/distantia/reference/utils_check_args_momentum.md),
[`utils_check_args_path()`](https://blasbenito.github.io/distantia/reference/utils_check_args_path.md),
[`utils_check_args_tsl()`](https://blasbenito.github.io/distantia/reference/utils_check_args_tsl.md),
[`utils_check_args_zoo()`](https://blasbenito.github.io/distantia/reference/utils_check_args_zoo.md),
[`utils_check_distance_args()`](https://blasbenito.github.io/distantia/reference/utils_check_distance_args.md),
[`utils_check_list_class()`](https://blasbenito.github.io/distantia/reference/utils_check_list_class.md),
[`utils_clean_names()`](https://blasbenito.github.io/distantia/reference/utils_clean_names.md),
[`utils_digits()`](https://blasbenito.github.io/distantia/reference/utils_digits.md),
[`utils_distantia_df_split()`](https://blasbenito.github.io/distantia/reference/utils_distantia_df_split.md),
[`utils_prepare_df()`](https://blasbenito.github.io/distantia/reference/utils_prepare_df.md),
[`utils_prepare_matrix()`](https://blasbenito.github.io/distantia/reference/utils_prepare_matrix.md),
[`utils_prepare_matrix_list()`](https://blasbenito.github.io/distantia/reference/utils_prepare_matrix_list.md),
[`utils_prepare_time()`](https://blasbenito.github.io/distantia/reference/utils_prepare_time.md),
[`utils_prepare_vector_list()`](https://blasbenito.github.io/distantia/reference/utils_prepare_vector_list.md),
[`utils_prepare_zoo_list()`](https://blasbenito.github.io/distantia/reference/utils_prepare_zoo_list.md),
[`utils_tsl_pairs()`](https://blasbenito.github.io/distantia/reference/utils_tsl_pairs.md)

## Examples

``` r
utils_boxplot_common(
  variable = rep(x = c("a", "b"), times = 50),
  value = stats::runif(100)
)
```
