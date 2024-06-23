distantia: an R package to compute the dissimilarity between
multivariate time-series
================

- [distantia: an R package to assess dissimilarity between multivariate
  time-series](#distantia-an-r-package-to-assess-dissimilarity-between-multivariate-time-series)
  - [Summary](#summary)
  - [Installation](#installation)
  - [Comparing two irregular METS](#comparing-two-irregular-mets)
- [Comparing multiple irregular
  METS](#comparing-multiple-irregular-mets)
- [Comparing regular aligned METS](#comparing-regular-aligned-mets)
- [Restricted permutation test to assess the significance of
  dissimilarity
  values](#restricted-permutation-test-to-assess-the-significance-of-dissimilarity-values)
- [Assessing the contribution of a variable to the dissimilarity between
  two
  sequences](#assessing-the-contribution-of-a-variable-to-the-dissimilarity-between-two-sequences)
- [Partial matching: finding the section in a long sequence more similar
  to a given short
  sequence](#partial-matching-finding-the-section-in-a-long-sequence-more-similar-to-a-given-short-sequence)
- [Sequence slotting: combining samples of two sequences into a single
  composite
  sequence](#sequence-slotting-combining-samples-of-two-sequences-into-a-single-composite-sequence)
- [Transferring an attribute from one sequence to
  another](#transferring-an-attribute-from-one-sequence-to-another)
  - [Direct transfer](#direct-transfer)
  - [Interpolated transfer](#interpolated-transfer)

# distantia: an R package to assess dissimilarity between multivariate time-series

<!-- README.md is generated from README.Rmd. Please edit that file -->
<!-- badges: start -->

[![DOI](https://zenodo.org/badge/187805264.svg)](https://zenodo.org/badge/latestdoi/187805264)
[![CRAN_Release_Badge](http://www.r-pkg.org/badges/version/distantia)](https://CRAN.R-project.org/package=distantia)
[![CRAN_Download_Badge](http://cranlogs.r-pkg.org/badges/grand-total/distantia)](https://CRAN.R-project.org/package=distantia)
[![R-CMD-check](https://github.com/BlasBenito/distantia/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/BlasBenito/distantia/actions/workflows/R-CMD-check.yaml)

<!-- badges: end -->

## Summary

The package **distantia** helps quantify dissimilarity between
multivariate ecological time-series (*METS* hereafter). The package
assumes that the target sequences are ordered along a given dimension,
being depth and time the most common ones, but others such as latitude
or elevation are also possible. Furthermore, the target METS can be
regular or irregular, and have their samples aligned (same
age/time/depth) or unaligned (different age/time/depth). The only
requirement is that the sequences must have at least two (but ideally
more) columns with the same name and units representing different
variables relevant to the dynamics of an ecological system.

In this document I explain the logic behind the method, show how to use
it, and demonstrate how the **distantia** package introduces useful
tools to compare multivariate time-series. The topics covered in this
document are:

- Installation of the package.
- Comparing two irregular METS.
- Comparing multiple irregular METS.
- Comparing regular and aligned METS.
- Restricted permutation test to assess the significance of
  dissimilarity scores
- Assessing the contribution of every variable to the dissimilarity
  between two METS.
- Partial matching: finding the section in a long METS more similar to a
  given shorter one.
- Sequence slotting: combining samples of two METS into a single
  composite sequence.
- Tranferring an attribute from one METS to another: direct and
  interpolated modes.

## Installation

You can install the released version of distantia (currently *v1.0.0*)
from [CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("distantia")
```

And the development version (currently v1.0.1) from
[GitHub](https://github.com/) with:

``` r
library(remotes)
remotes::install_github(
  repo = "BlasBenito/distantia", 
  ref = "development"
  )
```

Loading the library, plus other helper libraries:

``` r
library(distantia)
library(ggplot2)
library(viridis)
library(kableExtra)
library(qgraph)
library(tidyr)
```

## Comparing two irregular METS

In this section I will use two example datasets based on the Abernethy
pollen core (Birks and Mathewes, 1978) to fully explain the logical
backbone of the dissimilarity analyses implemented in *distantia*.

``` r
#loading sequences
data(sequenceA)
data(sequenceB)

#showing first rows
kbl(sequenceA[1:15, ], caption = "Sequence A")
kbl(sequenceB[1:15, ], caption = "Sequence B")
```

### Data preparation

Notice that **sequenceB** has a few NA values (that were introduced to
serve as an example). The function **prepareSequences** gets them ready
for analysis by matching colum names and handling empty data. It allows
to merge two or more METS into a single dataframe ready for further
analyses. Note that, since the data represents pollen abundances, a
*Hellinger* transformation (square root of the relative proportions of
each taxa, it balances the relative abundances of rare and dominant
taxa) is applied. This transformation balances the relative importance
of very abundant versus rare taxa. The function **prepareSequences**
will generally be the starting point of any analysis performed with the
*distantia* package.

``` r
#preparing sequences
AB.sequences <- prepareSequences(
  sequence.A = sequenceA,
  sequence.A.name = "A",
  sequence.B = sequenceB,
  sequence.B.name = "B",
  merge.mode = "complete",
  if.empty.cases = "zero",
  transformation = "hellinger"
)

#showing first rows of the transformed data
kbl(
  AB.sequences[1:15, ], 
  digits = 4, 
  caption = "Sequences A and B ready for analysis."
  )
```

The computation of dissimilarity between the datasets A and B requires
several steps.

### 1. Computation of a distance matrix among the samples of both sequences.

It is computed by the **distanceMatrix** function, which allows the user
to select a distance metric (so far the ones implemented are
*manhattan*, *euclidean*, *chi*, and *hellinger*). The function
**plotMatrix** allows an easy visualization of the resulting distance
matrix.

``` r
#computing distance matrix
AB.distance.matrix <- distanceMatrix(
  sequences = AB.sequences,
  method = "euclidean"
)

#plotting distance matrix
plotMatrix(
  distance.matrix = AB.distance.matrix,
  color.palette = "viridis",
  margins = rep(4,4)
  )
```

### 2. Computation of the least-cost path within the distance matrix.

This step uses a *dynamic programming algorithm* to find the least-cost
path that connnects the cell 1,1 of the matrix (lower left in the image
above) and the last cell of the matrix (opposite corner). This can be
done via in two different ways.

- an **orthogonal search** by moving either one step on the *x* axis or
  one step on the *y* axis at a time (see **Equation 1**).

**Equation 1**

![AB\_{between} = 2 \times (D(A\_{1}, B\_{1}) + \sum\_{i=1}^{m}\sum\_{j=1}^{n} min\left(\begin{array}{c}D(A\_{i}, B\_{j+1}), \\ D(A\_{i+1}, B\_{j}) \end{array}\right))](https://latex.codecogs.com/png.latex?AB_%7Bbetween%7D%20%3D%202%20%5Ctimes%20%28D%28A_%7B1%7D%2C%20B_%7B1%7D%29%20%2B%20%5Csum_%7Bi%3D1%7D%5E%7Bm%7D%5Csum_%7Bj%3D1%7D%5E%7Bn%7D%20min%5Cleft%28%5Cbegin%7Barray%7D%7Bc%7DD%28A_%7Bi%7D%2C%20B_%7Bj%2B1%7D%29%2C%20%5C%5C%20D%28A_%7Bi%2B1%7D%2C%20B_%7Bj%7D%29%20%5Cend%7Barray%7D%5Cright%29%29 "AB_{between} = 2 \times (D(A_{1}, B_{1}) + \sum_{i=1}^{m}\sum_{j=1}^{n} min\left(\begin{array}{c}D(A_{i}, B_{j+1}), \\ D(A_{i+1}, B_{j}) \end{array}\right))")

- an **orthogonal and diagonal search** (a.k.a *diagonal*) which
  includes the above, plus a diagonal search.

**Equation 2**

![AB\_{between} = 2 \times (D(A\_{1}, B\_{1}) + \sum\_{i=1}^{m}\sum\_{j=1}^{n} min\left(\begin{array}{c}D(A\_{i}, B\_{j+1}), \\ D(A\_{i+1}, B\_{j} \\ D(A\_{i+1}, B\_{j+1}) \end{array}\right))](https://latex.codecogs.com/png.latex?AB_%7Bbetween%7D%20%3D%202%20%5Ctimes%20%28D%28A_%7B1%7D%2C%20B_%7B1%7D%29%20%2B%20%5Csum_%7Bi%3D1%7D%5E%7Bm%7D%5Csum_%7Bj%3D1%7D%5E%7Bn%7D%20min%5Cleft%28%5Cbegin%7Barray%7D%7Bc%7DD%28A_%7Bi%7D%2C%20B_%7Bj%2B1%7D%29%2C%20%5C%5C%20D%28A_%7Bi%2B1%7D%2C%20B_%7Bj%7D%20%5C%5C%20D%28A_%7Bi%2B1%7D%2C%20B_%7Bj%2B1%7D%29%20%5Cend%7Barray%7D%5Cright%29%29 "AB_{between} = 2 \times (D(A_{1}, B_{1}) + \sum_{i=1}^{m}\sum_{j=1}^{n} min\left(\begin{array}{c}D(A_{i}, B_{j+1}), \\ D(A_{i+1}, B_{j} \\ D(A_{i+1}, B_{j+1}) \end{array}\right))")

Where:

- ![m](https://latex.codecogs.com/png.latex?m "m") and
  ![n](https://latex.codecogs.com/png.latex?n "n") are the number of
  samples of the multivariate time-series
  ![A](https://latex.codecogs.com/png.latex?A "A") and
  ![B](https://latex.codecogs.com/png.latex?B "B").  
- ![i](https://latex.codecogs.com/png.latex?i "i") and
  ![j](https://latex.codecogs.com/png.latex?j "j") are the indices of
  the samples in ![A](https://latex.codecogs.com/png.latex?A "A") and
  ![B](https://latex.codecogs.com/png.latex?B "B") being considered on
  each step of the recursive algorithm.
- ![D](https://latex.codecogs.com/png.latex?D "D") is a function that
  returns the multivariate distance (i.e. Manhattan) between any given
  pair of samples of ![A](https://latex.codecogs.com/png.latex?A "A")
  and ![B](https://latex.codecogs.com/png.latex?B "B").
- ![min](https://latex.codecogs.com/png.latex?min "min") is a function
  returning the minimum distance of a subset of distances defined in the
  neigborhood of the given indices
  ![i](https://latex.codecogs.com/png.latex?i "i") and
  ![j](https://latex.codecogs.com/png.latex?j "j")

The equation returns
![AB\_{between}](https://latex.codecogs.com/png.latex?AB_%7Bbetween%7D "AB_{between}"),
which is the double of the sum of distances that lie within the
least-cost path, and represent the distance *between* the samples of A
and B. The value of
![AB\_{between}](https://latex.codecogs.com/png.latex?AB_%7Bbetween%7D "AB_{between}")
is computed by using the functions **leastCostMatrix**, which computes
the partial solutions to the least-cost problem, **leastCostPath**,
which returns the best global solution, and **leastCost** function,
which sums the distances of the least-cost path and multiplies them by
2.

The code below performs these steps according to both equations

``` r

#ORTHOGONAL SEARCH
#computing least-cost matrix
AB.least.cost.matrix <- leastCostMatrix(
  distance.matrix = AB.distance.matrix,
  diagonal = FALSE
)

#extracting least-cost path
AB.least.cost.path <- leastCostPath(
  distance.matrix = AB.distance.matrix,
  least.cost.matrix = AB.least.cost.matrix,
  diagonal = FALSE
  )


#DIAGONAL SEARCH
#computing least-cost matrix
AB.least.cost.matrix.diag <- leastCostMatrix(
  distance.matrix = AB.distance.matrix,
  diagonal = TRUE
)

#extracting least-cost path
AB.least.cost.path.diag <- leastCostPath(
  distance.matrix = AB.distance.matrix,
  least.cost.matrix = AB.least.cost.matrix.diag,
  diagonal = TRUE
  )

#plotting solutions
plotMatrix(
  distance.matrix = list(
    'A|B' = AB.least.cost.matrix[[1]], 
    'A|B' = AB.least.cost.matrix.diag[[1]]
    ),
  least.cost.path = list(
    'A|B' = AB.least.cost.path[[1]], 
    'A|B' = AB.least.cost.path.diag[[1]]
    ),
  color.palette = "viridis",
  margin = rep(4,4),
  plot.rows = 1,
  plot.columns = 2
  )
```

Computing
![AB\_{between}](https://latex.codecogs.com/png.latex?AB_%7Bbetween%7D "AB_{between}")
from these solutions is straightforward with the function **leastCost**

``` r
#orthogonal solution
AB.between <- leastCost(
  least.cost.path = AB.least.cost.path
  )

#diagonal solution
AB.between.diag <- leastCost(
  least.cost.path = AB.least.cost.path.diag
  )
```

Diagonal solutions always yield lower values for
![AB\_{between}](https://latex.codecogs.com/png.latex?AB_%7Bbetween%7D "AB_{between}")
than orthogonal ones.

Notice the straight vertical and horizontal lines that show up in some
regions of the least cost paths shown in the figure above. These are
*blocks*, and happen in dissimilar sections of the compared sequences.
Also, an unbalanced number of rows in the compared sequences can
generate long blocks. Blocks inflate the value of
![AB\_{between}](https://latex.codecogs.com/png.latex?AB_%7Bbetween%7D "AB_{between}")
because the distance to a given sample is counted several times per
block. This problem often leads to false negatives, that is, to the
conclusion that two sequences are statistically different when actually
they are not.

This package includes an algorithm to remove blocks from the least cost
path, which offers more realistic values for
![AB\_{between}](https://latex.codecogs.com/png.latex?AB_%7Bbetween%7D "AB_{between}").
The function **leastCostPathNoBlocks** reads a least cost path, and
removes all blocks as follows.

``` r
#ORTHOGONAL SOLUTION
#removing blocks from least cost path
AB.least.cost.path.nb <- leastCostPathNoBlocks(
    least.cost.path = AB.least.cost.path
    )

#computing AB.between again
AB.between.nb <- leastCost(
  least.cost.path = AB.least.cost.path.nb
  )


#DIAGONAL SOLUTION
#removing blocks
AB.least.cost.path.diag.nb <- leastCostPathNoBlocks(
    least.cost.path = AB.least.cost.path.diag
    )

#diagonal solution without blocks
AB.between.diag.nb <- leastCost(
  least.cost.path = AB.least.cost.path.diag.nb
    )
```

Notice how now the diagonal solution has a higher value, because by
default, the diagonal method generates less blocks. That is why each
measure of dissimilarity (orthogonal, diagonal, orthogonal no-blocks,
and diagonal no-blocks) lies within a different comparative framework,
and therefore, **outputs from different methods should not be
compared**.

Hereafter only the diagonal no-blocks option will be considered in the
example cases, since it is the most general and safe solution of the
four mentioned above.

``` r
#changing names of the selected solutions
AB.least.cost.path <- AB.least.cost.path.diag.nb
AB.between <- AB.between.diag.nb

#removing unneeded objects
rm(AB.between.diag, AB.between.diag.nb, AB.between.nb, AB.distance.matrix, AB.least.cost.matrix, AB.least.cost.matrix.diag, AB.least.cost.path.diag, AB.least.cost.path.diag.nb, AB.least.cost.path.nb, sequenceA, sequenceB)
```

### 3. Autosum, or sum of the distances among adjacent samples on each sequence.

This step requires to compute the distances between adjacent samples in
each sequence and sum them, as shown in **Equation 3**.

**Equation 3**

![AB\_{within} = \sum\_{i=1}^{m} D(A\_{i }, A\_{i + 1}) +  \sum\_{i=1}^{n} D(B\_{i }, B\_{i + 1})](https://latex.codecogs.com/png.latex?AB_%7Bwithin%7D%20%3D%20%5Csum_%7Bi%3D1%7D%5E%7Bm%7D%20D%28A_%7Bi%20%7D%2C%20A_%7Bi%20%2B%201%7D%29%20%2B%20%20%5Csum_%7Bi%3D1%7D%5E%7Bn%7D%20D%28B_%7Bi%20%7D%2C%20B_%7Bi%20%2B%201%7D%29 "AB_{within} = \sum_{i=1}^{m} D(A_{i }, A_{i + 1}) +  \sum_{i=1}^{n} D(B_{i }, B_{i + 1})")

This operation is performed by the **autoSum** function shown below.

``` r
AB.within <- autoSum(
  sequences = AB.sequences,
  least.cost.path = AB.least.cost.path,
  method = "euclidean"
  )
AB.within
```

### 4. Compute dissimilarity score ![\psi](https://latex.codecogs.com/png.latex?%5Cpsi "\psi").

The dissimilarity measure
![\psi](https://latex.codecogs.com/png.latex?%5Cpsi "\psi") was first
described in the book [“Numerical methods in Quaternary pollen
analysis”](https://onlinelibrary.wiley.com/doi/abs/10.1002/gea.3340010406)
(Birks and Gordon, 1985). **Psi** is computed as shown in Equation 4a:

**Equation 4a**

![\psi = \frac{AB\_{between} - AB\_{within}}{AB\_{within}}](https://latex.codecogs.com/png.latex?%5Cpsi%20%3D%20%5Cfrac%7BAB_%7Bbetween%7D%20-%20AB_%7Bwithin%7D%7D%7BAB_%7Bwithin%7D%7D "\psi = \frac{AB_{between} - AB_{within}}{AB_{within}}")

This equation has a particularity. Imagine two identical sequences A and
B, with three samples each. In this case,
![AB\_{between}](https://latex.codecogs.com/png.latex?AB_%7Bbetween%7D "AB_{between}")
is computed as

![AB\_{between} = 2 \times (D(A\_{1}, B\_{1}) + D(A\_{1}, B\_{2}) + D(A\_{2}, B\_{2}) + D(A\_{2}, B\_{3}) + D(A\_{3}, B\_{3}))](https://latex.codecogs.com/png.latex?AB_%7Bbetween%7D%20%3D%202%20%5Ctimes%20%28D%28A_%7B1%7D%2C%20B_%7B1%7D%29%20%2B%20D%28A_%7B1%7D%2C%20B_%7B2%7D%29%20%2B%20D%28A_%7B2%7D%2C%20B_%7B2%7D%29%20%2B%20D%28A_%7B2%7D%2C%20B_%7B3%7D%29%20%2B%20D%28A_%7B3%7D%2C%20B_%7B3%7D%29%29 "AB_{between} = 2 \times (D(A_{1}, B_{1}) + D(A_{1}, B_{2}) + D(A_{2}, B_{2}) + D(A_{2}, B_{3}) + D(A_{3}, B_{3}))")

Since the samples of each sequence with the same index are identical,
this can be reduced to

![AB\_{between} = 2 \times (D(A\_{1}, B\_{2}) + D(A\_{2}, B\_{3})) = AB\_{within}](https://latex.codecogs.com/png.latex?AB_%7Bbetween%7D%20%3D%202%20%5Ctimes%20%28D%28A_%7B1%7D%2C%20B_%7B2%7D%29%20%2B%20D%28A_%7B2%7D%2C%20B_%7B3%7D%29%29%20%3D%20AB_%7Bwithin%7D "AB_{between} = 2 \times (D(A_{1}, B_{2}) + D(A_{2}, B_{3})) = AB_{within}")

which in turn equals
![AB\_{within}](https://latex.codecogs.com/png.latex?AB_%7Bwithin%7D "AB_{within}")
as shown in Equation 4, yielding a
![\psi](https://latex.codecogs.com/png.latex?%5Cpsi "\psi") value of 0.

This equality does not work in the same way when the least-cost path
search-method includes diagonals. When the sequenes are identical,
diagonal methods yield an
![AB\_{between}](https://latex.codecogs.com/png.latex?AB_%7Bbetween%7D "AB_{between}")
of 0, leading to a
![\psi](https://latex.codecogs.com/png.latex?%5Cpsi "\psi") equal to -1.
To fix this shift, this package uses Equation 4b instead when
![diagonal = TRUE](https://latex.codecogs.com/png.latex?diagonal%20%3D%20TRUE "diagonal = TRUE")
is selected, which adds 1 to the final solution.

**Equation 4b**

![\psi = \frac{AB\_{between} - AB\_{within}}{AB\_{within}} + 1](https://latex.codecogs.com/png.latex?%5Cpsi%20%3D%20%5Cfrac%7BAB_%7Bbetween%7D%20-%20AB_%7Bwithin%7D%7D%7BAB_%7Bwithin%7D%7D%20%2B%201 "\psi = \frac{AB_{between} - AB_{within}}{AB_{within}} + 1")

In any case, the **psi** function only requires the least-cost, and the
autosum of both sequences to compute
![\psi](https://latex.codecogs.com/png.latex?%5Cpsi "\psi"). Since we
are working with a diagonal search, 1 has to be added to the final
solution.

``` r
AB.psi <- psi(
  least.cost = AB.between,
  autosum = AB.within
  )
AB.psi[[1]] <- AB.psi[[1]] + 1
```

The output of **psi** is a list, that can be transformed to a dataframe
or a matrix by using the **formatPsi** function.

``` r
#to dataframe
AB.psi.dataframe <- formatPsi(
  psi.values = AB.psi,
  to = "dataframe")
kbl(AB.psi.dataframe, digits = 4)
```

### workflowPsi: doing it all at once

All the steps required to compute **psi**, including the format options
provided by **formatPsi** are wrapped together in the function
**workflowPsi**. It includes options to switch to a diagonal method, and
to ignore blocks, as shown below.

``` r
#checking the help file
help(workflowPsi)

#computing psi for A and B
AB.psi <- workflowPsi(
  sequences = AB.sequences,
  grouping.column = "id",
  method = "euclidean",
  format = "list",
  diagonal = TRUE,
  ignore.blocks = TRUE
)
AB.psi
```

The function allows to exclude particular columns from the analysis
(argument *exclude.columns*), select different distance metrics
(argument *method*), use diagonals to find the least-cost path (argument
*diagonal*), or measure psi by ignoring blocks in the least-cost path
(argument *ignore.blocks*). Since we have observed several blocks in the
least-cost path, below we compute psi by ignoring them.

``` r
#cleaning workspace
rm(list = ls())
```

# Comparing multiple irregular METS

The package can work seamlessly with any given number of sequences, as
long as there is memory enough available (but check the new function
**workflowPsiHP**, it can work with up to 40k sequences, if you have a
cluster at hand, and a few years to waste). To do so, almost every
function uses the packages
[“doParallel”](https://CRAN.R-project.org/package=doParallel) and
[“foreach”](https://CRAN.R-project.org/package=foreach), that together
allow to parallelize the execution of the *distantia* functions by using
all the processors in your machine but one.

The example dataset *mis* contains 12 sections of the same
sequence belonging to different marine isotopic stages identified by a
column named “MIS”. MIS stages with odd numbers are generally
interpreted as warm periods (interglacials), while the odd ones are
interpreted as cold periods (glacials). In any case, this interpretation
is not important to illustrate this capability of the library.

``` r
data(mis)

kbl(
  head(mis, n=15), 
  digits = 4, 
  caption = "Header of the mis dataset."
  )

unique(mis$MIS)
```

The dataset is checked and prepared with **prepareSequences**.

``` r
MIS.sequences <- prepareSequences(
  sequences = mis,
  grouping.column = "MIS",
  if.empty.cases = "zero",
  transformation = "hellinger"
)
```

The dissimilarity measure **psi** can be computed for every combination
of sequences through the function **workflowPsi** shown below.

``` r
MIS.psi <- workflowPsi(
  sequences = MIS.sequences,
  grouping.column = "MIS",
  method = "euclidean",
  diagonal = TRUE,
  ignore.blocks = TRUE
)

kbl(
  MIS.psi[order(MIS.psi$psi), ], 
  digits = 4
  )
```

There is also a “high-performance” (HP) version of this function with a
much lower memory footprint. It uses the options method = “euclidean”,
diagonal = TRUE, and ignore.blocks = TRUE by default.

``` r
MIS.psi <- workflowPsiHP(
  sequences = MIS.sequences,
  grouping.column = "MIS"
)
```

The output of `workflowPsi()` can transformed into a matrix to be
plotted as an adjacency network with the **qgraph** package.

``` r
#psi values to matrix
MIS.psi.matrix <- formatPsi(
  psi.values = MIS.psi,
  to = "matrix"
)

#dissimilariy to distance
MIS.distance <- 1/MIS.psi.matrix**4

#plotting network
qgraph::qgraph(
  MIS.distance,
  layout='spring',
  vsize=5,
  labels = colnames(MIS.distance),
  colors = viridis::viridis(2, begin = 0.3, end = 0.8, alpha = 0.5, direction = -1)
  )
```

Or as a matrix with **ggplot2**.

``` r
#ordering factors to get a triangular matrix
MIS.psi$A <- factor(MIS.psi$A, levels=unique(mis$MIS))
MIS.psi$B <- factor(MIS.psi$B, levels=unique(mis$MIS))

#plotting matrix
ggplot(
  data = na.omit(MIS.psi), 
  aes(
    x = A, 
    y = B, 
    size = psi, 
    color = psi)
  ) + 
  geom_point() +
  viridis::scale_color_viridis(direction = -1) +
  guides(size = FALSE) + 
  theme_bw()
```

The dataframe of dissimilarities between pairs of sequences can be also
used to analyze the drivers of dissimilarity. To do so, attributes such
as differences in time (when sequences represent different times) or
distance (when sequences represent different sites) between sequences,
or differences between physical/climatic attributes between sequences
such as topography or climate can be added to the table, so models such
as
![psi = A + B + C](https://latex.codecogs.com/png.latex?psi%20%3D%20A%20%2B%20B%20%2B%20C "psi = A + B + C")
(were A, B, and C are these attributes) can be fitted.

``` r
#cleaning workspace
rm(list = ls())
```

# Comparing regular aligned METS

The package *distantia* is also useful to compare synchronic sequences
that have the same number of samples. In this particular case, distances
to obtain
![AB\_{between}](https://latex.codecogs.com/png.latex?AB_%7Bbetween%7D "AB_{between}")
are computed only between samples with the same time/depth/order, and no
distance matrix (nor least-cost analysis) is required. When the argument
*paired.samples* in **prepareSequences** is set to TRUE, the function
checks if the sequences have the same number of rows, and, if
*time.column* is provided, it selects the samples that have valid
time/depth columns for every sequence in the dataset.

Here we test these ideas with the **climate** dataset included in the
library. It represents simulated palaeoclimate over 200 ky. at four
sites identified by the column *sequenceId*. Note that this time the
transformation applied is “scaled”, which uses the **scale** function of
R base to center and scale the data.

``` r
#loading sample data
data(climate)

#preparing sequences
climate <- prepareSequences(
  sequences = climate,
  grouping.column = "sequenceId",
  time.column = "time",
  paired.samples = TRUE,
  transformation = "scale"
  )
```

In this case, the argument *paired.samples* of **workflowPsi** must be
set to TRUE. Additionally, if the argument *same.time* is set to TRUE,
the time/age of the samples is checked, and samples without the same
time/age are removed from the analysis.

``` r
#computing psi
climate.psi <- workflowPsi(
  sequences = climate,
  grouping.column = "sequenceId",
  time.column = "time",
  method = "euclidean",
  paired.samples = TRUE, #this bit is important
  same.time = TRUE, #removes samples with unequal time
  format = "dataframe"
)

#ordered with lower psi on top
kbl(climate.psi[order(climate.psi$psi), ], digits = 4, row.names = FALSE, caption = "Psi values between pairs of sequences in the 'climate' dataset.")
```

``` r
#cleaning workspace
rm(list = ls())
```

# Restricted permutation test to assess the significance of dissimilarity values

One question that may arise when comparing time series is *to what
extent are dissimilarity values a result of chance?*. Answering this
question requires to compare a given dissimilarity value with a
distribution of dissimilarity values resulting from chance. However… how
do we simulate chance in a multivariate time-series? The natural answer
is “permutation”. Since samples in a multivariate time-series are
ordered, randomly re-shuffling samples is out of the question, because
that would destroy the structure of the data. A more gentler alternative
is to randomly switch single data-points (a case of a variable)
independently by variable. This kind of permutation is named “restricted
permutation”, and preserves global trends within the data, but changes
local structure.

A restricted permutation test on *psi* values requires the following
steps:

- Compute the *real psi* on two given sequences A and B.
- Repeat the following steps several times (99 to 999):
  - For each case of each column of A and B, randomly apply one of these
    actions:
    - Leave it as is.
    - Replace it with the previous case.
    - Replace it with the next case.
  - Compute *randomized psi* between A and B and store the value.
- Add *real psi* to the pool of *randomized psi*.
- Compute the proportion of *randomized psi* that is equal or lower than
  *real psi*.

Such a proportion represents the probability of obtaining a value lower
than *real psi* by chance.

Since the restricted permutation only happens at a local scale within
each column of each sequence, the probability values returned are **very
conservative** and shouldn’t be interpreted in the same way p-values are
interpreted.

The process described above has been implemented in the
**workflowNullPsi** function. We will apply it to three groups of the
*mis* dataset.

``` r
#getting example data
data(mis)

#working with 3 groups (to make this fast)
mis <- mis[mis$MIS %in% c("MIS-4", "MIS-5", "MIS-6"),]

#preparing sequences
mis <- prepareSequences(
  sequences = mis,
  grouping.column = "MIS",
  transformation = "hellinger"
)
```

The computation of the null psi values goes as follows:

``` r
random.psi <- workflowNullPsi(
  sequences = mis,
  grouping.column = "MIS",
  method = "euclidean",
  diagonal = TRUE,
  ignore.blocks = TRUE,
  repetitions = 99, #recommended value: 999
  parallel.execution = TRUE
)

#there is also a high-performance version of this function with fewer options (diagonal = TRUE, ignore.blocks = TRUE, and method = "euclidean" are used by default)
random.psi <- workflowNullPsiHP(
  sequences = mis,
  grouping.column = "MIS",
  repetitions = 99, #recommended value: 999
  parallel.execution = TRUE
)
```

Note that the number of repetitions has been set to 9 in order to
speed-up execution. The actual number would ideally be 999.

The output is a list with two dataframes, **psi** and **p**.

The dataframe **psi** contains the real and random psi values. The
column *psi* contains the dissimilarity between the sequences in the
columns *A* and *B*. The columns *r1* to *r9* contain the psi values
obtained from permutations of the sequences.

``` r
kbl(
  random.psi$psi, 
  digits = 4
  )
```

The dataframe *p* contains the probability of obtaining the real *psi*
value by chance for each combination of sequences.

``` r
kbl(random.psi$p)
```

``` r
#cleaning workspace
rm(list = ls())
```

# Assessing the contribution of a variable to the dissimilarity between two sequences

*What variables are more important in explaining the dissimilarity
between two sequences?*, or in other words, *what variables contribute
the most to the dissimilarity between two sequences?* One reasonable
answer is: the one that reduces dissimilarity the most when removed from
the data. This section explains how to use the function
**workflowImportance** follows such a principle to evaluate the
importance of given variables in explaining differences between
sequences.

First, we prepare the data. It is again *mis*, but with only
three groups selected (MIS 4 to 6) to simplify the analysis.

``` r
#getting example data
data(mis)

#getting three groups only to simplify
mis <- mis[mis$MIS %in% c("MIS-4", "MIS-5", "MIS-6"),]

#preparing sequences
sequences <- prepareSequences(
  sequences = mis,
  grouping.column = "MIS",
  merge.mode = "complete"
)
```

The workflow function is pretty similar to the ones explained above.
However, unlike the other functions in the package, that parallelize
across the comparison of pairs of sequences, this one parallelizes the
computation of *psi* on combinations of columns, removing one column
each time.

``` r
psi.importance <- workflowImportance(
  sequences = mis,
  grouping.column = "MIS",
  method = "euclidean",
  diagonal = TRUE,
  ignore.blocks = TRUE
  )
```

There is also a high performance version of this function, but with
fewer options (it uses euclidean, diagonal, and ignores blocks by
default)

``` r
psi.importance <- workflowImportanceHP(
  sequences = mis,
  grouping.column = "MIS"
  )
```

The output is a list with two slots named *psi* and *psi.drop*.

The dataframe **psi** contains psi values for each combination of
variables (named in the coluns *A* and *B*) computed for all columns in
the column *All variables*, and one column per variable named *Without
variable_name* containing the psi value when that variable is removed
from the compared sequences.

``` r
kbl(psi.importance$psi, digits = 4,)
```

This table can be plotted as a bar plot as follows:

``` r
#extracting object
psi.df <- psi.importance$psi

#to long format
psi.df.long <- tidyr::gather(psi.df, variable, psi, 3:ncol(psi.df))

#creating column with names of the sequences
psi.df.long$name <- paste(psi.df.long$A, psi.df.long$B, sep=" - ")

#plot
ggplot(data=psi.df.long, aes(x=variable, y=psi, fill=psi)) + 
  geom_bar(stat = "identity") + 
  coord_flip() + 
  facet_wrap("name") +
  scale_fill_viridis(direction = -1) +
  ggtitle("Contribution of separated variables to dissimilarity.") +
  labs(fill = "Psi") + 
  theme_bw()
```

The second table, named **psi.drop** describes the drop in psi values,
in percentage, when the given variable is removed from the analysis.
Large positive numbers indicate that dissimilarity drops (increase in
similarity) when the given variable is removed, confirming that the
variable is important to explain the dissimilarity between both
sequences. Negative values indicate an increase in dissimilarity between
the sequences when the variable is dropped.

In summary:

- High psi-drop value: variable contributes to dissimilarity.
- Low or negative psi-drop value: variable contributes to similarity.

``` r
kbl(psi.importance$psi.drop)
```

``` r
#extracting object
psi.drop.df <- psi.importance$psi.drop

#to long format
psi.drop.df.long <- tidyr::gather(psi.drop.df, variable, psi, 3:ncol(psi.drop.df))

#creating column with names of the sequences
psi.drop.df.long$name <- paste(psi.drop.df.long$A, psi.drop.df.long$B, sep=" - ")

#plot
ggplot(data=psi.drop.df.long, aes(x=variable, y=psi, fill=psi)) + 
  geom_bar(stat = "identity") + 
  coord_flip() + 
  geom_hline(yintercept = 0, size = 0.3) + 
  facet_wrap("name") +
  scale_fill_viridis(direction = -1) +
  ggtitle("Drop in dissimilarity when variables are removed.") +
  ylab("Drop in dissimilarity (%)") +
  labs(fill = "Psi drop (%)") + 
  theme_bw()
```

``` r
#cleaning workspace
rm(list = ls())
```

# Partial matching: finding the section in a long sequence more similar to a given short sequence

In this scenario the user has one short and one long sequence, and the
goal is to find the section in the long sequence that better matches the
short one. To recreate this scenario we use the dataset *mis*.
The first 10 samples will serve as short sequence, and the first 40
samples as long sequence. These small subsets are selected to speed-up
the execution time of this example.

``` r
#loading the data
data(mis)

#removing grouping column
mis$MIS <- NULL

#subsetting to get the short sequence
MIS.short <- mis[1:10, ]

#subsetting to get the long sequence
MIS.long <- mis[1:40, ]
```

The sequences have to be prepared and transformed. For simplicity, the
sequences are named *short* and *long*, and the grouping column is named
*id*, but the user can name them at will. Since the data represents
community composition, a Hellinger transformation is applied.

``` r
MIS.short.long <- prepareSequences(
  sequence.A = MIS.short,
  sequence.A.name = "short",
  sequence.B = MIS.long,
  sequence.B.name = "long",
  grouping.column = "id",
  transformation = "hellinger"
)
```

The function **workflowPartialMatch** shown below is going to subset the
long sequence in sizes between *min.length* and *max.length*. In the
example below this search space has the same size as *MIS.short* to
speed-up the execution of this example, but wider windows are possible.
If left empty, the length of the segment in the long sequence to be
matched will have the same number of samples as the short sequence. In
the example below we look for segments of the same length, two samples
shorter, and two samples longer than the shorter sequence.

``` r
MIS.psi <- workflowPartialMatch(
  sequences = MIS.short.long,
  grouping.column = "id",
  method = "euclidean",
  diagonal = TRUE,
  ignore.blocks = TRUE,
  min.length = nrow(MIS.short),
  max.length = nrow(MIS.short)
)
```

The function returns a dataframe with three columns: *first.row* (first
row of the matched segment of the long sequence), *last.row* (last row
of the matched segment of the long sequence), and *psi* (ordered from
lower to higher). In this case, since the long sequence contains the
short sequence, the first row shows a perfect match.

``` r
kbl(MIS.psi[1:15, ], digits = 4)
```

Subsetting the long sequence to obtain the segment best matching with
the short sequence goes as follows.

``` r
#indices of the best matching segment
best.match.indices <- MIS.psi[1, "first.row"]:MIS.psi[1, "last.row"]

#subsetting by these indices
best.match <- MIS.long[best.match.indices, ]
```

``` r
#cleaning workspace
rm(list = ls())
```

# Sequence slotting: combining samples of two sequences into a single composite sequence

Under this scenario, the objective is to combine two sequences into a
single composite sequence. The basic assumption followed by the
algorithm building the composite sequence is *most similar samples
should go together, but respecting the original ordering of the
sequences*. Therefore, the output will contain the samples in both
sequences ordered in a way that minimizes the multivariate distance
between consecutive samples. This scenario assumes that at least one of
the sequences do not have a time/age/depth column, or that the values in
such a column are uncertain. In any case, time/age/depth is not
considered as a factor in the generation of the composite sequence.

The example below uses the **pollenGP** dataset, which contains 200
samples, with 40 pollen types each. To create a smalle case study, the
code below separates the first 20 samples of the sequence into two
different sequences with 10 randomly selected samples each. Even though
this scenario assumes that these sequences do not have depth or age,
these columns will be kept so the result can be assessed. That is why
these columns are added to the *exclude.columns* argument. Also, note
that the argument *transformation* is set to “none”, so the output is
not transformed, and the outcome can be easily interpreted. This will
give more weight to the most abundant taxa, which will in fact guide the
slotting.

``` r
#loading the data
data(pollenGP)

#getting first 20 samples
pollenGP <- pollenGP[1:20, ]

#sampling indices
set.seed(10) #to get same result every time
sampling.indices <- sort(sample(1:20, 10))

#subsetting the sequence
A <- pollenGP[sampling.indices, ]
B <- pollenGP[-sampling.indices, ]

#preparing the sequences
AB <- prepareSequences(
  sequence.A = A,
  sequence.A.name = "A",
  sequence.B = B,
  sequence.B.name = "B",
  grouping.column = "id",
  exclude.columns = c("depth", "age"),
  transformation = "none"
)
```

Once the sequences are prepared, the function **workflowSlotting** will
allow to combine (slot) them. The function computes a distance matrix
between the samples in both sequences according to the *method*
argument, computes the least-cost matrix, and generates the least-cost
path. Note that it only uses an orthogonal method considering blocks,
since this is the only option really suitable for this task.

``` r
AB.combined <- workflowSlotting(
  sequences = AB,
  grouping.column = "id",
  time.column = "age", 
  exclude.columns = "depth",
  method = "euclidean",
  plot = TRUE
)
```

The function reads the least-cost path in order to find the combination
of samples of both sequences that minimizes dissimilarity, constrained
by the order of the samples on each sequence. The output dataframe has a
column named *original.index*, which has the index of each sample in the
original datasets.

``` r
kbl(
  AB.combined[1:15,1:10], 
  digits = 4, 
  caption = "Combination of sequences A and B."
  )
```

Note that several samples show inverted ages with respect to the
previous samples. This is to be expected, since the slotting algorithm
only takes into account distance/dissimilarity between adjacent samples
to generate the ordering.

``` r
#cleaning workspace
rm(list = ls())
```

# Transferring an attribute from one sequence to another

This scenario assumes that the user has two METS, one of them with a
given attribute (age/time) that needs to be transferred to the other
sequence by using similarity/dissimilarity (constrained by sample order)
as a transfer criterion. This case is relatively common in
palaeoecology, when a given dataset is dated, and another taken at a
close location is not.

The code below prepares the data for the example. The sequence
**pollenGP** is the reference sequence, and contains the column *age*.
The sequence **pollenX** is the target sequence, without an *age*
column. We generate it by taking 40 random samples between the samples
50 and 100 of **pollenGP**. The sequences are prepared with
*prepareSequences*, as usual, with the identificators “GP” and “X”

``` r
#loading sample dataset
data(pollenGP)

#subset pollenGP to make a shorter dataset
pollenGP <- pollenGP[1:50, ]

#generating a subset of pollenGP 
set.seed(10)
pollenX <- pollenGP[sort(sample(1:50, 40)), ]

#we separate the age column
pollenX.age <- pollenX$age

#and remove the age values from pollenX
pollenX$age <- NULL
pollenX$depth <- NULL

#removing some samples from pollenGP
#so pollenX is not a perfect subset of pollenGP
pollenGP <- pollenGP[-sample(1:50, 10), ]

#prepare sequences
GP.X <- prepareSequences(
  sequence.A = pollenGP,
  sequence.A.name = "GP",
  sequence.B = pollenX,
  sequence.B.name = "X",
  grouping.column = "id",
  time.column = "age",
  exclude.columns = "depth",
  transformation = "none"
)
```

The transfer of “age” values from *GP* to *X* can be done in two ways,
both constrained by sample order:

- **Direct**: each sample in *X* gets the age of its most similar sample
  in *GP*.
- **Interpolated**: each sample in *X* gets an age interpolated from the
  ages of the two most similar samples in *GP*. The interpolation is
  weighted by the similarity between the samples.

## Direct transfer

A direct transfer of an attribute from the samples of one sequence to
the samples of another requires to compute a distance matrix between
samples, the least-cost matrix and its least-cost path (both with the
option *diagonal* activated), and to parse the least-cost path file to
assign attribute values. This is done by the function
**workflowTransfer** with the option
![mode = "direct"](https://latex.codecogs.com/png.latex?mode%20%3D%20%22direct%22 "mode = "direct"").

``` r
#parameters
X.new <- workflowTransfer(
  sequences = GP.X,
  grouping.column = "id",
  time.column = "age",
  method = "euclidean",
  transfer.what = "age",
  transfer.from = "GP",
  transfer.to = "X",
  mode = "direct"
  )

kbl(X.new[1:15, ], digits = 4)
```

The algorithm finds the most similar samples, and transfers attribute
values directly between them. This can result in duplicated attribute
values, as highlighted in the table above.

## Interpolated transfer

If we consider:

- Two samples
  ![A\_{i}](https://latex.codecogs.com/png.latex?A_%7Bi%7D "A_{i}") and
  ![A\_{j}](https://latex.codecogs.com/png.latex?A_%7Bj%7D "A_{j}") of
  the sequence ![A](https://latex.codecogs.com/png.latex?A "A").
- Each one with a value the attribute
  ![t](https://latex.codecogs.com/png.latex?t "t"),
  ![At\_{i}](https://latex.codecogs.com/png.latex?At_%7Bi%7D "At_{i}")
  and
  ![At\_{j}](https://latex.codecogs.com/png.latex?At_%7Bj%7D "At_{j}").
- One sample
  ![B\_{k}](https://latex.codecogs.com/png.latex?B_%7Bk%7D "B_{k}") of
  the sequence ![B](https://latex.codecogs.com/png.latex?B "B").
- With an **unknown attribute**
  ![Bt\_{k}](https://latex.codecogs.com/png.latex?Bt_%7Bk%7D "Bt_{k}").
- The multivariate distance
  ![D\_{B\_{k}A\_{i}}](https://latex.codecogs.com/png.latex?D_%7BB_%7Bk%7DA_%7Bi%7D%7D "D_{B_{k}A_{i}}")
  between the samples
  ![A\_{i}](https://latex.codecogs.com/png.latex?A_%7Bi%7D "A_{i}") and
  ![B\_{k}](https://latex.codecogs.com/png.latex?B_%7Bk%7D "B_{k}").
- The multivariate distance
  ![D\_{B\_{k}A\_{j}}](https://latex.codecogs.com/png.latex?D_%7BB_%7Bk%7DA_%7Bj%7D%7D "D_{B_{k}A_{j}}")
  between the samples
  ![A\_{j}](https://latex.codecogs.com/png.latex?A_%7Bj%7D "A_{j}") and
  ![B\_{k}](https://latex.codecogs.com/png.latex?B_%7Bk%7D "B_{k}").
- The weight
  ![w\_{i}](https://latex.codecogs.com/png.latex?w_%7Bi%7D "w_{i}"),
  computed as
  ![D\_{B\_{k}A\_{i}} / (D\_{B\_{k}A\_{i}} + D\_{B\_{k}A\_{j}})](https://latex.codecogs.com/png.latex?D_%7BB_%7Bk%7DA_%7Bi%7D%7D%20%2F%20%28D_%7BB_%7Bk%7DA_%7Bi%7D%7D%20%2B%20D_%7BB_%7Bk%7DA_%7Bj%7D%7D%29 "D_{B_{k}A_{i}} / (D_{B_{k}A_{i}} + D_{B_{k}A_{j}})")
- The weight
  ![w\_{j}](https://latex.codecogs.com/png.latex?w_%7Bj%7D "w_{j}"),
  computed as
  ![D\_{B\_{k}A\_{j}} / (D\_{B\_{k}A\_{i}} + D\_{B\_{k}A\_{j}})](https://latex.codecogs.com/png.latex?D_%7BB_%7Bk%7DA_%7Bj%7D%7D%20%2F%20%28D_%7BB_%7Bk%7DA_%7Bi%7D%7D%20%2B%20D_%7BB_%7Bk%7DA_%7Bj%7D%7D%29 "D_{B_{k}A_{j}} / (D_{B_{k}A_{i}} + D_{B_{k}A_{j}})")

The unknwon value
![Bt\_{k}](https://latex.codecogs.com/png.latex?Bt_%7Bk%7D "Bt_{k}") is
computed as:

![Bt\_{k} = w\_{i} \times At\_{i} + w\_{j} \times At\_{j}](https://latex.codecogs.com/png.latex?Bt_%7Bk%7D%20%3D%20w_%7Bi%7D%20%5Ctimes%20At_%7Bi%7D%20%2B%20w_%7Bj%7D%20%5Ctimes%20At_%7Bj%7D "Bt_{k} = w_{i} \times At_{i} + w_{j} \times At_{j}")

The code below exemplifies the operation, using the samples 1 and 4 of
the dataset *pollenGP* as
![Ai](https://latex.codecogs.com/png.latex?Ai "Ai") and
![Aj](https://latex.codecogs.com/png.latex?Aj "Aj"), and the sample 3 as
![Bk](https://latex.codecogs.com/png.latex?Bk "Bk").

``` r
#loading data
data(pollenGP)

#samples in A
Ai <- pollenGP[1, 3:ncol(pollenGP)]
Aj <- pollenGP[4, 3:ncol(pollenGP)]

#ages of the samples in A
Ati <- pollenGP[1, "age"]
Atj <- pollenGP[4, "age"]

#sample in B
Bk <- pollenGP[2, 3:ncol(pollenGP)]

#computing distances between Bk, Ai, and Aj
DBkAi <- distance(Bk, Ai)
DBkAj <- distance(Bk, Aj)

#normalizing the distances to 1
wi <- DBkAi / (DBkAi + DBkAj)
wj <- DBkAj / (DBkAi + DBkAj)

#computing  Btk
Btk <- wi * Ati + wj * Atj
```

The table below shows the observed versus the predicted values for
![Btk](https://latex.codecogs.com/png.latex?Btk "Btk").

``` r
temp.df <- data.frame(Observed = pollenGP[3, "age"], Predicted = Btk)
kbl(t(temp.df), digits = 4, caption = "Observed versus predicted value in the interpolation of an age based on similarity between samples.")
```

Below we create some example data, where a subset of *pollenGP* will be
the donor of age values, and another subset of it, named *pollenX* will
be the receiver of the age values.

``` r
#loading sample dataset
data(pollenGP)

#subset pollenGP to make a shorter dataset
pollenGP <- pollenGP[1:50, ]

#generating a subset of pollenGP 
set.seed(10)
pollenX <- pollenGP[sort(sample(1:50, 40)), ]

#we separate the age column
pollenX.age <- pollenX$age

#and remove the age values from pollenX
pollenX$age <- NULL
pollenX$depth <- NULL

#removing some samples from pollenGP
#so pollenX is not a perfect subset of pollenGP
pollenGP <- pollenGP[-sample(1:50, 10), ]

#prepare sequences
GP.X <- prepareSequences(
  sequence.A = pollenGP,
  sequence.A.name = "GP",
  sequence.B = pollenX,
  sequence.B.name = "X",
  grouping.column = "id",
  time.column = "age",
  exclude.columns = "depth",
  transformation = "none"
)
```

To transfer attributes from *GP* to *X* we use the **workflowTransfer**
function with the option *mode = “interpolate”*.

``` r
#parameters
X.new <- workflowTransfer(
  sequences = GP.X,
  grouping.column = "id",
  time.column = "age",
  method = "euclidean",
  transfer.what = "age",
  transfer.from = "GP",
  transfer.to = "X",
  mode = "interpolated"
  )

kbl(X.new[1:15, ], digits = 4, caption = "Result of the transference of an age attribute from one sequence to another. NA values are expected when predicted ages for a given sample yield a higher number than the age of the previous sample.")  %>% 
  row_spec(c(8, 13), bold = T)
```

When interpolated values of the *age* column (transferred attribute via
interpolation) show the value *NA*, it means that the interpolation
yielded an age lower than the previous one. This happens when the same
![Ai](https://latex.codecogs.com/png.latex?Ai "Ai") and
![Aj](https://latex.codecogs.com/png.latex?Aj "Aj") are used to evaluate
two or more different samples
![Bk](https://latex.codecogs.com/png.latex?Bk "Bk"), and the second
![Bk](https://latex.codecogs.com/png.latex?Bk "Bk") is more similar to
![Ai](https://latex.codecogs.com/png.latex?Ai "Ai") than the first one.
These NA values can be removed with *na.omit()*, or interpolated with
the functions
[imputeTS::na.interpolation](https://www.rdocumentation.org/packages/imputeTS/versions/2.7/topics/na.interpolation)
or
[zoo::na.approx](https://www.rdocumentation.org/packages/zoo/versions/1.8-6/topics/na.approx).

**IMPORTANT:** the interpretation of the interpolated ages requires a
careful consideration. Please, don’t do it blindly, because this
algorithm has its limitations. For example, significant hiatuses in the
data can introduce wild variations in interpolated ages.

``` r
#cleaning workspace
rm(list = ls())
```
