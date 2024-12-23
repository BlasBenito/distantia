
# `distantia` Time Series Dissimilarity <a href="https://github.com/BlasBenito/distantia"><img src="man/figures/logo.png" align="right" height="138" /></a>

<!-- README.md is generated from README.Rmd. Please edit that file -->
<!-- badges: start -->

[![DOI](https://zenodo.org/badge/187805264.svg)](https://zenodo.org/badge/latestdoi/187805264)
[![CRAN_Release_Badge](http://www.r-pkg.org/badges/version/distantia)](https://CRAN.R-project.org/package=distantia)
[![CRAN_Download_Badge](http://cranlogs.r-pkg.org/badges/grand-total/distantia)](https://CRAN.R-project.org/package=distantia)
[![R-CMD-check](https://github.com/BlasBenito/distantia/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/BlasBenito/distantia/actions/workflows/R-CMD-check.yaml)

<!-- badges: end -->

## Warning

Version 2.0.0 of `distantia` is a full re-write of the original package
and **will break existing workflows** before **making them better**.
Please refer to the
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

#### Comprehensive Analytical Tools

- 10 distance metrics: see `distantia::distances`.
- The normalized dissimilarity metric `psi`.
- Free and Restricted Dynamic Time Warping (DTW) for shape-based
  comparisons.
- A Lock-Step method for sample-to-sample alignment.
- Restricted permutation tests for robust inferential support.
- Variable Importance Analysis: assessment of contribution to
  dissimilarity of individual variables in multivariate time series.
- Hierarchical and K-means clustering of time series based on
  dissimilarity matrices.

#### Computational Efficiency

- A **C++ back-end** powered by [Rcpp](https://www.rcpp.org/).
- **Parallel processing** managed through the
  [future](https://future.futureverse.org/) package.
- **Efficient data handling** via
  [zoo](https://cran.r-project.org/web/packages/zoo/index.html).

#### Time Series Management Tools

- Introduces **time series lists** (TSL), a versatile format for
  handling collections of time series stored as lists of `zoo` objects.
- Includes a suite of `tsl_...()` functions for generating, resampling,
  transforming, analyzing, and visualizing both univariate and
  multivariate time series.

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

This section showcases several features of the package `distantia`.
Please, check the **Articles** section for further details.

### Setup

All heavy duty functions in `distantia` support parallelization via the
[future](https://future.futureverse.org/) package, and progress bars
provided by the [progressr](https://progressr.futureverse.org/) package.
Unfortunately, the latter does not work in Rmarkdown documents like this
one.

``` r
library(distantia)
library(future)
library(parallelly)
# library(progressr)


#parallelization setup
#only worth it for very large datasets
# future::plan(
#   future::multisession,
#   workers = parallelly::availableCores() - 1
#   )

#progress bar (does not work in Rmarkdown)
#progressr::handlers(global = TRUE)
```

### Example Data

The `albatross` data frame contains daily GPS data of 4 individuals of
Waved Albatross in the Pacific captured during the summer of 2008. Below
are the first 10 rows of this data frame:

    #>   name       time         x         y     speed temperature  heading
    #> 1 X132 2008-05-31 -89.62097 -1.389512 0.1473333    29.06667 212.0307
    #> 2 X132 2008-06-01 -89.62101 -1.389508 0.2156250    28.25000 184.0337
    #> 3 X132 2008-06-02 -89.62101 -1.389503 0.2143750    27.68750 123.1269
    #> 4 X132 2008-06-03 -89.62099 -1.389508 0.2018750    27.81250 183.4600
    #> 5 X132 2008-06-04 -89.62098 -1.389507 0.2256250    27.68750 114.8931
    #> 6 X132 2008-06-05 -89.62925 -1.425734 1.3706667    25.73333 245.8033

The code below transforms the data to a *Time Series List* with
`tsl_initialize()` and applies global scaling and centering with
`tsl_transform()` and `f_scale_global` to facilitate time series
comparisons.

``` r
tsl <- tsl_initialize(
  x = albatross,
  name_column = "name",
  time_column = "time",
  lock_step = TRUE
) |> 
  tsl_transform(
    f = f_scale_global
  )

tsl_plot(
  tsl = tsl,
  ylim = "relative"
)
```

<img src="man/figures/README-unnamed-chunk-5-1.png" width="100%" /> \###
Dissimilarity Analysis

#### Lock-Step Analysis

Lock-step analysis performs direct comparisons between samples observed
at the same time without any time distortion. It requires time series of
the same length, observed at the same times.

``` r
df_ls <- distantia(
  tsl = tsl,
  lock_step = TRUE
)
#> Loading required package: foreach

df_ls[, c("x", "y", "psi")]
#>      x    y      psi
#> 1 X132 X134 1.888451
#> 3 X132 X153 2.128340
#> 5 X134 X153 2.187862
#> 4 X134 X136 2.270977
#> 2 X132 X136 2.427479
#> 6 X136 X153 2.666099
```

The “psi” column contains normalized dissimilarity values and is used to
sort the data frame from lowest to highest dissimilarity. Hence, the
first row shows the most similar pair of time series.

The function `distantia_boxplot()` enables a quick identification of the
time series that are either more dissimilar (top) or similar (bottom) to
others.

``` r
distantia_boxplot(df = df_ls, text_cex = 0.8)
```

![](man/figures/README-unnamed-chunk-7-1.png)<!-- -->

#### Dynamic Time Warping

By default, `distantia()` computes unrestricted dynamic time warping
with orthogonal and diagonal least cost paths.

``` r
df_dtw <- distantia(
  tsl = tsl
)

df_dtw[, c("x", "y", "psi")]
#>      x    y      psi
#> 1 X132 X134 1.299380
#> 5 X134 X153 2.074241
#> 3 X132 X153 2.091923
#> 4 X134 X136 2.358040
#> 2 X132 X136 2.449381
#> 6 X136 X153 2.666099
```

The function `distantia_dtw_plot()` provides detailed insights into the
alignment between a pair of time series resulting from DTW.

``` r
distantia_dtw_plot(
  tsl = tsl[c("X132", "X153")]
)
```

<img src="man/figures/README-unnamed-chunk-9-1.png" width="100%" />

Deviations from the perfect diagonal in the least-cost path reveal
adjustments made by DTW to align time series by shape rather than time.

The article [Dynamic Time Warping vs
Lock-Step](https://blasbenito.github.io/distantia/articles/dynamic_time_warping_and_lock_step.html)
provides further insights on the advantages and disadvantages of each
method in different scenarios.

### Permutation Test

The function `distantia()` implements restricted permutation tests to
assess the significance of dissimilarity scores. It provides several
setups to support different assumptions.

For example, the configuration below rearranges complete rows within
7-day blocks, assuming strong dependencies within rows and between
observations that are close in time.

``` r
df_dtw <- distantia(
  tsl = tsl,
  repetitions = 1000,
  permutation = "restricted_by_row",
  block_size = 7
)

df_dtw[, c("x", "y", "psi", "p_value")]
#>      x    y      psi p_value
#> 1 X132 X134 1.299380   0.001
#> 5 X134 X153 2.074241   0.001
#> 3 X132 X153 2.091923   0.002
#> 4 X134 X136 2.358040   0.177
#> 2 X132 X136 2.449381   0.544
#> 6 X136 X153 2.666099   0.005
```

The “p_value” column represents the fraction of permutations yielding a
psi score lower than the observed value. It indicates the strength of
similarity between two time series. A significance threshold (e.g.,
0.05, depending on iterations) helps identify strongly similar or
dissimilar pairs.

### Variable Importance

When comparing multivariate time series, certain variables contribute
more to similarity or dissimilarity. The `momentum()` function uses a
leave-one-out algorithm to quantify each variable’s contribution to the
overall dissimilarity between two time series.

``` r
df_importance <- momentum(
  tsl = tsl
)

df_importance[, c("x", "y", "variable", "importance", "effect")]
#>       x    y    variable   importance               effect
#> 1  X132 X134           x   87.6066043 decreases similarity
#> 2  X132 X134           y   93.9587187 decreases similarity
#> 3  X132 X134       speed  -21.9171171 increases similarity
#> 4  X132 X134 temperature   72.8121621 decreases similarity
#> 5  X132 X134     heading  -38.0165137 increases similarity
#> 6  X132 X136           x   48.3845903 decreases similarity
#> 7  X132 X136           y   93.5214543 decreases similarity
#> 8  X132 X136       speed  -61.1729252 increases similarity
#> 9  X132 X136 temperature  356.8824838 decreases similarity
#> 10 X132 X136     heading -102.9830173 increases similarity
#> 11 X132 X153           x  427.7381576 decreases similarity
#> 12 X132 X153           y  156.1285451 decreases similarity
#> 13 X132 X153       speed  -40.9249630 increases similarity
#> 14 X132 X153 temperature  -14.2831545 increases similarity
#> 15 X132 X153     heading  -79.3532025 increases similarity
#> 16 X134 X136           x   61.3361468 decreases similarity
#> 17 X134 X136           y  108.9650664 decreases similarity
#> 18 X134 X136       speed  -59.2603918 increases similarity
#> 19 X134 X136 temperature  310.6812842 decreases similarity
#> 20 X134 X136     heading  -90.2797292 increases similarity
#> 21 X134 X153           x  592.0783167 decreases similarity
#> 22 X134 X153           y  116.4310429 decreases similarity
#> 23 X134 X153       speed  -52.4149093 increases similarity
#> 24 X134 X153 temperature    0.9936944 decreases similarity
#> 25 X134 X153     heading  -85.0271172 increases similarity
#> 26 X136 X153           x  507.6153648 decreases similarity
#> 27 X136 X153           y   56.6957442 decreases similarity
#> 28 X136 X153       speed  -65.4516103 increases similarity
#> 29 X136 X153 temperature  240.9053814 decreases similarity
#> 30 X136 X153     heading -116.2461929 increases similarity
```

Positive “importance” values indicate variables contributing to
dissimilarity, while negative values indicate contribution to
similarity. The function documentation provides more details on how
importance scores are computed.

The `momentum_boxplot()` function can provide insights into which
variables contribute the most to similarity or dissimilarity.

``` r
momentum_boxplot(
  df = df_importance
)
```

<img src="man/figures/README-unnamed-chunk-12-1.png" width="75%" />

### Clustering

The package `distantia` provides tools to group together time series by
dissimilarity using hierarchical or K-means clustering. The example
below applies the former to the `albatross` dataset to find out groups
of individuals with the most similar movement time series.

``` r
dtw_hclust <- distantia_cluster_hclust(
  df = df_dtw,
  clusters = NULL, #automatic mode
  method = NULL    #automatic mode
  )

#cluster object
dtw_hclust$cluster_object
#> 
#> Call:
#> stats::hclust(d = d_dist, method = method)
#> 
#> Cluster method   : ward.D 
#> Number of objects: 4

#number of clusters
dtw_hclust$clusters
#> [1] 2

#clustering data frame
#group label in column "cluster"
#negatives in column "silhouette_width" higlight anomalous cluster assignation
dtw_hclust$df
#>   name cluster silhouette_width
#> 1 X132       1        0.3077225
#> 2 X134       1        0.2846556
#> 3 X136       2        0.0000000
#> 4 X153       1        0.2186781

#tree plot
par(mar=c(3,1,1,3))

plot(
  x = stats::as.dendrogram(
    dtw_hclust$cluster_object
    ),
  horiz = TRUE
)
```

<img src="man/figures/README-unnamed-chunk-13-1.png" width="75%" />

This is just a summary of the features implemented in the package.
Please visit the **Articles** section to find out more about
`distantia`.

## Getting help

If you encounter bugs or issues with the documentation, please [file a
issue on GitHub](https://github.com/BlasBenito/distantia/issues).
