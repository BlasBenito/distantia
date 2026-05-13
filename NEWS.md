## Version 2.0.3

- Fixed `momentum_stats()`: `stats::aggregate(x = df, by = importance ~ variable, ...)` used a formula as the `by` argument to `aggregate.data.frame`, which is an invalid interface. Changed to the formula interface: `stats::aggregate(importance ~ variable, data = df, ...)`. Also added `na.rm = TRUE` to the `q1` and `q3` summary functions, and added an up-front warning that names the count of excluded `NA` importance values before they are filtered from the summary computation.

- Fixed `psi_null_dtw_cpp()` in `src/psi.cpp`: the `bandwidth` argument was forwarded to all permuted `cost_path_cpp()` calls but was silently omitted from the initial (observed) `cost_path_cpp()` call, causing `psi_null[0]` (the observed psi in the null distribution) to be computed without the Sakoe-Chiba constraint when `bandwidth < 1`. The initial call now passes `bandwidth` consistently.

- Fixed `zoo_aggregate()`: `attributes(x)$name` used R's `$` partial matching and could return column names instead of `NULL` for zoo objects lacking the custom `"name"` attribute. Changed to `attr(x, "name", exact = TRUE)` for consistency with the fix applied to `zoo_name_get()`.

- Removed unused dead assignment `x_name <- attributes(x)$name` from `zoo_name_set()` (the computed value was never referenced).

- Fixed `distantia_aggregate()` aggregate call: `stats::aggregate(x = df, by = psi ~ x + y, ...)` used a formula as the `by` argument to `aggregate.data.frame`, which is an invalid interface and would error when multiple parameter combinations were present. Changed to the formula interface: `stats::aggregate(psi ~ x + y, data = df, ...)`.

- Fixed `distantia_stats()`: `q1` and `q3` summary functions called `stats::quantile()` without `na.rm = TRUE`, causing an error when any `psi` value was `NA`. Added `na.rm = TRUE` to both functions. Added an up-front warning that names the count of excluded `NA` psi values before they are filtered from the summary computation.

- Fixed `distantia_spatial()`: when no column in the `sf` argument contained all time series names from `df`, the function crashed with a cryptic "argument is of length zero" error. Now emits an informative error message. Also made column selection deterministic by always using the first matching column when multiple columns satisfy the name-matching criterion.

- Fixed `zoo_name_get()`: `attributes(x)$name` used R's partial matching via the `$` operator and returned `names(x)` (e.g., date strings from the zoo index) instead of `NULL` for zoo objects lacking the custom `"name"` attribute. Changed to `attr(x, which = "name", exact = TRUE)` to suppress partial matching.

- Fixed `zoo_vector_to_matrix()`: the `"name"` attribute of the input zoo was not preserved in the output. The call `zoo_name_set(x = y, name = y)` passed the zoo object itself instead of the extracted character name `x_name`; the guard `if(!is.character(name))` in `zoo_name_set()` silently returned `y` unchanged, dropping the name. Fixed by changing `name = y` to `name = x_name`, and by replacing the internal `zoo_name_get()` call with `attr(x, "name", exact = TRUE)` to avoid the partial-matching issue.

- Fixed uninformative crash in `tsl_initialize()` when `x` is a list with fewer than 2 time series. A non-list code path in `utils_prepare_time()` was reached before the structural guard, producing the cryptic error `'from' must be a finite number`. Now an explicit early check fires with: `argument 'x' must have at least 2 time series.`

- Fixed `tsl_diagnose()` calling `utils_check_args_tsl(min_length = 1)`, which allowed single-element TSLs to pass validation. Changed to `min_length = 2` to match the documented invariant (≥2 members required).

- Fixed `distantia_spatial()` silently returning an invalid (zero-length) linestring when two time series share identical spatial coordinates. Now emits an informative warning naming the offending pair(s).

- Fixed divide-by-zero in `utils_rescale_vector()` when all values of `x` are identical (`old_min == old_max`). Previously returned `NaN`; now returns a vector of `new_min` values.

- Fixed crash in `utils_cluster_silhouette()` when all items belong to a single cluster (`k = 1`). Previously produced empty matrices and errors; now returns `NA` silhouette widths (data frame) or `NA_real_` (when `mean = TRUE`).

- Fixed `NA` breaks in `utils_color_breaks()` when `n = 1`. Previously `a[2]` was `NA`, corrupting all breaks; now returns a length-2 vector spanning the data range ± 0.5.

- Fixed missing row-count validation in `psi_distance_lock_step()`: unequal-length series now produce an informative error before reaching C++.

- Fixed `distantia_stats()` aggregate call: `stats::aggregate(x = df, by = psi ~ name, ...)` used a formula as the `by` argument, which is not the valid interface for `aggregate.data.frame` and would error. Changed to the formula interface: `stats::aggregate(psi ~ name, data = df, ...)`.

- `distantia_dtw()` now accepts a `bandwidth` argument (Sakoe-Chiba constraint,
  default `1` = unconstrained) forwarded to `psi_dtw_cpp()`. The hardcoded
  `diagonal = TRUE` sign convention is confirmed correct: psi = 0 for identical series.

