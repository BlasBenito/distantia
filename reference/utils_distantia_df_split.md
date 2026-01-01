# Split Dissimilarity Analysis Data Frames by Combinations of Arguments

Internal function to split a distantia data frame by groups of the
arguments 'distance', 'diagonal', and 'lock_step'.

## Usage

``` r
utils_distantia_df_split(df = NULL)
```

## Arguments

- df:

  (required, data frame) Output of
  [`distantia()`](https://blasbenito.github.io/distantia/reference/distantia.md)
  or
  [`distantia_aggregate()`](https://blasbenito.github.io/distantia/reference/distantia_aggregate.md).
  Default: NULL

## Value

list

## See also

Other internal:
[`utils_boxplot_common()`](https://blasbenito.github.io/distantia/reference/utils_boxplot_common.md),
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
[`utils_prepare_df()`](https://blasbenito.github.io/distantia/reference/utils_prepare_df.md),
[`utils_prepare_matrix()`](https://blasbenito.github.io/distantia/reference/utils_prepare_matrix.md),
[`utils_prepare_matrix_list()`](https://blasbenito.github.io/distantia/reference/utils_prepare_matrix_list.md),
[`utils_prepare_time()`](https://blasbenito.github.io/distantia/reference/utils_prepare_time.md),
[`utils_prepare_vector_list()`](https://blasbenito.github.io/distantia/reference/utils_prepare_vector_list.md),
[`utils_prepare_zoo_list()`](https://blasbenito.github.io/distantia/reference/utils_prepare_zoo_list.md),
[`utils_tsl_pairs()`](https://blasbenito.github.io/distantia/reference/utils_tsl_pairs.md)

## Examples

``` r
#three time series
#climate and ndvi in Fagus sylvatica stands in Spain, Germany, and Sweden
tsl <- tsl_initialize(
  x = fagus_dynamics,
  name_column = "name",
  time_column = "time"
)

#dissimilarity analysis with four combinations of parameters
df <- distantia(
  tsl = tsl,
  distance = c(
    "euclidean",
    "manhattan"
    ),
  lock_step = c(
    TRUE,
    FALSE
  )
)

#split by combinations of parameters
df_split <- utils_distantia_df_split(
  df = df
)

#print output
df_split
#> $`1`
#>    distance diagonal lock_step       x      y bandwidth       psi group
#> 4 euclidean     TRUE     FALSE Germany Sweden         1 0.6690893     1
#> 5 euclidean     TRUE     FALSE Germany  Spain         1 0.9174141     1
#> 6 euclidean     TRUE     FALSE   Spain Sweden         1 0.8673070     1
#> 
#> $`2`
#>     distance diagonal lock_step       x      y bandwidth       psi group
#> 10 manhattan     TRUE     FALSE   Spain Sweden         1 0.9630803     2
#> 11 manhattan     TRUE     FALSE Germany  Spain         1 1.0138670     2
#> 12 manhattan     TRUE     FALSE Germany Sweden         1 0.7067959     2
#> 
#> $`3`
#>    distance diagonal lock_step       x      y bandwidth       psi group
#> 7 manhattan       NA      TRUE Germany Sweden        NA 0.8271986     3
#> 8 manhattan       NA      TRUE   Spain Sweden        NA 1.5755002     3
#> 9 manhattan       NA      TRUE Germany  Spain        NA 1.3737381     3
#> 
#> $`4`
#>    distance diagonal lock_step       x      y bandwidth       psi group
#> 1 euclidean       NA      TRUE Germany  Spain        NA 1.3962157     4
#> 2 euclidean       NA      TRUE   Spain Sweden        NA 1.5703931     4
#> 3 euclidean       NA      TRUE Germany Sweden        NA 0.8364653     4
#> 

#class and length of the output
class(df_split)
#> [1] "list"
length(df_split)
#> [1] 4
```
