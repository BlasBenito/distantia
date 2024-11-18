
# distantia: Time Series Dissimilarity Analysis with Dynamic Time Warping

<!-- README.md is generated from README.Rmd. Please edit that file -->
<!-- badges: start -->

[![DOI](https://zenodo.org/badge/187805264.svg)](https://zenodo.org/badge/latestdoi/187805264)
[![CRAN_Release_Badge](http://www.r-pkg.org/badges/version/distantia)](https://CRAN.R-project.org/package=distantia)
[![CRAN_Download_Badge](http://cranlogs.r-pkg.org/badges/grand-total/distantia)](https://CRAN.R-project.org/package=distantia)
[![R-CMD-check](https://github.com/BlasBenito/distantia/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/BlasBenito/distantia/actions/workflows/R-CMD-check.yaml)

<!-- badges: end -->

## Warning

Version 2.0.0 of `distantia` is a full re-write from scratch and **will
break existing workflows**. Please refer to the
[Changelog](https://blasbenito.github.io/distantia/news/index.html) for
details before updating.

## Summary

The `distantia` package has undergone a major overhaul to enhance
performance and usability. Core functions are now implemented in C++ for
faster execution and improved memory efficiency, with streamlined R
wrappers to simplify user interaction.

Function and argument names have been updated to offer a more intuitive
experience. Additionally, most time series operations are now powered by
the [zoo](https://cran.r-project.org/web/packages/zoo/index.html)
library to provide a consistent and efficient data handling.

Version 2.0 introduces “time series lists” (`tsl`), which are lists of
zoo objects. A comprehensive suite of functions named `tsl_...()` have
been added to the pacakge to generate, resample, transform, analyze, and
visualize univariate, multivariate, regular, or irregular time series.
Many of these functions support a parallelized execution via the
[future](https://future.futureverse.org/) package, and progress bars as
provided by the package [progressr](https://progressr.futureverse.org/).

Finally, to further aid learning and experimentation, new example
datasets from different disicplines and tools to simulate time series
are also included.

## Citation

If you find this package useful, please cite it as:

*Blas M. Benito, H. John B. Birks (2020). distantia: an open-source
toolset to quantify dissimilarity between multivariate ecological
time-series. Ecography, 43(5), 660-667. doi:
[10.1111/ecog.04895](https://nsojournals.onlinelibrary.wiley.com/doi/10.1111/ecog.04895).*

*Blas M. Benito (2024). distantia: A Toolset for Time Series
Dissimilarity Analysis. R package version 2.0.0. url:
<https://blasbenito.github.io/distantia/>.*

## Main Improvements in Version 2.0.0

1.  **High computational speed**: The logics for the time series
    dissimilarity analysis provided by `distantia()` and
    `distantia_importance()` are now implemented in a C++ backend
    designed for speed. This new feature, combined with a
    parallelization setup provided by the
    [future](https://future.futureverse.org/) makes dissimilarity
    analysis for large datasets blazing fast.
2.  **Usage of zoo objects**: Individual time series in distantia are
    now [zoo](https://cran.r-project.org/package=zoo) objects, which
    support regular and irregular time series with various index types
    (e.g., Date, POSIXct), enable efficient handling and manipulation,
    and offer robust tools for alignment, merging, and filling missing
    values.
3.  **Time Series Lists and associated toolset**: Groups of time series
    to compare are stored in Time Series Lists (TSL), which are lists of
    zoo objects. The package also comes with a complete toolset to
    create, manage, transform, aggregate, and visualize TSLs, with the
    objective of providing a smooth user experience.

## Install

The package `distantia` can be installed from CRAN.

``` r
install.packages("distantia")
```

The development version can be installed from GitHub.

``` r
remotes::install_github(
  repo = "blasbenito/distantia", 
  ref = "main"
  )
```

Previous versions are in the “archive_xxx” branches of the GitHub
repository.

``` r
remotes::install_github(
  repo = "blasbenito/distantia", 
  ref = "archive_v1.0.2"
  )
```

## Getting Started

This section provides a minimal example on how to use `distantia`.
Please, check the **Articles** section for further details.

### Setup

The code below loads the required packages, defines a parallelization
backend and loads the example data.

The `albatross` data frame contains the flight paths of 4 individuals of
Waved Albatross captured during summer of 2008.

## Getting help

If you encounter bugs or issues with the documentation, please [file a
issue on GitHub](https://github.com/BlasBenito/distantia/issues).