- `distantia_ls()`: added missing `distance` and `lock_step` columns to the
  return data frame so that the output matches `distantia(lock_step = TRUE)`;
  sign convention (`+1` for lock-step via `psi_equation_cpp(..., diagonal = TRUE)`)
  confirmed correct and covered by a new test.

- Fixed crash in `distantia()` when `repetitions = NULL` was passed explicitly
  (was coerced to `logical(0)` in the `if` guard). Now treated as `repetitions = 0`.

- `distantia_time_delay()`: removed spurious `[1]` subscript on `q3` assignment (line 223) to match all other stat assignments in the same loop (harmless but inconsistent).

- Fixed silent no-op renames in `distantia_spatial()` (lines 259 & 268) where `colnames(df)[colnames(df) == "name"]` targeted the wrong column. The merge-produced `id` column was never renamed to `id_x`/`id_y`; R's auto-suffix fallback produced `id.x`/`id.y` instead. Corrected target to `"id"` and updated all downstream references from dot-suffixed to underscore-suffixed names.

- `psi_equation()` now returns `NA` instead of `Inf`/`NaN` when the
  auto-sum denominator is zero (flat/constant time series).


- Fixed bug in `src/distance_methods.cpp` where `bray_curtis` and `sorensen` distance methods used the wrong 3-character abbreviation prefix (`"hel"` instead of `"bra"` and `"sor"`, respectively), causing an error when these distances were selected via their abbreviation inside C++.

- Fixed ambiguous usage of argument `seed` in `zoo_permute()` as global/local variable within a %dofuture% loop. Thanks to `@henrikbengtsson@mastodon.social` for this patch!

- Fixed issue in `distantia_model_frame()`, where `scale = TRUE` was not applied to `composite_predictors` or `geographic_distance`.

- Renamed argument `two_way` in `distantia_time_delay()` to `directional` and improved the documentation.


## Version 2.0.2

- Fixed error (r-devel only) in test file `tests/testthat/test-utils_new_time.R`

- Function `zoo_plot()` now has the argument `guide_position` to modify the legend position.

## Version 2.0.1

- Fixed bug in function `cost_matrix_diagonal_weighted_cpp()` where the additional weight of the diagonal movement was not being correctly applied. This change will result in slightly different `psi` values in `distantia()`, `distantia_dtw()`, and `distantia_dtw_plot()` when `diagonal = TRUE` (default).

- Fixed bug in function `cost_path_cpp`, which still produced diagonal cost matrices when `diagonal = FALSE` because `weighted = TRUE` turned `diagonal` to `TRUE`. Now `weighted` is set to `FALSE` when `diagonal = FALSE`. This resulted in negative scores for orthogonal least-cost paths.

- All C++ functions returning values of type double to R functions now round their output to the 8th decimal. This should mitigate discrepancies between R and C++ functions due to differences in how these systems round floating point numbers.

## Version 2.0.0

- This new version involves a massive rewrite that will break any previous code based on this package. To install the previous version (1.0.2):
  
```r
#install from CRAN archive
remotes::install_version(
  package = "distantia", 
  version = "1.0.2"
  )

#install from archive branch in GitHub
remotes::install_github(
  repo = "https://github.com/BlasBenito/distantia",
  ref = "v1.0.2"
  )
```

- Version 2.0.0 is a complete package rewrite from the ground up:

    - All core functions have been rewritten in C++ for increased speed and memory efficiency, and proper R wrappers for these functions are provided.
    
    - All functions and their arguments follow more modern naming conventions, and simplified interfaces to improve the user experience.
    
    - Most time series operations use the [zoo](https://CRAN.R-project.org/package=zoo) library underneath, ensuring data consistency, computational speed, and memory efficiency.
    
    - Lists of zoo objects, named "time series lists" ("tsl" for short) throughout the package documentation, are used to organize time series data.
    
    - A complete toolset to manage time series lists is provided. All functions belonging are named using the prefix `tsl_...()`. There are tools to generate, aggregate, resample, transform, plot, map, and analyze univariate or multivariate regular or irregular time series.
    
    - Most functions taking time series lists as inputs are parallelized using the [future](https://CRAN.R-project.org/package=future) package, and progress bars for parallelized operations are available as well via the [progressr](https://CRAN.R-project.org/package=progressr) package.
    
    - New example datasets from different disciplines and functions to generate simulated time series are shipped with the package to improve the learning experience.

## Version 1.0.3

Fixed bug in Hellinger distances and reworked the distance() function to make it slightly faster.

## Version 1.0.2

Fixed an issue with the parallelization of tasks in the Windows platform. Now all parallelized functions modify their cluster settings depending on the user's platform.

## Version 1.0.1

Fixed a bug in the function **workflowImportance**. The argument 'exclude.columns' was being ignored.

Fixed the documentation of the functions **workflowImportance** and **workflowSlotting**. Their outputs were not well documented.

Fixed an error in workflowTransfer.

Changed how psi is computed. It's now more respectful with the original formulation, and handles very similar sequences better.

Fixed the function **workflowPsi** to add +1 to the least cost produced by the options paired.samples = TRUE and diagonal = TRUE

Added the function **workflowPsiHP**, a High Performance version of **workflowPsi**. It has less options, but it is much faster, and has a much lower memory footprint.

## Version 1.0.0 is ready!


