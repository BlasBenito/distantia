# Package index

## Naming Conventions

The package follows these naming conventions:

- [`distantia()`](https://blasbenito.github.io/distantia/reference/distantia.md)
  and `distantia_...()`: functions to assess time series dissimilarity
  via dynamic time warping or lock-step methods.
- [`momentum()`](https://blasbenito.github.io/distantia/reference/momentum.md)
  and \`momentum\_…(): functions to assess variable contribution to
  dissimilarity in multivariate time series.
- `psi_...()`: step-by-step demonstration of how psi dissimilarity
  scores are computed.
- `tsl_...()`: functions to generate, process, and explore time series
  lists (TSLs).
- `f_...()`: transformation functions used as input arguments for other
  functions.
- `zoo_...()`: functions to manage zoo time series.
- `utils_...()`: internal functions and helpers.
- `..._cpp()`: C++ core functions built via
  [Rcpp](https://CRAN.R-project.org/package=Rcpp) for efficient
  dissimilarity analysis.

## Dissimilarity Analysis

Tools to compare time series via dynamic time warping or lock-step
methods.

- [`distantia()`](https://blasbenito.github.io/distantia/reference/distantia.md)
  : Dissimilarity Analysis of Time Series Lists
- [`distantia_dtw()`](https://blasbenito.github.io/distantia/reference/distantia_dtw.md)
  : Dynamic Time Warping Dissimilarity Analysis of Time Series Lists
- [`distantia_dtw_plot()`](https://blasbenito.github.io/distantia/reference/distantia_dtw_plot.md)
  : Two-Way Dissimilarity Plots of Time Series Lists
- [`distantia_ls()`](https://blasbenito.github.io/distantia/reference/distantia_ls.md)
  : Lock-Step Dissimilarity Analysis of Time Series Lists

## Support Functions for Dissimilarity Analysis

Functions to enhance dissimilarity analyses with new capabilities, such
as modelling, mapping, and clustering, among others.

- [`distantia_aggregate()`](https://blasbenito.github.io/distantia/reference/distantia_aggregate.md)
  :

  Aggregate
  [`distantia()`](https://blasbenito.github.io/distantia/reference/distantia.md)
  Data Frames Across Parameter Combinations

- [`distantia_boxplot()`](https://blasbenito.github.io/distantia/reference/distantia_boxplot.md)
  : Distantia Boxplot

- [`distantia_cluster_hclust()`](https://blasbenito.github.io/distantia/reference/distantia_cluster_hclust.md)
  : Hierarchical Clustering of Dissimilarity Analysis Data Frames

- [`distantia_cluster_kmeans()`](https://blasbenito.github.io/distantia/reference/distantia_cluster_kmeans.md)
  : K-Means Clustering of Dissimilarity Analysis Data Frames

- [`distantia_matrix()`](https://blasbenito.github.io/distantia/reference/distantia_matrix.md)
  : Convert Dissimilarity Analysis Data Frame to Distance Matrix

- [`distantia_model_frame()`](https://blasbenito.github.io/distantia/reference/distantia_model_frame.md)
  : Dissimilarity Model Frame

- [`distantia_spatial()`](https://blasbenito.github.io/distantia/reference/distantia_spatial.md)
  :

  Spatial Representation of
  [`distantia()`](https://blasbenito.github.io/distantia/reference/distantia.md)
  Data Frames

- [`distantia_stats()`](https://blasbenito.github.io/distantia/reference/distantia_stats.md)
  : Stats of Dissimilarity Data Frame

- [`distantia_time_delay()`](https://blasbenito.github.io/distantia/reference/distantia_time_delay.md)
  : Time Delay Between Time Series

- [`utils_block_size()`](https://blasbenito.github.io/distantia/reference/utils_block_size.md)
  : Default Block Size for Restricted Permutation in Dissimilarity
  Analyses

- [`utils_cluster_hclust_optimizer()`](https://blasbenito.github.io/distantia/reference/utils_cluster_hclust_optimizer.md)
  : Optimize the Silhouette Width of Hierarchical Clustering Solutions

- [`utils_cluster_kmeans_optimizer()`](https://blasbenito.github.io/distantia/reference/utils_cluster_kmeans_optimizer.md)
  : Optimize the Silhouette Width of K-Means Clustering Solutions

- [`utils_cluster_silhouette()`](https://blasbenito.github.io/distantia/reference/utils_cluster_silhouette.md)
  : Compute Silhouette Width of a Clustering Solution

## Variable Importance Analysis

Tools to assess the contribution of individual variables to the
dissimilarity between multivariate time series.

- [`momentum()`](https://blasbenito.github.io/distantia/reference/momentum.md)
  : Contribution of Individual Variables to Time Series Dissimilarity
- [`momentum_dtw()`](https://blasbenito.github.io/distantia/reference/momentum_dtw.md)
  : Dynamic Time Warping Variable Importance Analysis of Multivariate
  Time Series Lists
- [`momentum_ls()`](https://blasbenito.github.io/distantia/reference/momentum_ls.md)
  : Lock-Step Variable Importance Analysis of Multivariate Time Series
  Lists

## Support Functions for Variable Importance Analysis

Functions to enhance variable importance analyses.

- [`momentum_aggregate()`](https://blasbenito.github.io/distantia/reference/momentum_aggregate.md)
  :

  Aggregate
  [`momentum()`](https://blasbenito.github.io/distantia/reference/momentum.md)
  Data Frames Across Parameter Combinations

- [`momentum_boxplot()`](https://blasbenito.github.io/distantia/reference/momentum_boxplot.md)
  : Momentum Boxplot

- [`momentum_model_frame()`](https://blasbenito.github.io/distantia/reference/momentum_model_frame.md)
  : Dissimilarity Model Frame

- [`momentum_spatial()`](https://blasbenito.github.io/distantia/reference/momentum_spatial.md)
  :

  Spatial Representation of
  [`momentum()`](https://blasbenito.github.io/distantia/reference/momentum.md)
  Data Frames

- [`momentum_stats()`](https://blasbenito.github.io/distantia/reference/momentum_stats.md)
  : Stats of Dissimilarity Data Frame

- [`momentum_to_wide()`](https://blasbenito.github.io/distantia/reference/momentum_to_wide.md)
  : Momentum Data Frame to Wide Format

## C++ Backend

These functions, designed to boost the computational efficiency of the
package, implement all dissimilarity methods available in
[`distantia()`](https://blasbenito.github.io/distantia/reference/distantia.md)
and
[`momentum()`](https://blasbenito.github.io/distantia/reference/momentum.md).

- [`psi_dtw_cpp()`](https://blasbenito.github.io/distantia/reference/psi_dtw_cpp.md)
  : (C++) Psi Dissimilarity Score of Two Time-Series
- [`psi_equation_cpp()`](https://blasbenito.github.io/distantia/reference/psi_equation_cpp.md)
  : (C++) Equation of the Psi Dissimilarity Score
- [`psi_ls_cpp()`](https://blasbenito.github.io/distantia/reference/psi_ls_cpp.md)
  : (C++) Psi Dissimilarity Score of Two Aligned Time Series
- [`psi_null_dtw_cpp()`](https://blasbenito.github.io/distantia/reference/psi_null_dtw_cpp.md)
  : (C++) Null Distribution of Dissimilarity Scores of Two Time Series
- [`psi_null_ls_cpp()`](https://blasbenito.github.io/distantia/reference/psi_null_ls_cpp.md)
  : (C++) Null Distribution of the Dissimilarity Scores of Two Aligned
  Time Series
- [`importance_dtw_cpp()`](https://blasbenito.github.io/distantia/reference/importance_dtw_cpp.md)
  : (C++) Contribution of Individual Variables to the Dissimilarity
  Between Two Time Series (Robust Version)
- [`importance_dtw_legacy_cpp()`](https://blasbenito.github.io/distantia/reference/importance_dtw_legacy_cpp.md)
  : (C++) Contribution of Individual Variables to the Dissimilarity
  Between Two Time Series (Legacy Version)
- [`importance_ls_cpp()`](https://blasbenito.github.io/distantia/reference/importance_ls_cpp.md)
  : (C++) Contribution of Individual Variables to the Dissimilarity
  Between Two Aligned Time Series
- [`permute_free_by_row_cpp()`](https://blasbenito.github.io/distantia/reference/permute_free_by_row_cpp.md)
  : (C++) Unrestricted Permutation of Complete Rows
- [`permute_free_cpp()`](https://blasbenito.github.io/distantia/reference/permute_free_cpp.md)
  : (C++) Unrestricted Permutation of Cases
- [`permute_restricted_by_row_cpp()`](https://blasbenito.github.io/distantia/reference/permute_restricted_by_row_cpp.md)
  : (C++) Restricted Permutation of Complete Rows Within Blocks
- [`permute_restricted_cpp()`](https://blasbenito.github.io/distantia/reference/permute_restricted_cpp.md)
  : (C++) Restricted Permutation of Cases Within Blocks
- [`cost_matrix_diagonal_cpp()`](https://blasbenito.github.io/distantia/reference/cost_matrix_diagonal_cpp.md)
  : (C++) Compute Orthogonal and Diagonal Least Cost Matrix from a
  Distance Matrix
- [`cost_matrix_diagonal_weighted_cpp()`](https://blasbenito.github.io/distantia/reference/cost_matrix_diagonal_weighted_cpp.md)
  : (C++) Compute Orthogonal and Weighted Diagonal Least Cost Matrix
  from a Distance Matrix
- [`cost_matrix_orthogonal_cpp()`](https://blasbenito.github.io/distantia/reference/cost_matrix_orthogonal_cpp.md)
  : (C++) Compute Orthogonal Least Cost Matrix from a Distance Matrix
- [`distance_ls_cpp()`](https://blasbenito.github.io/distantia/reference/distance_ls_cpp.md)
  : (C++) Sum of Pairwise Distances Between Cases in Two Aligned Time
  Series
- [`distance_matrix_cpp()`](https://blasbenito.github.io/distantia/reference/distance_matrix_cpp.md)
  : (C++) Distance Matrix of Two Time Series
- [`auto_distance_cpp()`](https://blasbenito.github.io/distantia/reference/auto_distance_cpp.md)
  : (C++) Sum Distances Between Consecutive Samples in a Time Series
- [`auto_sum_cpp()`](https://blasbenito.github.io/distantia/reference/auto_sum_cpp.md)
  : (C++) Sum Distances Between Consecutive Samples in Two Time Series
- [`auto_sum_full_cpp()`](https://blasbenito.github.io/distantia/reference/auto_sum_full_cpp.md)
  : (C++) Sum Distances Between All Consecutive Samples in Two Time
  Series
- [`auto_sum_path_cpp()`](https://blasbenito.github.io/distantia/reference/auto_sum_path_cpp.md)
  : (C++) Sum Distances Between All Consecutive Samples in the Least
  Cost Path Between Two Time Series
- [`subset_matrix_by_rows_cpp()`](https://blasbenito.github.io/distantia/reference/subset_matrix_by_rows_cpp.md)
  : (C++) Subset Matrix by Rows
- [`cost_path_cpp()`](https://blasbenito.github.io/distantia/reference/cost_path_cpp.md)
  : Least Cost Path
- [`cost_path_diagonal_bandwidth_cpp()`](https://blasbenito.github.io/distantia/reference/cost_path_diagonal_bandwidth_cpp.md)
  : (C++) Orthogonal and Diagonal Least Cost Path Restricted by
  Sakoe-Chiba band
- [`cost_path_diagonal_cpp()`](https://blasbenito.github.io/distantia/reference/cost_path_diagonal_cpp.md)
  : (C++) Orthogonal and Diagonal Least Cost Path
- [`cost_path_orthogonal_bandwidth_cpp()`](https://blasbenito.github.io/distantia/reference/cost_path_orthogonal_bandwidth_cpp.md)
  : (C++) Orthogonal Least Cost Path
- [`cost_path_orthogonal_cpp()`](https://blasbenito.github.io/distantia/reference/cost_path_orthogonal_cpp.md)
  : (C++) Orthogonal Least Cost Path
- [`cost_path_slotting_cpp()`](https://blasbenito.github.io/distantia/reference/cost_path_slotting_cpp.md)
  : (C++) Least Cost Path for Sequence Slotting
- [`cost_path_sum_cpp()`](https://blasbenito.github.io/distantia/reference/cost_path_sum_cpp.md)
  : (C++) Sum Distances in a Least Cost Path
- [`cost_path_trim_cpp()`](https://blasbenito.github.io/distantia/reference/cost_path_trim_cpp.md)
  : (C++) Remove Blocks from a Least Cost Path
- [`distance_bray_curtis_cpp()`](https://blasbenito.github.io/distantia/reference/distance_bray_curtis_cpp.md)
  : (C++) Bray-Curtis Distance Between Two Vectors
- [`distance_canberra_cpp()`](https://blasbenito.github.io/distantia/reference/distance_canberra_cpp.md)
  : (C++) Canberra Distance Between Two Binary Vectors
- [`distance_chebyshev_cpp()`](https://blasbenito.github.io/distantia/reference/distance_chebyshev_cpp.md)
  : (C++) Chebyshev Distance Between Two Vectors
- [`distance_chi_cpp()`](https://blasbenito.github.io/distantia/reference/distance_chi_cpp.md)
  : (C++) Normalized Chi Distance Between Two Vectors
- [`distance_cosine_cpp()`](https://blasbenito.github.io/distantia/reference/distance_cosine_cpp.md)
  : (C++) Cosine Dissimilarity Between Two Vectors
- [`distance_euclidean_cpp()`](https://blasbenito.github.io/distantia/reference/distance_euclidean_cpp.md)
  : (C++) Euclidean Distance Between Two Vectors
- [`distance_hamming_cpp()`](https://blasbenito.github.io/distantia/reference/distance_hamming_cpp.md)
  : (C++) Hamming Distance Between Two Binary Vectors
- [`distance_hellinger_cpp()`](https://blasbenito.github.io/distantia/reference/distance_hellinger_cpp.md)
  : (C++) Hellinger Distance Between Two Vectors
- [`distance_jaccard_cpp()`](https://blasbenito.github.io/distantia/reference/distance_jaccard_cpp.md)
  : (C++) Jaccard Distance Between Two Binary Vectors
- [`distance_manhattan_cpp()`](https://blasbenito.github.io/distantia/reference/distance_manhattan_cpp.md)
  : (C++) Manhattan Distance Between Two Vectors
- [`distance_russelrao_cpp()`](https://blasbenito.github.io/distantia/reference/distance_russelrao_cpp.md)
  : (C++) Russell-Rao Distance Between Two Binary Vectors
- [`distance_sorensen_cpp()`](https://blasbenito.github.io/distantia/reference/distance_sorensen_cpp.md)
  : (C++) Sørensen Distance Between Two Binary Vectors

## Psi Demo Functions

Step-by-step demonstration of *Psi* dissimilarity scores. These
functions are R wrappers of several key C++ functions above.

- [`psi_auto_distance()`](https://blasbenito.github.io/distantia/reference/psi_auto_distance.md)
  : Cumulative Sum of Distances Between Consecutive Cases in a Time
  Series
- [`psi_auto_sum()`](https://blasbenito.github.io/distantia/reference/psi_auto_sum.md)
  : Auto Sum
- [`psi_cost_matrix()`](https://blasbenito.github.io/distantia/reference/psi_cost_matrix.md)
  : Cost Matrix
- [`psi_cost_path()`](https://blasbenito.github.io/distantia/reference/psi_cost_path.md)
  : Least Cost Path
- [`psi_cost_path_sum()`](https://blasbenito.github.io/distantia/reference/psi_cost_path_sum.md)
  : Sum of Distances in Least Cost Path
- [`psi_distance_lock_step()`](https://blasbenito.github.io/distantia/reference/psi_distance_lock_step.md)
  : Lock-Step Distance
- [`psi_distance_matrix()`](https://blasbenito.github.io/distantia/reference/psi_distance_matrix.md)
  : Distance Matrix
- [`psi_equation()`](https://blasbenito.github.io/distantia/reference/psi_equation.md)
  : Normalized Dissimilarity Score

## Distance Functions

Functions to compute distances between univariate or multivariate
vectors and data frames.

- [`distance()`](https://blasbenito.github.io/distantia/reference/distance.md)
  : Distance Between Two Numeric Vectors
- [`distance_matrix()`](https://blasbenito.github.io/distantia/reference/distance_matrix.md)
  : Data Frame to Distance Matrix
- [`distances`](https://blasbenito.github.io/distantia/reference/distances.md)
  : Distance Methods

## Create Time Series Lists

Transform raw time series data into **time series lists** (TSLs
hereafter). TSLs are lists of zoo time series objects used within the
package for data management and analysis.

- [`tsl_initialize()`](https://blasbenito.github.io/distantia/reference/tsl_initialize.md)
  [`tsl_init()`](https://blasbenito.github.io/distantia/reference/tsl_initialize.md)
  : Transform Raw Time Series Data to Time Series List

## Manage Time Series Lists

Functions manage, diagnose, repair TSLs.

- [`tsl_burst()`](https://blasbenito.github.io/distantia/reference/tsl_burst.md)
  : Multivariate TSL to Univariate TSL
- [`tsl_colnames_clean()`](https://blasbenito.github.io/distantia/reference/tsl_colnames_clean.md)
  : Clean Column Names in Time Series Lists
- [`tsl_colnames_get()`](https://blasbenito.github.io/distantia/reference/tsl_colnames_get.md)
  : Get Column Names from a Time Series Lists
- [`tsl_colnames_prefix()`](https://blasbenito.github.io/distantia/reference/tsl_colnames_prefix.md)
  : Append Prefix to Column Names of Time Series List
- [`tsl_colnames_set()`](https://blasbenito.github.io/distantia/reference/tsl_colnames_set.md)
  : Set Column Names in Time Series Lists
- [`tsl_colnames_suffix()`](https://blasbenito.github.io/distantia/reference/tsl_colnames_suffix.md)
  : Append Suffix to Column Names of Time Series List
- [`tsl_count_NA()`](https://blasbenito.github.io/distantia/reference/tsl_count_NA.md)
  : Count NA Cases in Time Series Lists
- [`tsl_diagnose()`](https://blasbenito.github.io/distantia/reference/tsl_diagnose.md)
  : Diagnose Issues in Time Series Lists
- [`tsl_handle_NA()`](https://blasbenito.github.io/distantia/reference/tsl_handle_NA.md)
  [`tsl_Inf_to_NA()`](https://blasbenito.github.io/distantia/reference/tsl_handle_NA.md)
  [`tsl_NaN_to_NA()`](https://blasbenito.github.io/distantia/reference/tsl_handle_NA.md)
  : Handle NA Cases in Time Series Lists
- [`tsl_join()`](https://blasbenito.github.io/distantia/reference/tsl_join.md)
  : Join Time Series Lists
- [`tsl_names_clean()`](https://blasbenito.github.io/distantia/reference/tsl_names_clean.md)
  : Clean Time Series Names in a Time Series List
- [`tsl_names_get()`](https://blasbenito.github.io/distantia/reference/tsl_names_get.md)
  : Get Time Series Names from a Time Series Lists
- [`tsl_names_set()`](https://blasbenito.github.io/distantia/reference/tsl_names_set.md)
  : Set Time Series Names in a Time Series List
- [`tsl_names_test()`](https://blasbenito.github.io/distantia/reference/tsl_names_test.md)
  : Tests Naming Issues in Time Series Lists
- [`tsl_ncol()`](https://blasbenito.github.io/distantia/reference/tsl_ncol.md)
  : Get Number of Columns in Time Series Lists
- [`tsl_nrow()`](https://blasbenito.github.io/distantia/reference/tsl_nrow.md)
  : Get Number of Rows in Time Series Lists
- [`tsl_repair()`](https://blasbenito.github.io/distantia/reference/tsl_repair.md)
  : Repair Issues in Time Series Lists
- [`tsl_subset()`](https://blasbenito.github.io/distantia/reference/tsl_subset.md)
  : Subset Time Series Lists by Time Series Names, Time, and/or Column
  Names
- [`tsl_time()`](https://blasbenito.github.io/distantia/reference/tsl_time.md)
  [`tsl_time_summary()`](https://blasbenito.github.io/distantia/reference/tsl_time.md)
  : Time Features of Time Series Lists
- [`tsl_to_df()`](https://blasbenito.github.io/distantia/reference/tsl_to_df.md)
  : Transform Time Series List to Data Frame

## Plot Time Series Lists

Main function to plot TSLs and its helpers.

- [`tsl_plot()`](https://blasbenito.github.io/distantia/reference/tsl_plot.md)
  : Plot Time Series List

## Processing Time Series Lists

Functions to transform, rescale, and aggregate TSLs.

- [`tsl_aggregate()`](https://blasbenito.github.io/distantia/reference/tsl_aggregate.md)
  : Aggregate Time Series List Over Time Periods
- [`tsl_resample()`](https://blasbenito.github.io/distantia/reference/tsl_resample.md)
  : Resample Time Series Lists to a New Time
- [`tsl_smooth()`](https://blasbenito.github.io/distantia/reference/tsl_smooth.md)
  : Smoothing of Time Series Lists
- [`tsl_stats()`](https://blasbenito.github.io/distantia/reference/tsl_stats.md)
  : Summary Statistics of Time Series Lists
- [`tsl_transform()`](https://blasbenito.github.io/distantia/reference/tsl_transform.md)
  : Transform Values in Time Series Lists
- [`f_binary()`](https://blasbenito.github.io/distantia/reference/f_binary.md)
  : Transform Zoo Object to Binary
- [`f_clr()`](https://blasbenito.github.io/distantia/reference/f_clr.md)
  : Data Transformation: Rowwise Centered Log-Ratio
- [`f_detrend_difference()`](https://blasbenito.github.io/distantia/reference/f_detrend_difference.md)
  : Data Transformation: Detrending and Differencing
- [`f_detrend_linear()`](https://blasbenito.github.io/distantia/reference/f_detrend_linear.md)
  : Data Transformation: Linear Detrending of Zoo Time Series
- [`f_detrend_poly()`](https://blasbenito.github.io/distantia/reference/f_detrend_poly.md)
  : Data Transformation: Polynomial Linear Detrending of Zoo Time Series
- [`f_hellinger()`](https://blasbenito.github.io/distantia/reference/f_hellinger.md)
  : Data Transformation: Rowwise Hellinger Transformation
- [`f_list()`](https://blasbenito.github.io/distantia/reference/f_list.md)
  : Lists Available Transformation Functions
- [`f_log()`](https://blasbenito.github.io/distantia/reference/f_log.md)
  : Data Transformation: Log
- [`f_percent()`](https://blasbenito.github.io/distantia/reference/f_percent.md)
  : Data Transformation: Rowwise Percentages
- [`f_proportion()`](https://blasbenito.github.io/distantia/reference/f_proportion.md)
  : Data Transformation: Rowwise Proportions
- [`f_proportion_sqrt()`](https://blasbenito.github.io/distantia/reference/f_proportion_sqrt.md)
  : Data Transformation: Rowwise Square Root of Proportions
- [`f_rescale_global()`](https://blasbenito.github.io/distantia/reference/f_rescale_global.md)
  : Data Transformation: Global Rescaling of to a New Range
- [`f_rescale_local()`](https://blasbenito.github.io/distantia/reference/f_rescale_local.md)
  : Data Transformation: Local Rescaling of to a New Range
- [`f_scale_global()`](https://blasbenito.github.io/distantia/reference/f_scale_global.md)
  : Data Transformation: Global Centering and Scaling
- [`f_scale_local()`](https://blasbenito.github.io/distantia/reference/f_scale_local.md)
  : Data Transformation: Local Centering and Scaling
- [`f_trend_linear()`](https://blasbenito.github.io/distantia/reference/f_trend_linear.md)
  : Data Transformation: Linear Trend of Zoo Time Series
- [`f_trend_poly()`](https://blasbenito.github.io/distantia/reference/f_trend_poly.md)
  : Data Transformation: Polynomial Linear Trend of Zoo Time Series
- [`utils_drop_geometry()`](https://blasbenito.github.io/distantia/reference/utils_drop_geometry.md)
  : Removes Geometry Column from SF Data Frames
- [`utils_global_scaling_params()`](https://blasbenito.github.io/distantia/reference/utils_global_scaling_params.md)
  : Global Centering and Scaling Parameters of Time Series Lists
- [`utils_optimize_loess()`](https://blasbenito.github.io/distantia/reference/utils_optimize_loess.md)
  : Optimize Loess Models for Time Series Resampling
- [`utils_optimize_spline()`](https://blasbenito.github.io/distantia/reference/utils_optimize_spline.md)
  : Optimize Spline Models for Time Series Resampling
- [`utils_rescale_vector()`](https://blasbenito.github.io/distantia/reference/utils_rescale_vector.md)
  : Rescale Numeric Vector to a New Data Range

## Zoo Functions

Functions to Manage, Plot, and Transform Zoo Time Series

- [`zoo_aggregate()`](https://blasbenito.github.io/distantia/reference/zoo_aggregate.md)
  : Aggregate Cases in Zoo Time Series
- [`zoo_name_clean()`](https://blasbenito.github.io/distantia/reference/zoo_name_clean.md)
  : Clean Name of a Zoo Time Series
- [`zoo_name_get()`](https://blasbenito.github.io/distantia/reference/zoo_name_get.md)
  : Get Name of a Zoo Time Series
- [`zoo_name_set()`](https://blasbenito.github.io/distantia/reference/zoo_name_set.md)
  : Set Name of a Zoo Time Series
- [`zoo_permute()`](https://blasbenito.github.io/distantia/reference/zoo_permute.md)
  : Random or Restricted Permutation of Zoo Time Series
- [`zoo_plot()`](https://blasbenito.github.io/distantia/reference/zoo_plot.md)
  : Plot Zoo Time Series
- [`zoo_resample()`](https://blasbenito.github.io/distantia/reference/zoo_resample.md)
  : Resample Zoo Objects to a New Time
- [`zoo_smooth_exponential()`](https://blasbenito.github.io/distantia/reference/zoo_smooth_exponential.md)
  : Exponential Smoothing of Zoo Time Series
- [`zoo_smooth_window()`](https://blasbenito.github.io/distantia/reference/zoo_smooth_window.md)
  : Rolling Window Smoothing of Zoo Time Series
- [`zoo_time()`](https://blasbenito.github.io/distantia/reference/zoo_time.md)
  : Get Time Features from Zoo Objects
- [`zoo_to_tsl()`](https://blasbenito.github.io/distantia/reference/zoo_to_tsl.md)
  : Convert Individual Zoo Objects to Time Series List
- [`zoo_vector_to_matrix()`](https://blasbenito.github.io/distantia/reference/zoo_vector_to_matrix.md)
  : Coerce Coredata of Univariate Zoo Time Series to Matrix

## Example Time Series

Time series datasets from different disciplines.

- [`albatross`](https://blasbenito.github.io/distantia/reference/albatross.md)
  : Flight Path Time Series of Albatrosses in The Pacific
- [`cities_coordinates`](https://blasbenito.github.io/distantia/reference/cities_coordinates.md)
  : Coordinates of 100 Major Cities
- [`cities_temperature`](https://blasbenito.github.io/distantia/reference/cities_temperature.md)
  : Long Term Monthly Temperature in 20 Major Cities
- [`covid_counties`](https://blasbenito.github.io/distantia/reference/covid_counties.md)
  : County Coordinates of the Covid Prevalence Dataset
- [`covid_prevalence`](https://blasbenito.github.io/distantia/reference/covid_prevalence.md)
  : Time Series of Covid Prevalence in California Counties
- [`eemian_coordinates`](https://blasbenito.github.io/distantia/reference/eemian_coordinates.md)
  : Site Coordinates of Nine Interglacial Sites in Central Europe
- [`eemian_pollen`](https://blasbenito.github.io/distantia/reference/eemian_pollen.md)
  : Pollen Counts of Nine Interglacial Sites in Central Europe
- [`fagus_coordinates`](https://blasbenito.github.io/distantia/reference/fagus_coordinates.md)
  : Site Coordinates of Fagus sylvatica Stands
- [`fagus_dynamics`](https://blasbenito.github.io/distantia/reference/fagus_dynamics.md)
  : Time Series Data from Three Fagus sylvatica Stands
- [`honeycomb_climate`](https://blasbenito.github.io/distantia/reference/honeycomb_climate.md)
  : Rainfall and Temperature in The Americas
- [`honeycomb_polygons`](https://blasbenito.github.io/distantia/reference/honeycomb_polygons.md)
  : Hexagonal Grid

## Time Series Simulation

Functions to generate simulated time series.

- [`tsl_simulate()`](https://blasbenito.github.io/distantia/reference/tsl_simulate.md)
  : Simulate a Time Series List
- [`zoo_simulate()`](https://blasbenito.github.io/distantia/reference/zoo_simulate.md)
  : Simulate a Zoo Time Series

## Plotting Helpers

Internal functions to help with plotting tasks.

- [`color_continuous()`](https://blasbenito.github.io/distantia/reference/color_continuous.md)
  : Default Continuous Color Palette
- [`color_discrete()`](https://blasbenito.github.io/distantia/reference/color_discrete.md)
  : Default Discrete Color Palettes
- [`utils_color_breaks()`](https://blasbenito.github.io/distantia/reference/utils_color_breaks.md)
  : Auto Breaks for Matrix Plotting Functions
- [`utils_line_color()`](https://blasbenito.github.io/distantia/reference/utils_line_color.md)
  : Handles Line Colors for Sequence Plots
- [`utils_line_guide()`](https://blasbenito.github.io/distantia/reference/utils_line_guide.md)
  : Guide for Time Series Plots
- [`utils_matrix_guide()`](https://blasbenito.github.io/distantia/reference/utils_matrix_guide.md)
  : Color Guide for Matrix Plot
- [`utils_matrix_plot()`](https://blasbenito.github.io/distantia/reference/utils_matrix_plot.md)
  : Plot Distance or Cost Matrix and Least Cost Path

## Time Handling Helpers

Internal functions to handle time.

- [`utils_as_time()`](https://blasbenito.github.io/distantia/reference/utils_as_time.md)
  : Ensures Correct Class for Time Arguments
- [`utils_coerce_time_class()`](https://blasbenito.github.io/distantia/reference/utils_coerce_time_class.md)
  : Coerces Vector to a Given Time Class
- [`utils_is_time()`](https://blasbenito.github.io/distantia/reference/utils_is_time.md)
  : Title
- [`utils_new_time()`](https://blasbenito.github.io/distantia/reference/utils_new_time.md)
  [`utils_new_time_type()`](https://blasbenito.github.io/distantia/reference/utils_new_time.md)
  : New Time for Time Series Aggregation
- [`utils_time_keywords()`](https://blasbenito.github.io/distantia/reference/utils_time_keywords.md)
  : Valid Aggregation Keywords
- [`utils_time_keywords_dictionary()`](https://blasbenito.github.io/distantia/reference/utils_time_keywords_dictionary.md)
  : Dictionary of Time Keywords
- [`utils_time_keywords_translate()`](https://blasbenito.github.io/distantia/reference/utils_time_keywords_translate.md)
  : Translates The User's Time Keywords Into Valid Ones
- [`utils_time_units()`](https://blasbenito.github.io/distantia/reference/utils_time_units.md)
  : Data Frame with Supported Time Units

## Other Internal Functions

Internal functions to check arguments and other miscellany tasks.

- [`utils_boxplot_common()`](https://blasbenito.github.io/distantia/reference/utils_boxplot_common.md)
  :

  Common Boxplot Component of
  [`distantia_boxplot()`](https://blasbenito.github.io/distantia/reference/distantia_boxplot.md)
  and
  [`momentum_boxplot()`](https://blasbenito.github.io/distantia/reference/momentum_boxplot.md)

- [`utils_check_args_distantia()`](https://blasbenito.github.io/distantia/reference/utils_check_args_distantia.md)
  :

  Check Input Arguments of
  [`distantia()`](https://blasbenito.github.io/distantia/reference/distantia.md)

- [`utils_check_args_matrix()`](https://blasbenito.github.io/distantia/reference/utils_check_args_matrix.md)
  : Checks Input Matrix

- [`utils_check_args_momentum()`](https://blasbenito.github.io/distantia/reference/utils_check_args_momentum.md)
  :

  Check Input Arguments of
  [`momentum()`](https://blasbenito.github.io/distantia/reference/momentum.md)

- [`utils_check_args_path()`](https://blasbenito.github.io/distantia/reference/utils_check_args_path.md)
  : Checks Least Cost Path

- [`utils_check_args_tsl()`](https://blasbenito.github.io/distantia/reference/utils_check_args_tsl.md)
  : Structural Check for Time Series Lists

- [`utils_check_args_zoo()`](https://blasbenito.github.io/distantia/reference/utils_check_args_zoo.md)
  : Checks Argument x

- [`utils_check_distance_args()`](https://blasbenito.github.io/distantia/reference/utils_check_distance_args.md)
  : Check Distance Argument

- [`utils_check_list_class()`](https://blasbenito.github.io/distantia/reference/utils_check_list_class.md)
  : Checks Classes of List Elements Against Expectation

- [`utils_clean_names()`](https://blasbenito.github.io/distantia/reference/utils_clean_names.md)
  : Clean Character Vector of Names

- [`utils_digits()`](https://blasbenito.github.io/distantia/reference/utils_digits.md)
  : Number of Decimal Places

- [`utils_distantia_df_split()`](https://blasbenito.github.io/distantia/reference/utils_distantia_df_split.md)
  : Split Dissimilarity Analysis Data Frames by Combinations of
  Arguments

- [`utils_prepare_df()`](https://blasbenito.github.io/distantia/reference/utils_prepare_df.md)
  : Convert Data Frame to a List of Data Frames

- [`utils_prepare_matrix()`](https://blasbenito.github.io/distantia/reference/utils_prepare_matrix.md)
  : Convert Matrix to Data Frame

- [`utils_prepare_matrix_list()`](https://blasbenito.github.io/distantia/reference/utils_prepare_matrix_list.md)
  : Convert List of Matrices to List of Data Frames

- [`utils_prepare_time()`](https://blasbenito.github.io/distantia/reference/utils_prepare_time.md)
  : Handles Time Column in a List of Data Frames

- [`utils_prepare_vector_list()`](https://blasbenito.github.io/distantia/reference/utils_prepare_vector_list.md)
  : Convert List of Vectors to List of Data Frames

- [`utils_prepare_zoo_list()`](https://blasbenito.github.io/distantia/reference/utils_prepare_zoo_list.md)
  : Convert List of Data Frames to List of Zoo Objects

- [`utils_tsl_pairs()`](https://blasbenito.github.io/distantia/reference/utils_tsl_pairs.md)
  : Data Frame with Pairs of Time Series in Time Series Lists
