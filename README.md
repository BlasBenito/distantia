
# distantia: Time Series Dissimilarity Analysis with Dynamic Time Warping

<!-- README.md is generated from README.Rmd. Please edit that file -->
<!-- badges: start -->

[![DOI](https://zenodo.org/badge/187805264.svg)](https://zenodo.org/badge/latestdoi/187805264)
[![CRAN_Release_Badge](http://www.r-pkg.org/badges/version/distantia)](https://CRAN.R-project.org/package=distantia)
[![CRAN_Download_Badge](http://cranlogs.r-pkg.org/badges/grand-total/distantia)](https://CRAN.R-project.org/package=distantia)
[![R-CMD-check](https://github.com/BlasBenito/distantia/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/BlasBenito/distantia/actions/workflows/R-CMD-check.yaml)

<!-- badges: end -->

## Warning

Version 2.0.0 of `distantia` is a full re-write of the original package
and **will break existing workflows**. Please refer to the
[Changelog](https://blasbenito.github.io/distantia/news/index.html) for
details before updating.

## Summary

The R package **`distantia`** offers an efficient, feature-rich toolkit
for managing, comparing, and analyzing time series data. It is designed
to handle a wide range of scenarios, including:

- Multivariate or univariate time series.
- Regular or irregular sampling.
- Time series of different lengths.

### Key Features

- **Comprehensive Analytical Tools**:
  - 10 distance metrics: see `distantia::distances`.
  - The normalized dissimilarity metric `psi`.
  - Three Dynamic Time Warping (DTW) methods for shape-based
    comparisons.
  - A Lock-Step method for sample-to-sample alignment.
  - Restricted permutation tests for robust inferential support.
  - Variable Importance Analysis: assessment of contribution to
    dissimilarity of individual variables in multivariate time series.
  - Hierarchical and K-means clustering of time series based on
    dissimilarity matrices.
- **Computational Efficiency**:
  - A **C++ back-end** powered by [Rcpp](https://www.rcpp.org/).
  - **Parallel processing** managed through the
    [future](https://future.futureverse.org/) package.
  - **Efficient data handling** via
    [zoo](https://cran.r-project.org/web/packages/zoo/index.html).
- **Time Series Management Tools**:
  - Introduces **time series lists (`tsl`)**, a versatile format for
    handling collections of time series stored as lists of `zoo`
    objects.
  - Includes a suite of `tsl_...()` functions for generating,
    resampling, transforming, analyzing, and visualizing both univariate
    and multivariate time series.

## Citation

If you find this package useful, please cite it as:

*Blas M. Benito, H. John B. Birks (2020). distantia: an open-source
toolset to quantify dissimilarity between multivariate ecological
time-series. Ecography, 43(5), 660-667. doi:
[10.1111/ecog.04895](https://nsojournals.onlinelibrary.wiley.com/doi/10.1111/ecog.04895).*

*Blas M. Benito (2024). distantia: A Toolset for Time Series
Dissimilarity Analysis. R package version 2.0.0. url:
<https://blasbenito.github.io/distantia/>.*

## Install

The package `distantia` can be installed from CRAN.

``` r
install.packages("distantia")
```

The development version can be installed from GitHub.

``` r
remotes::install_github(
  repo = "blasbenito/distantia", 
  ref = "development"
  )
```

## Getting Started

This section provides a minimal example on how to use `distantia`.
Please, check the **Articles** section for further details.

### Setup

Most functions in `distantia` now support a parallelization backend and
progress bars.

``` r
#required packages
library(distantia)
library(future)
library(parallelly)

#parallelization setup
future::plan(
  future::multisession,
  workers = parallelly::availableCores() - 1
  )

#progress bar (does not work in Rmarkdown)
#progressr::handlers(global = TRUE)
```

### Example Data

The `albatross` data frame contains daily GPS data of 4 individuals of
Waved Albatross in the Pacific captured during the summer of 2008. The
first 10 rows of this data frame are shown below.

    #>   name       time         x         y     speed temperature  heading
    #> 1 X132 2008-05-31 -89.62097 -1.389512 0.1473333    29.06667 212.0307
    #> 2 X132 2008-06-01 -89.62101 -1.389508 0.2156250    28.25000 184.0337
    #> 3 X132 2008-06-02 -89.62101 -1.389503 0.2143750    27.68750 123.1269
    #> 4 X132 2008-06-03 -89.62099 -1.389508 0.2018750    27.81250 183.4600
    #> 5 X132 2008-06-04 -89.62098 -1.389507 0.2256250    27.68750 114.8931
    #> 6 X132 2008-06-05 -89.62925 -1.425734 1.3706667    25.73333 245.8033

The `albatross` data is converted to *Time Series List* with
`tsl_initialize()`, and scaled and centered with `tsl_transform()` and
`f_scale`, to facilitate shape-based comparisons and variable importance
analyses.

``` r
tsl <- tsl_initialize(
  x = albatross,
  name_column = "name",
  time_column = "time",
  lock_step = TRUE
) |> 
  tsl_transform(
    f = f_scale
  )

tsl_plot(
  tsl = tsl,
  ylim = "relative"
)
```

<img src="man/figures/README-unnamed-chunk-5-1.png" width="100%" />

### Dissimilarity Analysis

#### Lock-Step Analysis

The lock-step analysis performs a direct sample-to-sample comparison
without any time distortion. It requires time series of the same length
observed at the same times.

``` r
df_ls <- distantia(
  tsl = tsl,
  lock_step = TRUE
)

df_ls[, c("x", "y", "psi")]
#>      x    y      psi
#> 6 X136 X153 1.515698
#> 5 X134 X153 1.703707
#> 3 X132 X153 1.726095
#> 4 X134 X136 1.745060
#> 1 X132 X134 1.811480
#> 2 X132 X136 1.837204
```

The column “psi” contains the value of normalized dissimilarity, and is
used to order the data frame from lower to higher dissimilarity (first
row shows the most similar time series).

The function `distantia_boxplot()` helps to quickly identify these time
series that are more different (top) or similar (bottom) to all others.

``` r
distantia_boxplot(df = df_ls)
```

<img src="man/figures/README-unnamed-chunk-7-1.png" width="100%" />

#### Dynamic Time Warping

The function `distantia()` computes the dissimilarity between pairs of
time series using **dynamic time warping** (DTW) with weighted diagonals
by default. This analysis is useful when the time series might be
shifted for reasons not relevant to the analysis at hand, such as
varying phenology, asynchronic behavior, or non-overlappig sampling
periods

``` r
df_dtw <- distantia(
  tsl = tsl
)

df_dtw[, c("x", "y", "psi")]
#>      x    y      psi
#> 1 X132 X134 1.209322
#> 4 X134 X136 1.337882
#> 2 X132 X136 1.440403
#> 5 X134 X153 1.442791
#> 6 X136 X153 1.466519
#> 3 X132 X153 1.790897
```

The function `distantia_plot()` provides a detailed insight on the
alignment between a pair of time series resulting from dynamic time
warping.

``` r
distantia_plot(
  tsl = tsl[c("X132", "X153")]
)
```

<img src="man/figures/README-unnamed-chunk-9-1.png" width="100%" />

Regions of the least cost path deviating from a perfect diagonal show
adjustments made by the dynamic time warping algorithm to match the time
series by shape rather than by time.

Vertical or horizontal segments of the least cost path indicate that one
sample of one time series is being paired with several samples of the
other time.

### P-values

The package `distantia` implements a restricted permutation analysis to
help assess the significance of dissimilarity scores. It accepts
different setups to support different data assumptions.

For example, the configuration below re-arranges complete rows within 7
days blocks. This setup assumes a strong dependency between variables in
the same row, and a strong dependency between observations that are
close in time (same week).

``` r
df_dtw <- distantia(
  tsl = tsl,
  repetitions = 1000,
  permutation = "restricted_by_row", #all variables co-dependent
  block_size = 7 #one week
)

df_dtw[, c("x", "y", "psi", "p_value")]
#>      x    y      psi p_value
#> 1 X132 X134 1.209322   0.001
#> 4 X134 X136 1.337882   0.001
#> 2 X132 X136 1.440403   0.003
#> 5 X134 X153 1.442791   0.001
#> 6 X136 X153 1.466519   0.001
#> 3 X132 X153 1.790897   0.248
```

The p-values shown in the results represent the fraction of permutations
that yield a psi score lower than the observed, and can be interpreted
as the *strength of the similarity* between two time series.

Given a significance level of interest (i.e. 0.05, but depends on the
number of iterations), it can help separate pairs of time series that
are similar from pairs of time series that are dissimilar.

## Getting help

If you encounter bugs or issues with the documentation, please [file a
issue on GitHub](https://github.com/BlasBenito/distantia/issues).
