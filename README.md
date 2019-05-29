
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
library(foreach)
library(parallel)
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

The function **prepareSequences** gets them ready for analysis by
matching colum names and handling empty data, as follows:

``` r
help(prepareSequences)

AB.sequences <- prepareSequences(
  sequence.A = sequenceA,
  sequence.A.name = "A",
  sequence.B = sequenceB,
  sequence.B.name = "B",
  merge.mode = "complete",
  if.empty.cases = "zero",
  transformation = "hellinger"
)

str(AB.sequences)
```

The function allows to merge two multivariate time-series into a single
table ready for the computation of dissimilarity between sequences.

### Computation of dissimilarity: psi

The computation of **psi**, proposed by Birks and Gordon (1985) requires
the following steps:

**1.** Computation of a **distance matrix** among the samples of both
sequences.

``` r
AB.distance.matrix <- distanceMatrix(
  sequences = AB.sequences,
  method = "manhattan"
)

image(AB.distance.matrix)
```

**2.** Computation of the least cost matrix.

``` r
AB.least.cost.matrix <- leastCostMatrix(
  distance.matrix = AB.distance.matrix
)

image(AB.least.cost.matrix)
```

**Optional** Get least cost path

``` r
AB.least.cost.path <- leastCostPath(
  distance.matrix = AB.distance.matrix,
  least.cost.matrix = AB.least.cost.matrix
  )
```

``` r
plotMatrix(distance.matrix = AB.distance.matrix,
           least.cost.path = AB.least.cost.path,
           figure.margins = c(5,5,5,5),
           legend = FALSE)
```

**3.** Getting the least cost value.

``` r
AB.least.cost <- leastCost(least.cost.matrix = AB.least.cost.matrix)

AB.least.cost
```

**4.** Autosum, or sum of the distances among adjacent samples on each
sequence.

``` r
AB.autosum <- autosum(
  sequences = AB.sequences,
  method = "manhattan"
  )

AB.autosum
```

# Workflow to compare multiple sequences

The dataset *sequencesMIS*…

``` r
data(sequencesMIS)
kable(head(sequencesMIS, n=15))
```

Preparing the sequences

``` r
MIS.sequences <- prepareSequences(
  sequences = sequencesMIS,
  grouping.column = "MIS",
  if.empty.cases = "zero",
  transformation = "hellinger"
)

str(MIS.sequences)
```

**1.** Computing the distance matrices

``` r
MIS.distance.matrix <- distanceMatrix(
  sequences = MIS.sequences,
  grouping.column = "MIS"
)

par(mfrow=c(11, 6), mar=c(1,2,4,1))
for(i in 1:length(names(MIS.distance.matrix))){
image(MIS.distance.matrix[[i]], main=names(MIS.distance.matrix)[i])
}
```

**2.** Computing least cost.

``` r
MIS.least.cost.matrix <- leastCostMatrix(
  distance.matrix = MIS.distance.matrix
)

par(mfrow=c(11, 6), mar=c(1,2,4,1))
for(i in 1:length(names(MIS.least.cost.matrix))){
image(MIS.least.cost.matrix[[i]], main=names(MIS.least.cost.matrix)[i])
}
```

**Optional** computing least cost path

``` r
MIS.least.cost.path <- leastCostPath(
  distance.matrix = MIS.distance.matrix,
  least.cost.matrix = MIS.least.cost.matrix
  )
```

Plotting it

``` r
plotMatrix(distance.matrix = MIS.distance.matrix,
           least.cost.path = NULL,
           margins = c(1,2,4,1),
           legend = FALSE,
           plot.columns = 6,
           plot.rows = 11
)
```

**3.** Getting the least cost value

``` r
MIS.least.cost <- leastCost(least.cost.matrix = MIS.least.cost.matrix)

MIS.least.cost
```

**4.** Computing autosums

``` r
MIS.autosum <- autosum(
  sequences = MIS.sequences,
  grouping.column = "MIS",
  method = "manhattan"
  )

MIS.autosum
```
