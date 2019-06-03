
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
# install.packages("distantia")
```

And the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
# devtools::install_github("BlasBenito/distantia")
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

Notice that **sequenceB** has a few NA values.

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

kable(AB.sequences)
```

It allows to merge two (or more) multivariate time-series into a single
table ready for the computation of dissimilarity between sequences.

### Computation of dissimilarity

The computation of dissimlarity between two sequences goes as follows:

**1.** Computation of a **distance matrix** among the samples of both
sequences. The image below shows the matrix of distances between pairs
of samples in both sequences. Blue colors indicate low distances, while
red colors indicate larger distances.

``` r
#computing distance matrix
AB.distance.matrix <- distanceMatrix(
  sequences = AB.sequences,
  method = "manhattan"
)

#plotting distance matrix
plotMatrix(distance.matrix = AB.distance.matrix)
```

**2.** Computation of the least cost matrix. This step uses a *dynamic
programming algorithm* to find the least cost when moving between the
cell 1,1 of the matrix (lower left in the image above) and the last cell
of the matrix (opposite corner). It does so by solving first every
partial solution (in the neighborhood of every cell in the matrix), and
then propagating the sum towards the opposite extreme.

The value of the upper-right cell in the plotted matrix (actually, the
lower-right cell in the actual data matrix, the matrix is rotated in the
plot) is the sum of the minimum distance across all samples of both
time-series.

``` r
AB.least.cost.matrix <- leastCostMatrix(
  distance.matrix = AB.distance.matrix
)

plotMatrix(distance.matrix = AB.least.cost.matrix)
```

**Optional** In this optional step the function **leastCostPath** finds
the least cost path in the matrix above. It returns a dataframe with the
coordinates of the cells within the path, the distance between
consecutive cells, and the cumulative distance of any given step in the
path. It can be used to plot the path, which helps to better understand
the alignmnet between both sequences.

``` r
AB.least.cost.path <- leastCostPath(
  distance.matrix = AB.distance.matrix,
  least.cost.matrix = AB.least.cost.matrix
  )

kable(AB.least.cost.path)

par(mfrow=c(2,1))
plotMatrix(distance.matrix = AB.distance.matrix,
           least.cost.path = AB.least.cost.path
           )

plotMatrix(distance.matrix = AB.least.cost.matrix,
           least.cost.path = AB.least.cost.path
           )
```

**3.** Getting the least cost value. The Upper right cell of the matrix
in the image of the least cost matrix (lower right cell in the actual
data-matrix) holds the cumulative sum of the least cost path. This value
will be used later on to compute dissimilarity.

``` r
AB.least.cost <- leastCost(least.cost.matrix = AB.least.cost.matrix)
AB.least.cost
```

**4.** Autosum, or sum of the distances among adjacent samples on each
sequence. This is another requirement to compute a normalized measure of
dissimilarity. It just computes the distance between adjacent samples
and sums them up.

``` r
AB.autosum <- autoSum(
  sequences = AB.sequences,
  method = "manhattan"
  )
AB.autosum
```

**5.** Compute **psi**. Finally, with the least cost value and the
autosum of the sequences, psi is computed
as:

\[\psi = \frac{LC - (\sum{A_{i-j}} + \sum{B_{i-j}})}{\sum{A_{i-j}} + \sum{B_{i-j}}} \]

where:

  - \[LC\] is the least cost computed by **leastCostMatrix**.
  - \[\sum{A_{i-j}}\] is the autosum of one of the sequences.
  - \[\sum{B_{i-j}}\] is the autosum of the other sequence.

Which basically is the least cost normalizado by the autosum of both
sequences.

``` r
AB.psi <- psi(least.cost = AB.least.cost,
              autosum = AB.autosum)
AB.psi
```

All the steps required to compute **psi** are included in the function
**workflowPsi**, that works as follows:

``` r
AB.psi <- workflowPsi(
  sequences = AB.sequences,
  grouping.column = "id",
  method = "manhattan"
)
AB.psi
```

# Workflow to compare multiple sequences

The package can work seamlessly with any given number of sequences, as
long as there is memory enough available.

The dataset *sequencesMIS* contains 12 sections of the same sequence
belonging to different marine isotopic stages.

``` r
data(sequencesMIS)
kable(head(sequencesMIS, n=15))
unique(sequencesMIS$MIS)
```

The sequences can be prepared with **prepareSequences** (note the change
in the argument *grouping.column*).

``` r
MIS.sequences <- prepareSequences(
  sequences = sequencesMIS,
  grouping.column = "MIS",
  if.empty.cases = "zero",
  transformation = "hellinger"
)
str(MIS.sequences)
```

And **psi** can be computed through **workflowPsi** as follows. Note the
argument *output* that allows to select either “dataframe” or “matrix”
to obtain an output with a given structure.

``` r
MIS.psi <- workflowPsi(
  sequences = MIS.sequences,
  grouping.column = "MIS",
  time.column = NULL,
  exclude.columns = NULL,
  method = "manhattan",
  diagonal = FALSE,
  output = "dataframe"
)

kable(head(MIS.psi, 20))
```

# Working with aligned multivariate time-series (same number of samples/rows and rows with same time/depth/order)

In this particular case, distances are computed only between samples
that have the same order, depth, or age (as defined by the *time.column*
argument). The function **prepareSequences** checks if the sequences
have the same number of rows and, if *time.column* is provided, it
subsets the cases that have valid time/depth columns for every sequence
in the dataset.

``` r
#loading sample data
data(climate)

#preparing sequences
climate.prepared <- prepareSequences(
  sequences = climate,
  grouping.column = "sequenceId",
  time.column = "time",
  paired.samples = TRUE
  )
```

Computing distances between paired samples. The result is a list, each
slot named as the id of the given sequence according to
*grouping.columns*, and containing a vector with pairwise distances.
Each vector position is named according the values of the samples
according to *time.column*.

``` r

climate.pairwise.distances <- distancePairedSamples(
  sequences = climate.prepared,
  grouping.column = "sequenceId",
  time.column = "time",
  exclude.columns = NULL,
  method = "manhattan"
  )
```
