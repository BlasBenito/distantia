# Handle NA Cases in Time Series Lists

Removes or imputes NA cases in time series lists. Imputation is done via
interpolation against time via
[`zoo::na.approx()`](https://rdrr.io/pkg/zoo/man/na.approx.html), and if
there are still leading or trailing NA cases after NA interpolation,
then [`zoo::na.spline()`](https://rdrr.io/pkg/zoo/man/na.approx.html) is
applied as well to fill these gaps. Interpolated values are forced to
fall within the observed data range.

This function supports a parallelization setup via
[`future::plan()`](https://future.futureverse.org/reference/plan.html),
and progress bars provided by the package
[progressr](https://CRAN.R-project.org/package=progressr).

## Usage

``` r
tsl_handle_NA(tsl = NULL, na_action = c("impute", "omit"))

tsl_Inf_to_NA(tsl = NULL)

tsl_NaN_to_NA(tsl = NULL)
```

## Arguments

- tsl:

  (required, list) Time series list. Default: NULL

- na_action:

  (required, character) NA handling action. Available options are:

  - "impute" (default): NA cases are interpolated from neighbors as a
    function of time (see
    [`zoo::na.approx()`](https://rdrr.io/pkg/zoo/man/na.approx.html) and
    [`zoo::na.spline()`](https://rdrr.io/pkg/zoo/man/na.approx.html)).

  - "omit": rows with NA cases are removed.

## Value

time series list

## See also

Other tsl_management:
[`tsl_burst()`](https://blasbenito.github.io/distantia/reference/tsl_burst.md),
[`tsl_colnames_clean()`](https://blasbenito.github.io/distantia/reference/tsl_colnames_clean.md),
[`tsl_colnames_get()`](https://blasbenito.github.io/distantia/reference/tsl_colnames_get.md),
[`tsl_colnames_prefix()`](https://blasbenito.github.io/distantia/reference/tsl_colnames_prefix.md),
[`tsl_colnames_set()`](https://blasbenito.github.io/distantia/reference/tsl_colnames_set.md),
[`tsl_colnames_suffix()`](https://blasbenito.github.io/distantia/reference/tsl_colnames_suffix.md),
[`tsl_count_NA()`](https://blasbenito.github.io/distantia/reference/tsl_count_NA.md),
[`tsl_diagnose()`](https://blasbenito.github.io/distantia/reference/tsl_diagnose.md),
[`tsl_join()`](https://blasbenito.github.io/distantia/reference/tsl_join.md),
[`tsl_names_clean()`](https://blasbenito.github.io/distantia/reference/tsl_names_clean.md),
[`tsl_names_get()`](https://blasbenito.github.io/distantia/reference/tsl_names_get.md),
[`tsl_names_set()`](https://blasbenito.github.io/distantia/reference/tsl_names_set.md),
[`tsl_names_test()`](https://blasbenito.github.io/distantia/reference/tsl_names_test.md),
[`tsl_ncol()`](https://blasbenito.github.io/distantia/reference/tsl_ncol.md),
[`tsl_nrow()`](https://blasbenito.github.io/distantia/reference/tsl_nrow.md),
[`tsl_repair()`](https://blasbenito.github.io/distantia/reference/tsl_repair.md),
[`tsl_subset()`](https://blasbenito.github.io/distantia/reference/tsl_subset.md),
[`tsl_time()`](https://blasbenito.github.io/distantia/reference/tsl_time.md),
[`tsl_to_df()`](https://blasbenito.github.io/distantia/reference/tsl_to_df.md)

## Examples

``` r
#tsl with NA cases
tsl <- tsl_simulate(
  na_fraction = 0.25
)

tsl_count_NA(tsl = tsl)
#> $A
#> [1] 116
#> 
#> $B
#> [1] 103
#> 

if(interactive()){
  #issues warning
  tsl_plot(tsl = tsl)
}

#omit NA (default)
#--------------------------------------

#original row count
tsl_nrow(tsl = tsl)
#> $A
#> [1] 93
#> 
#> $B
#> [1] 83
#> 

#remove rows with NA
tsl_no_na <- tsl_handle_NA(
  tsl = tsl,
  na_action = "omit"
)

#count rows again
#large data loss in this case!
tsl_nrow(tsl = tsl_no_na)
#> $A
#> [1] 19
#> 
#> $B
#> [1] 18
#> 

#count NA again
tsl_count_NA(tsl = tsl_no_na)
#> $A
#> [1] 0
#> 
#> $B
#> [1] 0
#> 

if(interactive()){
  tsl_plot(tsl = tsl_no_na)
}


#impute NA with zoo::na.approx
#--------------------------------------

#impute NA cases
tsl_no_na <- tsl_handle_NA(
  tsl = tsl,
  na_action = "impute"
)

#count rows again
#large data loss in this case!
tsl_nrow(tsl = tsl_no_na)
#> $A
#> [1] 93
#> 
#> $B
#> [1] 83
#> 

if(interactive()){
  tsl_plot(tsl = tsl_no_na)
}
```
