## Version 2.0.3

- Fixed ambiguous usage of argument `seed` in `zoo_permute()` as global/local variable within a %dofuture% loop. Thanks to `@henrikbengtsson@mastodon.social` for this patch!

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


