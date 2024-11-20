
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

The code below loads the required packages, and defines a
parallelization backend.

``` r
#required packages
library(distantia)
library(future)
library(parallelly)
library(tmap)

#parallelization setup
future::plan(
  future::multisession,
  workers = parallelly::availableCores() - 1
  )

#progress bar (does not work in Rmarkdown)
#progressr::handlers(global = TRUE)
```

### Example data

The data frame `cities_temperature` contains long-term time series of
monthly temperatures for 20 large cities.

``` r
head(cities_temperature)
#>      name       time temperature
#> 1 Bangkok 1975-01-01      25.277
#> 2 Bangkok 1975-02-01      27.267
#> 3 Bangkok 1975-03-01      29.378
#> 4 Bangkok 1975-04-01      30.127
#> 5 Bangkok 1975-05-01      28.861
#> 6 Bangkok 1975-06-01      28.078
```

The sf data frame `cities_coordinates` contains city coordinates.

``` r
cities_coordinates[, "name"]
#> Simple feature collection with 20 features and 1 field
#> Geometry type: POINT
#> Dimension:     XY
#> Bounding box:  xmin: -118.7 ymin: -23.31 xmax: 139.23 ymax: 55.45
#> Geodetic CRS:  WGS 84
#> First 10 features:
#>                name             geometry
#> 1           Bangkok  POINT (99.91 13.66)
#> 2            Bogotá  POINT (-74.73 4.02)
#> 3             Cairo  POINT (31.38 29.74)
#> 4             Dhaka     POINT (90 23.31)
#> 5  Ho Chi Minh City POINT (107.18 10.45)
#> 6          Istanbul  POINT (29.82 40.99)
#> 7           Jakarta POINT (106.55 -5.63)
#> 8           Karachi  POINT (67.39 24.92)
#> 9          Kinshasa  POINT (15.27 -4.02)
#> 10            Lagos    POINT (3.23 5.63)
```

### Converting to TSL

The function `tsl_initialize()` transforms the target data frame into a
time series list.

``` r
tsl <- tsl_initialize(
  x = cities_temperature,
  name_column = "name",
  time_column = "time"
)

head(lapply(tsl, class))
#> $Bangkok
#> [1] "zoo"
#> 
#> $Bogotá
#> [1] "zoo"
#> 
#> $Cairo
#> [1] "zoo"
#> 
#> $Dhaka
#> [1] "zoo"
#> 
#> $Ho_Chi_Minh_City
#> [1] "zoo"
#> 
#> $Istanbul
#> [1] "zoo"
```

The functions `tsl_subset()` and `tsl_transform()` are used below to
focus on a smaller subset of the the data to facilitate the explanations
below, and to center and scale the data to facilitate the comparison
between methods.

``` r
tsl_three_cities <- tsl |> 
  tsl_subset(
    names = c(
      "London", 
      "Paris", 
      "Kinshasa"
    ),
    time = c("2000-01-01", "2005-01-01")
  ) |> 
  tsl_transform(
    f = f_scale #centering and scaling
  )
```

The function `tsl_time()` offers a quick look at the time features of
the time series list.

``` r
tsl_time(tsl = tsl_three_cities)[, c(
  "name", 
  "class", 
  "resolution", 
  "units", 
  "begin", 
  "end"
  )]
#>       name class resolution units      begin        end
#> 1   London  Date      30.45  days 2000-01-01 2005-01-01
#> 2    Paris  Date      30.45  days 2000-01-01 2005-01-01
#> 3 Kinshasa  Date      30.45  days 2000-01-01 2005-01-01
```

The function `tsl_plot()` facilitates a visual exploration of the data.

``` r
tsl_plot(
  tsl = tsl_three_cities,
  ylim = "relative"
)
```

<img src="man/figures/README-unnamed-chunk-10-1.png" width="100%" />

### Dissimilarity Analysis

The function `distantia()` offers two alternative methods to computes
the dissimilarity between pairs of time series:

- **Dynamic Time Warping (DTW)** (default): Warps time axes to align
  sections with similar shapes. This method is ideal for comparing time
  series with temporal shifts and is applicable to any type of time
  series. However, DTW is sensitive to differences in magnitudes, so it
  performs best when the data is scaled, and optionally centered if
  absolute values are not critical for the analysis.

- **Lock-step**: Compares values at corresponding time points directly,
  without any temporal adjustments. This method is suitable for cases
  where preserving temporal integrity is essential, but it requires time
  series sampled at the same time points. This method does not require
  scaling unless the results are to be compared with DTW, in which case
  scaling ensures comparable results across both methods.

#### Dynamic Time Warping

When `lock_step = FALSE`, dynamic time warping is used to compare the
time series.

