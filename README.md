
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
break existing workflows**. Please refer to the Changelog for details
before updating.

## Summary

The `distantia` package has undergone a major overhaul to enhance both
performance and usability. Core functions are now implemented in C++ for
faster execution and improved memory efficiency, with streamlined R
wrappers to simplify user interaction.

Function and argument names have been updated to follow modern
conventions, offering a more intuitive experience. Additionally, most
time series operations are now powered by the
[zoo](https://cran.r-project.org/web/packages/zoo/index.html) library,
providing consistent data handling and computational efficiency.

Version 2.0 introduces the concept of “time series lists” (`tsl`), using
lists of zoo objects to manage and organize time series data. A full
suite of functions prefixed with `tsl_...()` allows users to easily
generate, resample, transform, analyze, and visualize univariate,
multivariate, regular, or irregular time series. Many of these functions
support parallel execution via the
[future](https://future.futureverse.org/) package, with progress
indicators provided by [progressr](https://progressr.futureverse.org/)
for a smoother user experience.

Finally, to further aid learning and experimentation, new example
datasets and tools for generating simulated time series are also
included.

## Citation

If you find this package useful, please cite it as:

*Blas M. Benito, H. John B. Birks (2020). distantia: an open-source
toolset to quantify dissimilarity between multivariate ecological
time-series. Ecography, 43(5), 660-667. doi:
[10.1111/ecog.04895](https://nsojournals.onlinelibrary.wiley.com/doi/10.1111/ecog.04895).*

*Blas M. Benito (2024). distantia: A Toolset for Time Series
Dissimilarity Analysis. R package version 2.0.0. url:
<https://blasbenito.github.io/distantia/>.*
