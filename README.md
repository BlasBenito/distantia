
<!-- README.md is generated from README.Rmd. Please edit that file -->

# distantia

<!-- badges: start -->

<!-- badges: end -->

The package **distantia** implements the *sequence slotting* method
proposed described in [“Numerical methods in Quaternary pollen
analysis”](https://onlinelibrary.wiley.com/doi/abs/10.1002/gea.3340010406)
(Birks and Gordon, 1985). In this document I briefly explain the logics
behind the method, and the extensions and new applications implementd in
the **distantia** package

## Installation

You can install the released version of distantia from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("distantia")
```

And the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("BlasBenito/distantia")
```

Loading the library, plus other helper libraries:

``` r
library(distantia)
library(kableExtra)
```

## Logics behind the method

The objective of this method is to **compute the dissimilarity between
two (or more) multivariate time-series** (hereafter, *sequences*). These
sequences can be either regular (same time between consecutive samples)
or irregular (different time between consecutive samples), and can be
aligned (same number of samples) or unaligned (different number of
samples).

The only restrictions are that any given entity represented by a column
must have the same name in both datasets, and that these sequences must
be ordered (in time, depth, rank) from top to bottom in the given
dataframe.

The package provides two example datasets based on the Abernethy pollen
core (Birks and Mathewes (1978):

``` r
data(sequenceA)
data(sequenceB)

str(sequenceA)
str(sequenceB)

kable(sequenceA, caption = "Sequence A")
kable(sequenceB, caption = "Sequence B")
```

The function **prepareSequences** gets them ready for analysis as
follows:

``` r
sequences <- prepareSequences(
  sequence.A = NULL,
  sequence.A.name = "A",
  sequence.B = NULL,
  sequence.B.name = "B",
  exclude.columns = NULL,
  if.empty.cases = "zero",
  transformation = "hellinger"
)
```