``` r
df_dtw <- distantia(
  tsl = tsl_three_cities,
  distance = "euclidean",
  lock_step = FALSE #default, activates dynamic time warping
)

df_dtw[, c("x", "y", "psi")]
#>        x        y       psi
#> 1 London    Paris 0.2234164
#> 2 London Kinshasa 1.1539690
#> 3  Paris Kinshasa 1.1775570
```

The column “psi” represents the normalized dissimilarity between pairs
of time series. According to these values, London and Kinshasa show the
most dissimilar temperatures, while London and Paris show the most
similar ones.

The time warping analysis can be plotted with `distantia_plot()`. The
temperature patterns of “Paris” and “London” are quite similar, and
require no warping.

``` r
distantia_plot(
  tsl = tsl_three_cities[c("Paris", "London")]
)
```

<img src="man/figures/README-unnamed-chunk-12-1.png" width="100%" />

The warping alignment between “London” and “Kinshasa” shows the
adjustments made by DTW to match the peaks and valleys of both time
series, and compensate for their shifted patterns.

``` r
distantia_plot(
  tsl = tsl_three_cities[c("London", "Kinshasa")]
)
```

<img src="man/figures/README-unnamed-chunk-13-1.png" width="100%" />

When the data is not scaled and/or centered, the sensitivity to data
magnitude of DTW may lead to local optima that distort the warping. The
example below comparing the raw temperatures of London and Kinshasa
shows two of these local optima, one in the *y* axis, at the minimum
temperature in Kinshasa (winter of 2001), and another in the *x* axis,
at the maximum temperature in London (summer of 2003).

``` r
tsl_two_cities <- tsl |> 
  tsl_subset(
    names = c(
      "London", 
      "Kinshasa"
    ),
    time = c("2000-01-01", "2005-01-01")
  )

distantia_plot(
  tsl = tsl_two_cities
)
```

<img src="man/figures/README-unnamed-chunk-14-1.png" width="100%" />

This is not a particular issue of the algorithm implemented in
`distantia`, but a general behavior of time warping methods. The code
below shows a similar analysis performed with
[`dtw`](https://CRAN.R-project.org/package=dtw).

``` r
library(dtw)

xy_dtw <- dtw::dtw(
  x = tsl_two_cities$London$temperature,
  y = tsl_two_cities$Kinshasa$temperature,
  keep = TRUE
  )

plot(xy_dtw, type = "threeway")
```

<img src="man/figures/README-unnamed-chunk-15-1.png" width="100%" />

#### Lock Step

When `lock_step = TRUE`, the lock-step method is activated, and the time
series are compared on an observation-to-observation basis. This method
yields increased dissimilarity scores when the involved time series show
shifted patterns.

``` r
df_ls <- distantia(
  tsl = tsl_three_cities,
  distance = "euclidean",
  lock_step = TRUE #activates lock-step
)

#adding the results of dtw to facilitate comparison
df_ls$psi_dtw <- df_dtw$psi
df_ls$psi_lock_step <- df_ls$psi

df_ls[, c("x", "y", "psi_lock_step",  "psi_dtw")]
#>        x        y psi_lock_step   psi_dtw
#> 1 London    Paris     0.2427342 0.2234164
#> 2 London Kinshasa     2.7924554 1.1539690
#> 3  Paris Kinshasa     2.7153379 1.1775570
```

It is important to take in mind that here we are performing the
lock-step analysis with the scaled data to compare its output with the
DTW results. The results on the raw data are shown below.

``` r
tsl_three_cities <- tsl |> 
  tsl_subset(
    names = c(
      "London", 
      "Paris", 
      "Kinshasa"
    ),
    time = c("2000-01-01", "2005-01-01")
  )

df_ls <- distantia(
  tsl = tsl_three_cities,
  distance = "euclidean",
  lock_step = TRUE #activates lock-step
)

df_ls[, c("x", "y", "psi")]
#>        x        y       psi
#> 1 London    Paris 0.4879081
#> 2 London Kinshasa 9.3361647
#> 3  Paris Kinshasa 7.5416106
```

### Manipulating TSLs

This section only covers a few of the data-manipulation capabilities of
`distantia`.

#### Aggregation

The function `tsl_aggregate()` applies an aggregation function to
specific time frames. For example, the code below computes the maximum
temperature per year

``` r
tsl_temp <- tsl_aggregate(
  tsl = tsl,
  new_time = "year",
  method = max
)

tsl_plot(
  tsl = tsl_temp[1:5],
  ylim = "relative"
)
```

<img src="man/figures/README-unnamed-chunk-18-1.png" width="100%" />
Same as above, but by decade.

``` r
tsl_temp <- tsl_aggregate(
  tsl = tsl,
  new_time = "decades",
  method = max
)

tsl_plot(
  tsl = tsl_temp[1:5],
  ylim = "relative"
)
```

<img src="man/figures/README-unnamed-chunk-19-1.png" width="100%" />

## Getting help

If you encounter bugs or issues with the documentation, please [file a
issue on GitHub](https://github.com/BlasBenito/distantia/issues).
