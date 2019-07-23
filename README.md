distantia: an R package to compute the dissimilarity between
multivariate time-series
================

<!-- README.md is generated from README.Rmd. Please edit that file -->

<!-- badges: start -->

[![DOI](https://zenodo.org/badge/187805264.svg)](https://zenodo.org/badge/latestdoi/187805264)
[![CRAN\_Release\_Badge](http://www.r-pkg.org/badges/version-ago/distantia)](https://CRAN.R-project.org/package=distantia)
[![CRAN\_Download\_Badge](http://cranlogs.r-pkg.org/badges/distantia)](https://CRAN.R-project.org/package=distantia)

<!-- badges: end -->

## Summary

The package **distantia** allows to measure the dissimilarity between
multivariate ecological time-series (*METS* hereafter). The package
assumes that the target sequences are ordered along a given dimension,
being depth and time the most common ones, but others such as latitude
or elevation are also possible. Furthermore, the target METS can be
regular or irregular, and have their samples aligned (same
age/time/depth) or unaligned (different age/time/depth). The only
requirement is that the sequences must have at least two (but ideally
more) columns with the same name and units representing different
variables relevant to the dynamics of an ecological system.

In this document I explain the logics behind the method, show how to use
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
  - Partial matching: finding the section in a long METS more similar to
    a given shorter one.
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
install.packages("devtools")
library(devtools)
devtools::install_github("BlasBenito/distantia")
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
kable(sequenceA[1:15, ], caption = "Sequence A")
```

<table>

<caption>

Sequence A

</caption>

<thead>

<tr>

<th style="text-align:right;">

betula

</th>

<th style="text-align:right;">

pinus

</th>

<th style="text-align:right;">

corylu

</th>

<th style="text-align:right;">

junipe

</th>

<th style="text-align:right;">

empetr

</th>

<th style="text-align:right;">

gramin

</th>

<th style="text-align:right;">

cypera

</th>

<th style="text-align:right;">

artemi

</th>

<th style="text-align:right;">

rumex

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:right;">

79

</td>

<td style="text-align:right;">

271

</td>

<td style="text-align:right;">

36

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

4

</td>

<td style="text-align:right;">

7

</td>

<td style="text-align:right;">

25

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:right;">

113

</td>

<td style="text-align:right;">

320

</td>

<td style="text-align:right;">

42

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

4

</td>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

11

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:right;">

51

</td>

<td style="text-align:right;">

420

</td>

<td style="text-align:right;">

39

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

12

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:right;">

130

</td>

<td style="text-align:right;">

470

</td>

<td style="text-align:right;">

6

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

4

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:right;">

31

</td>

<td style="text-align:right;">

450

</td>

<td style="text-align:right;">

6

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:right;">

59

</td>

<td style="text-align:right;">

425

</td>

<td style="text-align:right;">

12

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:right;">

78

</td>

<td style="text-align:right;">

386

</td>

<td style="text-align:right;">

29

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:right;">

71

</td>

<td style="text-align:right;">

397

</td>

<td style="text-align:right;">

52

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

6

</td>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:right;">

140

</td>

<td style="text-align:right;">

310

</td>

<td style="text-align:right;">

50

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

4

</td>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:right;">

150

</td>

<td style="text-align:right;">

323

</td>

<td style="text-align:right;">

34

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

11

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:right;">

175

</td>

<td style="text-align:right;">

317

</td>

<td style="text-align:right;">

37

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

11

</td>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:right;">

181

</td>

<td style="text-align:right;">

345

</td>

<td style="text-align:right;">

28

</td>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

7

</td>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:right;">

153

</td>

<td style="text-align:right;">

285

</td>

<td style="text-align:right;">

36

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

8

</td>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

</tr>

<tr>

<td style="text-align:right;">

214

</td>

<td style="text-align:right;">

315

</td>

<td style="text-align:right;">

54

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

13

</td>

<td style="text-align:right;">

5

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:right;">

200

</td>

<td style="text-align:right;">

210

</td>

<td style="text-align:right;">

41

</td>

<td style="text-align:right;">

6

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

10

</td>

<td style="text-align:right;">

4

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

</tr>

</tbody>

</table>

``` r
kable(sequenceB[1:15, ], caption = "Sequence B")
```

<table>

<caption>

Sequence B

</caption>

<thead>

<tr>

<th style="text-align:right;">

betula

</th>

<th style="text-align:right;">

pinus

</th>

<th style="text-align:right;">

corylu

</th>

<th style="text-align:right;">

junipe

</th>

<th style="text-align:right;">

gramin

</th>

<th style="text-align:right;">

cypera

</th>

<th style="text-align:right;">

artemi

</th>

<th style="text-align:right;">

rumex

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:right;">

19

</td>

<td style="text-align:right;">

175

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

34

</td>

<td style="text-align:right;">

39

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:right;">

18

</td>

<td style="text-align:right;">

119

</td>

<td style="text-align:right;">

28

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

36

</td>

<td style="text-align:right;">

44

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

4

</td>

</tr>

<tr>

<td style="text-align:right;">

30

</td>

<td style="text-align:right;">

99

</td>

<td style="text-align:right;">

37

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

20

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

</tr>

<tr>

<td style="text-align:right;">

26

</td>

<td style="text-align:right;">

101

</td>

<td style="text-align:right;">

29

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

18

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:right;">

31

</td>

<td style="text-align:right;">

99

</td>

<td style="text-align:right;">

30

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

10

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:right;">

24

</td>

<td style="text-align:right;">

97

</td>

<td style="text-align:right;">

28

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

9

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:right;">

23

</td>

<td style="text-align:right;">

105

</td>

<td style="text-align:right;">

34

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

6

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:right;">

48

</td>

<td style="text-align:right;">

112

</td>

<td style="text-align:right;">

46

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

12

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:right;">

29

</td>

<td style="text-align:right;">

108

</td>

<td style="text-align:right;">

16

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

6

</td>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:right;">

23

</td>

<td style="text-align:right;">

110

</td>

<td style="text-align:right;">

21

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

11

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

</tr>

<tr>

<td style="text-align:right;">

5

</td>

<td style="text-align:right;">

119

</td>

<td style="text-align:right;">

19

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:right;">

30

</td>

<td style="text-align:right;">

105

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

9

</td>

<td style="text-align:right;">

7

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:right;">

22

</td>

<td style="text-align:right;">

116

</td>

<td style="text-align:right;">

17

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

7

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:right;">

24

</td>

<td style="text-align:right;">

115

</td>

<td style="text-align:right;">

20

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

4

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:right;">

26

</td>

<td style="text-align:right;">

119

</td>

<td style="text-align:right;">

23

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

4

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

</tr>

</tbody>

</table>

### Data preparation

Notice that **sequenceB** has a few NA values (that were introduced to
serve as an example). The function **prepareSequences** gets them ready
for analysis by matching colum names and handling empty data. It allows
to merge two or more METS into a single dataframe ready for further
analyses. Note that, since the data represents pollen abundances, a
*Hellinger* transformation (square root of the relative proportions of
each taxa) is applied. This transformation balances the relative
importance of very abundant versus rare taxa. The function
**prepareSequences** will generally be the starting point of any
analysis performed with the *distantia* package.

``` r
#checking the function help-file.
help(prepareSequences)

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
kable(AB.sequences[1:15, ], digits = 4)
```

<table>

<thead>

<tr>

<th style="text-align:left;">

id

</th>

<th style="text-align:right;">

betula

</th>

<th style="text-align:right;">

pinus

</th>

<th style="text-align:right;">

corylu

</th>

<th style="text-align:right;">

junipe

</th>

<th style="text-align:right;">

empetr

</th>

<th style="text-align:right;">

gramin

</th>

<th style="text-align:right;">

cypera

</th>

<th style="text-align:right;">

artemi

</th>

<th style="text-align:right;">

rumex

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

A

</td>

<td style="text-align:right;">

0.4327

</td>

<td style="text-align:right;">

0.8014

</td>

<td style="text-align:right;">

0.2921

</td>

<td style="text-align:right;">

0.0002

</td>

<td style="text-align:right;">

0.0974

</td>

<td style="text-align:right;">

0.1288

</td>

<td style="text-align:right;">

0.2434

</td>

<td style="text-align:right;">

2e-04

</td>

<td style="text-align:right;">

0.0002

</td>

</tr>

<tr>

<td style="text-align:left;">

A

</td>

<td style="text-align:right;">

0.4788

</td>

<td style="text-align:right;">

0.8057

</td>

<td style="text-align:right;">

0.2919

</td>

<td style="text-align:right;">

0.0001

</td>

<td style="text-align:right;">

0.0901

</td>

<td style="text-align:right;">

0.0780

</td>

<td style="text-align:right;">

0.1494

</td>

<td style="text-align:right;">

1e-04

</td>

<td style="text-align:right;">

0.0001

</td>

</tr>

<tr>

<td style="text-align:left;">

A

</td>

<td style="text-align:right;">

0.3117

</td>

<td style="text-align:right;">

0.8944

</td>

<td style="text-align:right;">

0.2726

</td>

<td style="text-align:right;">

0.0001

</td>

<td style="text-align:right;">

0.0617

</td>

<td style="text-align:right;">

0.0436

</td>

<td style="text-align:right;">

0.1512

</td>

<td style="text-align:right;">

1e-04

</td>

<td style="text-align:right;">

0.0001

</td>

</tr>

<tr>

<td style="text-align:left;">

A

</td>

<td style="text-align:right;">

0.4609

</td>

<td style="text-align:right;">

0.8763

</td>

<td style="text-align:right;">

0.0990

</td>

<td style="text-align:right;">

0.0001

</td>

<td style="text-align:right;">

0.0001

</td>

<td style="text-align:right;">

0.0572

</td>

<td style="text-align:right;">

0.0808

</td>

<td style="text-align:right;">

1e-04

</td>

<td style="text-align:right;">

0.0001

</td>

</tr>

<tr>

<td style="text-align:left;">

A

</td>

<td style="text-align:right;">

0.2503

</td>

<td style="text-align:right;">

0.9535

</td>

<td style="text-align:right;">

0.1101

</td>

<td style="text-align:right;">

0.0001

</td>

<td style="text-align:right;">

0.0778

</td>

<td style="text-align:right;">

0.0636

</td>

<td style="text-align:right;">

0.0778

</td>

<td style="text-align:right;">

1e-04

</td>

<td style="text-align:right;">

0.0001

</td>

</tr>

<tr>

<td style="text-align:left;">

A

</td>

<td style="text-align:right;">

0.3432

</td>

<td style="text-align:right;">

0.9210

</td>

<td style="text-align:right;">

0.1548

</td>

<td style="text-align:right;">

0.0001

</td>

<td style="text-align:right;">

0.0001

</td>

<td style="text-align:right;">

0.0632

</td>

<td style="text-align:right;">

0.0774

</td>

<td style="text-align:right;">

1e-04

</td>

<td style="text-align:right;">

0.0001

</td>

</tr>

<tr>

<td style="text-align:left;">

A

</td>

<td style="text-align:right;">

0.3962

</td>

<td style="text-align:right;">

0.8813

</td>

<td style="text-align:right;">

0.2416

</td>

<td style="text-align:right;">

0.0634

</td>

<td style="text-align:right;">

0.0001

</td>

<td style="text-align:right;">

0.0001

</td>

<td style="text-align:right;">

0.0634

</td>

<td style="text-align:right;">

1e-04

</td>

<td style="text-align:right;">

0.0001

</td>

</tr>

<tr>

<td style="text-align:left;">

A

</td>

<td style="text-align:right;">

0.3657

</td>

<td style="text-align:right;">

0.8647

</td>

<td style="text-align:right;">

0.3129

</td>

<td style="text-align:right;">

0.0614

</td>

<td style="text-align:right;">

0.0001

</td>

<td style="text-align:right;">

0.1063

</td>

<td style="text-align:right;">

0.0752

</td>

<td style="text-align:right;">

1e-04

</td>

<td style="text-align:right;">

0.0001

</td>

</tr>

<tr>

<td style="text-align:left;">

A

</td>

<td style="text-align:right;">

0.5245

</td>

<td style="text-align:right;">

0.7804

</td>

<td style="text-align:right;">

0.3134

</td>

<td style="text-align:right;">

0.0627

</td>

<td style="text-align:right;">

0.0001

</td>

<td style="text-align:right;">

0.0886

</td>

<td style="text-align:right;">

0.0768

</td>

<td style="text-align:right;">

1e-04

</td>

<td style="text-align:right;">

0.0001

</td>

</tr>

<tr>

<td style="text-align:left;">

A

</td>

<td style="text-align:right;">

0.5361

</td>

<td style="text-align:right;">

0.7866

</td>

<td style="text-align:right;">

0.2552

</td>

<td style="text-align:right;">

0.0619

</td>

<td style="text-align:right;">

0.0001

</td>

<td style="text-align:right;">

0.1452

</td>

<td style="text-align:right;">

0.0619

</td>

<td style="text-align:right;">

1e-04

</td>

<td style="text-align:right;">

0.0001

</td>

</tr>

<tr>

<td style="text-align:left;">

A

</td>

<td style="text-align:right;">

0.5667

</td>

<td style="text-align:right;">

0.7627

</td>

<td style="text-align:right;">

0.2606

</td>

<td style="text-align:right;">

0.0606

</td>

<td style="text-align:right;">

0.0001

</td>

<td style="text-align:right;">

0.1421

</td>

<td style="text-align:right;">

0.0742

</td>

<td style="text-align:right;">

1e-04

</td>

<td style="text-align:right;">

0.0001

</td>

</tr>

<tr>

<td style="text-align:left;">

A

</td>

<td style="text-align:right;">

0.5650

</td>

<td style="text-align:right;">

0.7800

</td>

<td style="text-align:right;">

0.2222

</td>

<td style="text-align:right;">

0.0727

</td>

<td style="text-align:right;">

0.0001

</td>

<td style="text-align:right;">

0.1111

</td>

<td style="text-align:right;">

0.0727

</td>

<td style="text-align:right;">

1e-04

</td>

<td style="text-align:right;">

0.0001

</td>

</tr>

<tr>

<td style="text-align:left;">

A

</td>

<td style="text-align:right;">

0.5599

</td>

<td style="text-align:right;">

0.7642

</td>

<td style="text-align:right;">

0.2716

</td>

<td style="text-align:right;">

0.0640

</td>

<td style="text-align:right;">

0.0001

</td>

<td style="text-align:right;">

0.1280

</td>

<td style="text-align:right;">

0.0784

</td>

<td style="text-align:right;">

1e-04

</td>

<td style="text-align:right;">

0.0453

</td>

</tr>

<tr>

<td style="text-align:left;">

A

</td>

<td style="text-align:right;">

0.5952

</td>

<td style="text-align:right;">

0.7222

</td>

<td style="text-align:right;">

0.2990

</td>

<td style="text-align:right;">

0.0575

</td>

<td style="text-align:right;">

0.0407

</td>

<td style="text-align:right;">

0.1467

</td>

<td style="text-align:right;">

0.0910

</td>

<td style="text-align:right;">

1e-04

</td>

<td style="text-align:right;">

0.0001

</td>

</tr>

<tr>

<td style="text-align:left;">

A

</td>

<td style="text-align:right;">

0.6516

</td>

<td style="text-align:right;">

0.6677

</td>

<td style="text-align:right;">

0.2950

</td>

<td style="text-align:right;">

0.1129

</td>

<td style="text-align:right;">

0.0001

</td>

<td style="text-align:right;">

0.1457

</td>

<td style="text-align:right;">

0.0922

</td>

<td style="text-align:right;">

1e-04

</td>

<td style="text-align:right;">

0.0001

</td>

</tr>

</tbody>

</table>

The computation of dissimilarity between the datasets A and B requires
several
steps.

### 1\. Computation of a distance matrix among the samples of both sequences.

It is computed by the **distanceMatrix** function, which allows the user
to select a distance metric (so far the ones implemented are
*manhattan*, *euclidean*, *chi*, and *hellinger*). The function
**plotMatrix** allows an easy visualization of the distance matrix.

``` r
#computing distance matrix
AB.distance.matrix <- distanceMatrix(
  sequences = AB.sequences,
  method = "manhattan"
)

#plotting distance matrix
plotMatrix(
  distance.matrix = AB.distance.matrix,
  color.palette = "viridis",
  margins = rep(4,4))
```

<img src="man/figures/README-unnamed-chunk-7-1.png" title="Distance matrix between the samples of two irregular multivariate sequences. Darker colors indicate higher distance." alt="Distance matrix between the samples of two irregular multivariate sequences. Darker colors indicate higher distance." width="100%" />

### 2\. Computation of the least-cost path within the distance matrix.

This step uses a *dynamic programming algorithm* to find the least-cost
path when moving between the cell 1,1 of the matrix (lower left in the
image above) and the last cell of the matrix (opposite corner). This is
done via an \*orthogonal search** by moving either one step on the *x*
axis or one step on the *y* axis at a time (see **Equation 1\*\*).

**Equation 1**   
![AB\_{between} = 2 \\times (D(A\_{1}, B\_{1}) +
\\sum\_{i=1}^{m}\\sum\_{j=1}^{n} min\\left(\\begin{array}{c}D(A\_{i},
B\_{j+1}), \\\\ D(A\_{i+1}, B\_{j})
\\end{array}\\right))](https://latex.codecogs.com/png.latex?AB_%7Bbetween%7D%20%3D%202%20%5Ctimes%20%28D%28A_%7B1%7D%2C%20B_%7B1%7D%29%20%2B%20%5Csum_%7Bi%3D1%7D%5E%7Bm%7D%5Csum_%7Bj%3D1%7D%5E%7Bn%7D%20min%5Cleft%28%5Cbegin%7Barray%7D%7Bc%7DD%28A_%7Bi%7D%2C%20B_%7Bj%2B1%7D%29%2C%20%5C%5C%20D%28A_%7Bi%2B1%7D%2C%20B_%7Bj%7D%29%20%5Cend%7Barray%7D%5Cright%29%29
"AB_{between} = 2 \\times (D(A_{1}, B_{1}) + \\sum_{i=1}^{m}\\sum_{j=1}^{n} min\\left(\\begin{array}{c}D(A_{i}, B_{j+1}), \\\\ D(A_{i+1}, B_{j}) \\end{array}\\right))")  

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
    returning the minimum distance of a subset of distances defined in
    the neigborhood of the given indices
    ![i](https://latex.codecogs.com/png.latex?i "i") and
    ![j](https://latex.codecogs.com/png.latex?j "j")

The equation returns
![AB\_{between}](https://latex.codecogs.com/png.latex?AB_%7Bbetween%7D
"AB_{between}"), which is the double of the sum of distances that lie
within the least-cost path, and represent the distance *between* the
samples of A and B. The value of
![AB\_{between}](https://latex.codecogs.com/png.latex?AB_%7Bbetween%7D
"AB_{between}") is computed by using the functions **leastCostMatrix**,
which computes the partial solutions to the least-cost problem,
**leastCostPath**, which returns the best global solution, and
**leastCost** function, which sums the distances of the least-cost path
and multiplies them by 2.

``` r
#computing least-cost matrix
AB.least.cost.matrix <- leastCostMatrix(
  distance.matrix = AB.distance.matrix
)

#extracting least-cost path
AB.least.cost.path <- leastCostPath(
  distance.matrix = AB.distance.matrix,
  least.cost.matrix = AB.least.cost.matrix
  )

#computing AB.between
AB.between <- leastCost(
  least.cost.path = AB.least.cost.path
  )

#plotting the global solution
par(mfrow=c(2,1))
plotMatrix(
  distance.matrix = AB.least.cost.matrix,
  least.cost.path = AB.least.cost.path,
  color.palette = "viridis",
  margin = rep(4,4)
  )
```

<img src="man/figures/README-unnamed-chunk-8-1.png" title="Least-cost path plotted on the least-cost matrix." alt="Least-cost path plotted on the least-cost matrix." width="100%" />

Which returns a value for
![AB\_{between}](https://latex.codecogs.com/png.latex?AB_%7Bbetween%7D
"AB_{between}") of 76.4703.

Notice that in the output list, the slot with the psi value is named
after the two sequences separated by a vertical line (“A|B”). This
convention will be followed by any function in the package that returns
objects resulting from comparing two
sequences.

### 3\. Autosum, or sum of the distances among adjacent samples on each sequence.

This step requires to compute the distances between adjacent samples in
each sequence and sum them, as shown in **Equation 3**.

**Equation 3**   
![AB\_{within} = \\sum\_{i=1}^{m} D(A\_{i }, A\_{i + 1}) +
\\sum\_{i=1}^{n} D(B\_{i }, B\_{i
+ 1})](https://latex.codecogs.com/png.latex?AB_%7Bwithin%7D%20%3D%20%5Csum_%7Bi%3D1%7D%5E%7Bm%7D%20D%28A_%7Bi%20%7D%2C%20A_%7Bi%20%2B%201%7D%29%20%2B%20%20%5Csum_%7Bi%3D1%7D%5E%7Bn%7D%20D%28B_%7Bi%20%7D%2C%20B_%7Bi%20%2B%201%7D%29
"AB_{within} = \\sum_{i=1}^{m} D(A_{i }, A_{i + 1}) +  \\sum_{i=1}^{n} D(B_{i }, B_{i + 1})")  

This operation is performed by the **autoSum** function shown below.

``` r
AB.within <- autoSum(
  sequences = AB.sequences,
  named.list = AB.least.cost.path,
  method = "manhattan"
  )
AB.within
#> $`A|B`
#> [1] 46.86205
```

### 4\. Compute dissimilarity score\*\* ![\\psi](https://latex.codecogs.com/png.latex?%5Cpsi "\\psi").

The dissimilarity measure
![\\psi](https://latex.codecogs.com/png.latex?%5Cpsi "\\psi") was first
described in the book [“Numerical methods in Quaternary pollen
analysis”](https://onlinelibrary.wiley.com/doi/abs/10.1002/gea.3340010406)
(Birks and Gordon, 1985). **Psi** is computed as follows:

  
![\\psi = \\frac{AB\_{between} -
AB\_{within}}{AB\_{within}}](https://latex.codecogs.com/png.latex?%5Cpsi%20%3D%20%5Cfrac%7BAB_%7Bbetween%7D%20-%20AB_%7Bwithin%7D%7D%7BAB_%7Bwithin%7D%7D
"\\psi = \\frac{AB_{between} - AB_{within}}{AB_{within}}")  

Which basically is the sum of the least-cost solution normalized by the
autosum of both sequences. This equation, implemented in the **psi**
function, only requires the least-cost, and the autosum of both
sequences, as follows.

``` r
AB.psi <- psi(
  least.cost = AB.between,
  autosum = AB.within
  )
AB.psi
#> $`A|B`
#> [1] 2.263633
```

In any case, the output of **psi** is a list, that can be transformed to
a dataframe or a matrix by using the **formatPsi** function.

``` r
#to dataframe
AB.psi.dataframe <- formatPsi(
  psi.values = AB.psi,
  to = "dataframe")
kable(AB.psi.dataframe, digits = 4)
```

<table>

<thead>

<tr>

<th style="text-align:left;">

A

</th>

<th style="text-align:left;">

B

</th>

<th style="text-align:right;">

psi

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

A

</td>

<td style="text-align:left;">

B

</td>

<td style="text-align:right;">

2.2636

</td>

</tr>

</tbody>

</table>

### workflowPsi: doing it all at once

All the steps required to compute **psi**, including the format options
provided by **formatPsi** are wrapped together in the function
**workflowPsi**, that works as follows with its default configuration:

``` r
#checking the help file
help(workflowPsi)

#computing psi for A and B
AB.psi <- workflowPsi(
  sequences = AB.sequences,
  grouping.column = "id",
  format = "list"
)
AB.psi
#> $`A|B`
#> [1] 2.263633
```

The function allows to exclude particular columns from the analysis
(argument *exclude.columns*), select different distance metrics
(argument *method*), use diagonals to find the least-cost path (argument
*diagonal*), or measure psi by ignoring blocks in the least-cost path
(argument *ignore.blocks*). Since we have observed several blocks in the
least-cost path, below we compute psi by ignoring them. Blocks inflate
the value of *psi* because the distance to the same sample is counted
again and again.

``` r
#cleaning workspace
rm(list = ls())
```

# Comparing multiple irregular METS

The package can work seamlessly with any given number of sequences, as
long as there is memory enough available. To do so, almost every
function uses the packages
[“doParallel”](https://CRAN.R-project.org/package=doParallel) and
[“foreach”](https://CRAN.R-project.org/package=foreach), that together
allow to parallelize the execution of the *distantia* functions by using
all the processors in your machine but one.

The example dataset *sequencesMIS* contains 12 sections of the same
sequence belonging to different marine isotopic stages identified by a
column named “MIS”. MIS stages with odd numbers are generally
interpreted as warm periods (interglacials), while the odd ones are
interpreted as cold periods (glacials). In any case, this interpretation
is not important to illustrate this capability of the library.

``` r
data(sequencesMIS)
kable(head(sequencesMIS, n=15), digits = 4)
```

<table>

<thead>

<tr>

<th style="text-align:left;">

MIS

</th>

<th style="text-align:right;">

Quercus

</th>

<th style="text-align:right;">

Betula

</th>

<th style="text-align:right;">

Pinus

</th>

<th style="text-align:right;">

Alnus

</th>

<th style="text-align:right;">

Tilia

</th>

<th style="text-align:right;">

Carpinus

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

MIS-1

</td>

<td style="text-align:right;">

55

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

5

</td>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

4

</td>

<td style="text-align:right;">

5

</td>

</tr>

<tr>

<td style="text-align:left;">

MIS-1

</td>

<td style="text-align:right;">

86

</td>

<td style="text-align:right;">

21

</td>

<td style="text-align:right;">

35

</td>

<td style="text-align:right;">

8

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

10

</td>

</tr>

<tr>

<td style="text-align:left;">

MIS-1

</td>

<td style="text-align:right;">

120

</td>

<td style="text-align:right;">

15

</td>

<td style="text-align:right;">

8

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

</tr>

<tr>

<td style="text-align:left;">

MIS-1

</td>

<td style="text-align:right;">

138

</td>

<td style="text-align:right;">

16

</td>

<td style="text-align:right;">

12

</td>

<td style="text-align:right;">

6

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

3

</td>

</tr>

<tr>

<td style="text-align:left;">

MIS-1

</td>

<td style="text-align:right;">

130

</td>

<td style="text-align:right;">

12

</td>

<td style="text-align:right;">

17

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

1

</td>

</tr>

<tr>

<td style="text-align:left;">

MIS-1

</td>

<td style="text-align:right;">

128

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

6

</td>

<td style="text-align:right;">

4

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

2

</td>

</tr>

<tr>

<td style="text-align:left;">

MIS-1

</td>

<td style="text-align:right;">

140

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

19

</td>

<td style="text-align:right;">

9

</td>

<td style="text-align:right;">

4

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;">

MIS-1

</td>

<td style="text-align:right;">

113

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

15

</td>

<td style="text-align:right;">

12

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

5

</td>

</tr>

<tr>

<td style="text-align:left;">

MIS-1

</td>

<td style="text-align:right;">

98

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

27

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;">

MIS-1

</td>

<td style="text-align:right;">

92

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

16

</td>

<td style="text-align:right;">

7

</td>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;">

MIS-1

</td>

<td style="text-align:right;">

73

</td>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

22

</td>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;">

MIS-1

</td>

<td style="text-align:right;">

91

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

21

</td>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

7

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;">

MIS-1

</td>

<td style="text-align:right;">

148

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

22

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

4

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;">

MIS-1

</td>

<td style="text-align:right;">

148

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

7

</td>

<td style="text-align:right;">

13

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;">

MIS-1

</td>

<td style="text-align:right;">

149

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

5

</td>

<td style="text-align:right;">

4

</td>

<td style="text-align:right;">

0

</td>

</tr>

</tbody>

</table>

``` r
unique(sequencesMIS$MIS)
#>  [1] "MIS-1"  "MIS-2"  "MIS-3"  "MIS-4"  "MIS-5"  "MIS-6"  "MIS-7" 
#>  [8] "MIS-8"  "MIS-9"  "MIS-10" "MIS-11" "MIS-12"
```

The dataset is checked and prepared with **prepareSequences**.

``` r
MIS.sequences <- prepareSequences(
  sequences = sequencesMIS,
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
  method = "euclidean"
)

#ordered with lower psi on top
kable(MIS.psi[order(MIS.psi$psi), ], digits = 4)
```

<table>

<thead>

<tr>

<th style="text-align:left;">

</th>

<th style="text-align:left;">

A

</th>

<th style="text-align:left;">

B

</th>

<th style="text-align:right;">

psi

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

65

</td>

<td style="text-align:left;">

MIS-10

</td>

<td style="text-align:left;">

MIS-12

</td>

<td style="text-align:right;">

0.4467

</td>

</tr>

<tr>

<td style="text-align:left;">

61

</td>

<td style="text-align:left;">

MIS-9

</td>

<td style="text-align:left;">

MIS-10

</td>

<td style="text-align:right;">

0.4820

</td>

</tr>

<tr>

<td style="text-align:left;">

24

</td>

<td style="text-align:left;">

MIS-3

</td>

<td style="text-align:left;">

MIS-6

</td>

<td style="text-align:right;">

0.4890

</td>

</tr>

<tr>

<td style="text-align:left;">

59

</td>

<td style="text-align:left;">

MIS-8

</td>

<td style="text-align:left;">

MIS-11

</td>

<td style="text-align:right;">

0.5226

</td>

</tr>

<tr>

<td style="text-align:left;">

62

</td>

<td style="text-align:left;">

MIS-9

</td>

<td style="text-align:left;">

MIS-11

</td>

<td style="text-align:right;">

0.5265

</td>

</tr>

<tr>

<td style="text-align:left;">

13

</td>

<td style="text-align:left;">

MIS-2

</td>

<td style="text-align:left;">

MIS-4

</td>

<td style="text-align:right;">

0.5462

</td>

</tr>

<tr>

<td style="text-align:left;">

66

</td>

<td style="text-align:left;">

MIS-11

</td>

<td style="text-align:left;">

MIS-12

</td>

<td style="text-align:right;">

0.5512

</td>

</tr>

<tr>

<td style="text-align:left;">

63

</td>

<td style="text-align:left;">

MIS-9

</td>

<td style="text-align:left;">

MIS-12

</td>

<td style="text-align:right;">

0.5630

</td>

</tr>

<tr>

<td style="text-align:left;">

60

</td>

<td style="text-align:left;">

MIS-8

</td>

<td style="text-align:left;">

MIS-12

</td>

<td style="text-align:right;">

0.5643

</td>

</tr>

<tr>

<td style="text-align:left;">

22

</td>

<td style="text-align:left;">

MIS-3

</td>

<td style="text-align:left;">

MIS-4

</td>

<td style="text-align:right;">

0.5813

</td>

</tr>

<tr>

<td style="text-align:left;">

12

</td>

<td style="text-align:left;">

MIS-2

</td>

<td style="text-align:left;">

MIS-3

</td>

<td style="text-align:right;">

0.5837

</td>

</tr>

<tr>

<td style="text-align:left;">

30

</td>

<td style="text-align:left;">

MIS-3

</td>

<td style="text-align:left;">

MIS-12

</td>

<td style="text-align:right;">

0.5917

</td>

</tr>

<tr>

<td style="text-align:left;">

64

</td>

<td style="text-align:left;">

MIS-10

</td>

<td style="text-align:left;">

MIS-11

</td>

<td style="text-align:right;">

0.6003

</td>

</tr>

<tr>

<td style="text-align:left;">

51

</td>

<td style="text-align:left;">

MIS-6

</td>

<td style="text-align:left;">

MIS-12

</td>

<td style="text-align:right;">

0.6297

</td>

</tr>

<tr>

<td style="text-align:left;">

32

</td>

<td style="text-align:left;">

MIS-4

</td>

<td style="text-align:left;">

MIS-6

</td>

<td style="text-align:right;">

0.6479

</td>

</tr>

<tr>

<td style="text-align:left;">

15

</td>

<td style="text-align:left;">

MIS-2

</td>

<td style="text-align:left;">

MIS-6

</td>

<td style="text-align:right;">

0.6561

</td>

</tr>

<tr>

<td style="text-align:left;">

26

</td>

<td style="text-align:left;">

MIS-3

</td>

<td style="text-align:left;">

MIS-8

</td>

<td style="text-align:right;">

0.6593

</td>

</tr>

<tr>

<td style="text-align:left;">

53

</td>

<td style="text-align:left;">

MIS-7

</td>

<td style="text-align:left;">

MIS-9

</td>

<td style="text-align:right;">

0.6603

</td>

</tr>

<tr>

<td style="text-align:left;">

54

</td>

<td style="text-align:left;">

MIS-7

</td>

<td style="text-align:left;">

MIS-10

</td>

<td style="text-align:right;">

0.6733

</td>

</tr>

<tr>

<td style="text-align:left;">

28

</td>

<td style="text-align:left;">

MIS-3

</td>

<td style="text-align:left;">

MIS-10

</td>

<td style="text-align:right;">

0.6744

</td>

</tr>

<tr>

<td style="text-align:left;">

27

</td>

<td style="text-align:left;">

MIS-3

</td>

<td style="text-align:left;">

MIS-9

</td>

<td style="text-align:right;">

0.6766

</td>

</tr>

<tr>

<td style="text-align:left;">

56

</td>

<td style="text-align:left;">

MIS-7

</td>

<td style="text-align:left;">

MIS-12

</td>

<td style="text-align:right;">

0.6931

</td>

</tr>

<tr>

<td style="text-align:left;">

47

</td>

<td style="text-align:left;">

MIS-6

</td>

<td style="text-align:left;">

MIS-8

</td>

<td style="text-align:right;">

0.6947

</td>

</tr>

<tr>

<td style="text-align:left;">

49

</td>

<td style="text-align:left;">

MIS-6

</td>

<td style="text-align:left;">

MIS-10

</td>

<td style="text-align:right;">

0.7085

</td>

</tr>

<tr>

<td style="text-align:left;">

57

</td>

<td style="text-align:left;">

MIS-8

</td>

<td style="text-align:left;">

MIS-9

</td>

<td style="text-align:right;">

0.7203

</td>

</tr>

<tr>

<td style="text-align:left;">

29

</td>

<td style="text-align:left;">

MIS-3

</td>

<td style="text-align:left;">

MIS-11

</td>

<td style="text-align:right;">

0.7222

</td>

</tr>

<tr>

<td style="text-align:left;">

40

</td>

<td style="text-align:left;">

MIS-5

</td>

<td style="text-align:left;">

MIS-7

</td>

<td style="text-align:right;">

0.7259

</td>

</tr>

<tr>

<td style="text-align:left;">

45

</td>

<td style="text-align:left;">

MIS-5

</td>

<td style="text-align:left;">

MIS-12

</td>

<td style="text-align:right;">

0.7299

</td>

</tr>

<tr>

<td style="text-align:left;">

58

</td>

<td style="text-align:left;">

MIS-8

</td>

<td style="text-align:left;">

MIS-10

</td>

<td style="text-align:right;">

0.7358

</td>

</tr>

<tr>

<td style="text-align:left;">

21

</td>

<td style="text-align:left;">

MIS-2

</td>

<td style="text-align:left;">

MIS-12

</td>

<td style="text-align:right;">

0.7516

</td>

</tr>

<tr>

<td style="text-align:left;">

19

</td>

<td style="text-align:left;">

MIS-2

</td>

<td style="text-align:left;">

MIS-10

</td>

<td style="text-align:right;">

0.7821

</td>

</tr>

<tr>

<td style="text-align:left;">

43

</td>

<td style="text-align:left;">

MIS-5

</td>

<td style="text-align:left;">

MIS-10

</td>

<td style="text-align:right;">

0.8236

</td>

</tr>

<tr>

<td style="text-align:left;">

55

</td>

<td style="text-align:left;">

MIS-7

</td>

<td style="text-align:left;">

MIS-11

</td>

<td style="text-align:right;">

0.8552

</td>

</tr>

<tr>

<td style="text-align:left;">

42

</td>

<td style="text-align:left;">

MIS-5

</td>

<td style="text-align:left;">

MIS-9

</td>

<td style="text-align:right;">

0.8595

</td>

</tr>

<tr>

<td style="text-align:left;">

48

</td>

<td style="text-align:left;">

MIS-6

</td>

<td style="text-align:left;">

MIS-9

</td>

<td style="text-align:right;">

0.8792

</td>

</tr>

<tr>

<td style="text-align:left;">

44

</td>

<td style="text-align:left;">

MIS-5

</td>

<td style="text-align:left;">

MIS-11

</td>

<td style="text-align:right;">

0.9280

</td>

</tr>

<tr>

<td style="text-align:left;">

52

</td>

<td style="text-align:left;">

MIS-7

</td>

<td style="text-align:left;">

MIS-8

</td>

<td style="text-align:right;">

0.9315

</td>

</tr>

<tr>

<td style="text-align:left;">

25

</td>

<td style="text-align:left;">

MIS-3

</td>

<td style="text-align:left;">

MIS-7

</td>

<td style="text-align:right;">

0.9432

</td>

</tr>

<tr>

<td style="text-align:left;">

38

</td>

<td style="text-align:left;">

MIS-4

</td>

<td style="text-align:left;">

MIS-12

</td>

<td style="text-align:right;">

1.0122

</td>

</tr>

<tr>

<td style="text-align:left;">

50

</td>

<td style="text-align:left;">

MIS-6

</td>

<td style="text-align:left;">

MIS-11

</td>

<td style="text-align:right;">

1.0233

</td>

</tr>

<tr>

<td style="text-align:left;">

46

</td>

<td style="text-align:left;">

MIS-6

</td>

<td style="text-align:left;">

MIS-7

</td>

<td style="text-align:right;">

1.0314

</td>

</tr>

<tr>

<td style="text-align:left;">

23

</td>

<td style="text-align:left;">

MIS-3

</td>

<td style="text-align:left;">

MIS-5

</td>

<td style="text-align:right;">

1.0543

</td>

</tr>

<tr>

<td style="text-align:left;">

34

</td>

<td style="text-align:left;">

MIS-4

</td>

<td style="text-align:left;">

MIS-8

</td>

<td style="text-align:right;">

1.0855

</td>

</tr>

<tr>

<td style="text-align:left;">

41

</td>

<td style="text-align:left;">

MIS-5

</td>

<td style="text-align:left;">

MIS-8

</td>

<td style="text-align:right;">

1.1963

</td>

</tr>

<tr>

<td style="text-align:left;">

17

</td>

<td style="text-align:left;">

MIS-2

</td>

<td style="text-align:left;">

MIS-8

</td>

<td style="text-align:right;">

1.1964

</td>

</tr>

<tr>

<td style="text-align:left;">

18

</td>

<td style="text-align:left;">

MIS-2

</td>

<td style="text-align:left;">

MIS-9

</td>

<td style="text-align:right;">

1.3197

</td>

</tr>

<tr>

<td style="text-align:left;">

39

</td>

<td style="text-align:left;">

MIS-5

</td>

<td style="text-align:left;">

MIS-6

</td>

<td style="text-align:right;">

1.3293

</td>

</tr>

<tr>

<td style="text-align:left;">

36

</td>

<td style="text-align:left;">

MIS-4

</td>

<td style="text-align:left;">

MIS-10

</td>

<td style="text-align:right;">

1.4289

</td>

</tr>

<tr>

<td style="text-align:left;">

20

</td>

<td style="text-align:left;">

MIS-2

</td>

<td style="text-align:left;">

MIS-11

</td>

<td style="text-align:right;">

1.4323

</td>

</tr>

<tr>

<td style="text-align:left;">

6

</td>

<td style="text-align:left;">

MIS-1

</td>

<td style="text-align:left;">

MIS-7

</td>

<td style="text-align:right;">

1.5844

</td>

</tr>

<tr>

<td style="text-align:left;">

35

</td>

<td style="text-align:left;">

MIS-4

</td>

<td style="text-align:left;">

MIS-9

</td>

<td style="text-align:right;">

1.6666

</td>

</tr>

<tr>

<td style="text-align:left;">

8

</td>

<td style="text-align:left;">

MIS-1

</td>

<td style="text-align:left;">

MIS-9

</td>

<td style="text-align:right;">

1.7092

</td>

</tr>

<tr>

<td style="text-align:left;">

16

</td>

<td style="text-align:left;">

MIS-2

</td>

<td style="text-align:left;">

MIS-7

</td>

<td style="text-align:right;">

1.7105

</td>

</tr>

<tr>

<td style="text-align:left;">

37

</td>

<td style="text-align:left;">

MIS-4

</td>

<td style="text-align:left;">

MIS-11

</td>

<td style="text-align:right;">

1.8233

</td>

</tr>

<tr>

<td style="text-align:left;">

5

</td>

<td style="text-align:left;">

MIS-1

</td>

<td style="text-align:left;">

MIS-6

</td>

<td style="text-align:right;">

1.8345

</td>

</tr>

<tr>

<td style="text-align:left;">

33

</td>

<td style="text-align:left;">

MIS-4

</td>

<td style="text-align:left;">

MIS-7

</td>

<td style="text-align:right;">

1.8794

</td>

</tr>

<tr>

<td style="text-align:left;">

10

</td>

<td style="text-align:left;">

MIS-1

</td>

<td style="text-align:left;">

MIS-11

</td>

<td style="text-align:right;">

1.8914

</td>

</tr>

<tr>

<td style="text-align:left;">

7

</td>

<td style="text-align:left;">

MIS-1

</td>

<td style="text-align:left;">

MIS-8

</td>

<td style="text-align:right;">

1.9153

</td>

</tr>

<tr>

<td style="text-align:left;">

4

</td>

<td style="text-align:left;">

MIS-1

</td>

<td style="text-align:left;">

MIS-5

</td>

<td style="text-align:right;">

2.0800

</td>

</tr>

<tr>

<td style="text-align:left;">

2

</td>

<td style="text-align:left;">

MIS-1

</td>

<td style="text-align:left;">

MIS-3

</td>

<td style="text-align:right;">

2.1001

</td>

</tr>

<tr>

<td style="text-align:left;">

11

</td>

<td style="text-align:left;">

MIS-1

</td>

<td style="text-align:left;">

MIS-12

</td>

<td style="text-align:right;">

2.1360

</td>

</tr>

<tr>

<td style="text-align:left;">

14

</td>

<td style="text-align:left;">

MIS-2

</td>

<td style="text-align:left;">

MIS-5

</td>

<td style="text-align:right;">

2.1411

</td>

</tr>

<tr>

<td style="text-align:left;">

9

</td>

<td style="text-align:left;">

MIS-1

</td>

<td style="text-align:left;">

MIS-10

</td>

<td style="text-align:right;">

2.2517

</td>

</tr>

<tr>

<td style="text-align:left;">

3

</td>

<td style="text-align:left;">

MIS-1

</td>

<td style="text-align:left;">

MIS-4

</td>

<td style="text-align:right;">

2.3711

</td>

</tr>

<tr>

<td style="text-align:left;">

31

</td>

<td style="text-align:left;">

MIS-4

</td>

<td style="text-align:left;">

MIS-5

</td>

<td style="text-align:right;">

2.6038

</td>

</tr>

<tr>

<td style="text-align:left;">

1

</td>

<td style="text-align:left;">

MIS-1

</td>

<td style="text-align:left;">

MIS-2

</td>

<td style="text-align:right;">

2.6499

</td>

</tr>

</tbody>

</table>

A dataframe like this can be transformed into a matrix to be plotted as
an adjacency network with the **qgraph** package.

``` r
#psi values to matrix
MIS.psi.matrix <- formatPsi(
  psi.values = MIS.psi,
  to = "matrix"
)

#dissimilariy to distance
MIS.distance <- 1/MIS.psi.matrix**4

#plotting network
qgraph::qgraph(MIS.distance, 
       layout='spring', 
       vsize=5,
       labels = colnames(MIS.distance),
       colors = viridis::viridis(2, begin = 0.3, end = 0.8, alpha = 0.5, direction = -1)
       )
```

<img src="man/figures/README-unnamed-chunk-17-1.png" title="Similarity between MIS sequences represented as a network. More similar sites are closer, and linked by a wider edge. Note that glacials are colored in blue and interglacials in green" alt="Similarity between MIS sequences represented as a network. More similar sites are closer, and linked by a wider edge. Note that glacials are colored in blue and interglacials in green" width="100%" />

Or as a matrix with **ggplot2**.

``` r
#ordering factors to get a triangular matrix
MIS.psi$A <- factor(MIS.psi$A, levels=unique(sequencesMIS$MIS))
MIS.psi$B <- factor(MIS.psi$B, levels=unique(sequencesMIS$MIS))

#plotting matrix
ggplot(data=na.omit(MIS.psi), aes(x=A, y=B, size=psi, color=psi)) + 
  geom_point() +
  viridis::scale_color_viridis(direction = -1) +
  guides(size = FALSE)
```

<img src="man/figures/README-unnamed-chunk-18-1.png" title="Dissimilarity between MIS sequences. Darker colors indicate a higher dissimilarity." alt="Dissimilarity between MIS sequences. Darker colors indicate a higher dissimilarity." width="100%" />

The dataframe of dissimilarities between pairs of sequences can be also
used to analyze the drivers of dissimilarity. To do so, attributes such
as differences in time (when sequences represent different times) or
distance (when sequences represent different sites) between sequences,
or differences between physical/climatic attributes between sequences
such as topography or climate can be added to the table, so models such
as ![psi = A + B +
C](https://latex.codecogs.com/png.latex?psi%20%3D%20A%20%2B%20B%20%2B%20C
"psi = A + B + C") (were A, B, and C are these attributes) can be
fitted.

``` r
#cleaning workspace
rm(list = ls())
```

# Comparing regular aligned METS

The package *distantia* is also useful to compare synchronic sequences
that have the same number of samples. In this particular case, distances
to obtain
![AB\_{between}](https://latex.codecogs.com/png.latex?AB_%7Bbetween%7D
"AB_{between}") are computed only between samples with the same
time/depth/order, and no distance matrix (nor least-cost analysis) is
required. When the argument *paired.samples* in **prepareSequences** is
set to TRUE, the function checks if the sequences have the same number
of rows, and, if *time.column* is provided, it selects the samples that
have valid time/depth columns for every sequence in the dataset.

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
  method = "manhattan",
  paired.samples = TRUE, #this bit is important
  same.time = TRUE, #checks time of the samples
  format = "dataframe"
)
kable(climate.psi, digits = 4)
```

<table>

<thead>

<tr>

<th style="text-align:left;">

A

</th>

<th style="text-align:left;">

B

</th>

<th style="text-align:right;">

psi

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

1

</td>

<td style="text-align:left;">

2

</td>

<td style="text-align:right;">

4.3788

</td>

</tr>

<tr>

<td style="text-align:left;">

1

</td>

<td style="text-align:left;">

3

</td>

<td style="text-align:right;">

3.7679

</td>

</tr>

<tr>

<td style="text-align:left;">

1

</td>

<td style="text-align:left;">

4

</td>

<td style="text-align:right;">

5.0435

</td>

</tr>

<tr>

<td style="text-align:left;">

2

</td>

<td style="text-align:left;">

3

</td>

<td style="text-align:right;">

4.7611

</td>

</tr>

<tr>

<td style="text-align:left;">

2

</td>

<td style="text-align:left;">

4

</td>

<td style="text-align:right;">

3.5517

</td>

</tr>

<tr>

<td style="text-align:left;">

3

</td>

<td style="text-align:left;">

4

</td>

<td style="text-align:right;">

4.1698

</td>

</tr>

</tbody>

</table>

``` r
#cleaning workspace
rm(list = ls())
```

# Restricted permutation test to assess the significance of dissimilarity values

One question that may arise when comparing time series is “to what
extent are dissimilarity values a result of chance?”. Answering this
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
      - For each case of each column of A and B, randomly apply one of
        these actions:
          - Leave it as is.
          - Replace it with the previous case.
          - Replace it with the next case.
      - Compute *randomized psi* between A and B and store the value.
  - Add *real psi* to the pool of *randomized psi*.
  - Compute the proportion of *randomized psi* that is equal or lower
    than *real psi*.

Such a proportion represents the probability of obtaining a value lower
than *real psi* by chance.

Since the restricted permutation only happens at a local scale within
each column of each sequence, the probability values returned are **very
conservative** and shouldn’t be interpreted in the same way p-values are
interpreted.

The process described above has been implemented in the
**workflowNullPsi** function. We will apply it to three groups of the
*sequencesMIS* dataset.

``` r
#getting example data
data(sequencesMIS)

#working with 3 groups (to make this fast)
sequencesMIS <- sequencesMIS[sequencesMIS$MIS %in% c("MIS-4", "MIS-5", "MIS-6"),]

#preparing sequences
sequencesMIS <- prepareSequences(
  sequences = sequencesMIS,
  grouping.column = "MIS",
  transformation = "hellinger"
)
```

The computation of the null psi values goes as follows:

``` r
random.psi <- workflowNullPsi(
  sequences = sequencesMIS,
  grouping.column = "MIS",
  method = "euclidean",
  paired.samples = FALSE,
  repetitions = 9 #recommended value: 999
)
```

Note that the number of repetitions has been set to 9 in order to
speed-up execution. The actual number should ideally be 999.

The output is a list with two dataframes, **psi** and **p**.

The dataframe **psi** contains the real and random psi values. The
column *psi* contains the dissimilarity between the sequences in the
columns *A* and *B*. The columns *r1* to *r9* contain the psi values
obtained from permutations of the sequences.

``` r
kable(random.psi$psi, digits = 4)
```

<table>

<thead>

<tr>

<th style="text-align:left;">

A

</th>

<th style="text-align:left;">

B

</th>

<th style="text-align:right;">

psi

</th>

<th style="text-align:right;">

r1

</th>

<th style="text-align:right;">

r2

</th>

<th style="text-align:right;">

r3

</th>

<th style="text-align:right;">

r4

</th>

<th style="text-align:right;">

r5

</th>

<th style="text-align:right;">

r6

</th>

<th style="text-align:right;">

r7

</th>

<th style="text-align:right;">

r8

</th>

<th style="text-align:right;">

r9

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

MIS-4

</td>

<td style="text-align:left;">

MIS-5

</td>

<td style="text-align:right;">

2.6038

</td>

<td style="text-align:right;">

2.9827

</td>

<td style="text-align:right;">

0.8791

</td>

<td style="text-align:right;">

1.6974

</td>

<td style="text-align:right;">

3.1546

</td>

<td style="text-align:right;">

1.0251

</td>

<td style="text-align:right;">

1.7565

</td>

<td style="text-align:right;">

3.1783

</td>

<td style="text-align:right;">

0.8153

</td>

<td style="text-align:right;">

1.6238

</td>

</tr>

<tr>

<td style="text-align:left;">

MIS-4

</td>

<td style="text-align:left;">

MIS-6

</td>

<td style="text-align:right;">

0.6479

</td>

<td style="text-align:right;">

3.0132

</td>

<td style="text-align:right;">

0.9105

</td>

<td style="text-align:right;">

1.6063

</td>

<td style="text-align:right;">

3.0645

</td>

<td style="text-align:right;">

0.9529

</td>

<td style="text-align:right;">

1.6198

</td>

<td style="text-align:right;">

2.8848

</td>

<td style="text-align:right;">

0.8745

</td>

<td style="text-align:right;">

1.5570

</td>

</tr>

<tr>

<td style="text-align:left;">

MIS-5

</td>

<td style="text-align:left;">

MIS-6

</td>

<td style="text-align:right;">

1.3293

</td>

<td style="text-align:right;">

2.8559

</td>

<td style="text-align:right;">

1.0097

</td>

<td style="text-align:right;">

1.7238

</td>

<td style="text-align:right;">

3.3189

</td>

<td style="text-align:right;">

0.9323

</td>

<td style="text-align:right;">

2.0051

</td>

<td style="text-align:right;">

3.0321

</td>

<td style="text-align:right;">

0.7924

</td>

<td style="text-align:right;">

1.6838

</td>

</tr>

</tbody>

</table>

The dataframe *p* contains the probability of obtaining the real *psi*
value by chance for each combination of sequences.

``` r
kable(random.psi$p)
```

<table>

<thead>

<tr>

<th style="text-align:left;">

A

</th>

<th style="text-align:left;">

B

</th>

<th style="text-align:right;">

p

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

MIS-4

</td>

<td style="text-align:left;">

MIS-5

</td>

<td style="text-align:right;">

0.7

</td>

</tr>

<tr>

<td style="text-align:left;">

MIS-4

</td>

<td style="text-align:left;">

MIS-6

</td>

<td style="text-align:right;">

0.1

</td>

</tr>

<tr>

<td style="text-align:left;">

MIS-5

</td>

<td style="text-align:left;">

MIS-6

</td>

<td style="text-align:right;">

0.4

</td>

</tr>

</tbody>

</table>

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

First, we prepare the data. It is again *sequencesMIS*, but with only
three groups selected (MIS 4 to 6) to simplify the analysis.

``` r
#getting example data
data(sequencesMIS)

#getting three groups only to simplify
sequencesMIS <- sequencesMIS[sequencesMIS$MIS %in% c("MIS-4", "MIS-5", "MIS-6"),]

#preparing sequences
sequences <- prepareSequences(
  sequences = sequencesMIS,
  grouping.column = "MIS",
  time.column = NULL,
  merge.mode = "complete",
  exclude.columns = NULL
)
```

The workflow function is pretty similar to the ones explained above.
However, unlike the other functions in the package, that parallelize
across the comparison of pairs of sequences, this one parallelizes the
computation of *psi* on combinations of columns, removing one column
each time.

**WARNING: the argument ‘exclude.columns’ of ‘workflowImportance’ does
not work in version 1.0.0 (available in CRAN), but the bug is fixed in
version 1.0.1 (available in GitHub). If you are using 1.0.0, I recommend
you to subset ‘sequences’ so only the grouping column and the numeric
columns to be compared are available for the function.**

``` r
psi.importance <- workflowImportance(
  sequences = sequencesMIS,
  grouping.column = "MIS",
  time.column = NULL,
  exclude.columns = NULL,
  method = "manhattan",
  diagonal = FALSE,
  parallel.execution = TRUE,
  paired.samples = FALSE
  )
```

The output is a list with two slots named *psi* and *psi.drop*.

The dataframe **psi** contains psi values for each combination of
variables (named in the coluns *A* and *B*) computed for all columns in
the column *All variables*, and one column per variable named *Without
variable\_name* containing the psi value when that variable is removed
from the compared sequences.

``` r
kable(psi.importance$psi, digits = 4)
```

<table>

<thead>

<tr>

<th style="text-align:left;">

A

</th>

<th style="text-align:left;">

B

</th>

<th style="text-align:right;">

All variables

</th>

<th style="text-align:right;">

Without Carpinus

</th>

<th style="text-align:right;">

Without Tilia

</th>

<th style="text-align:right;">

Without Alnus

</th>

<th style="text-align:right;">

Without Pinus

</th>

<th style="text-align:right;">

Without Betula

</th>

<th style="text-align:right;">

Without Quercus

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

MIS-4

</td>

<td style="text-align:left;">

MIS-5

</td>

<td style="text-align:right;">

2.1933

</td>

<td style="text-align:right;">

2.2094

</td>

<td style="text-align:right;">

2.2095

</td>

<td style="text-align:right;">

2.2627

</td>

<td style="text-align:right;">

2.8821

</td>

<td style="text-align:right;">

2.2340

</td>

<td style="text-align:right;">

0.8940

</td>

</tr>

<tr>

<td style="text-align:left;">

MIS-4

</td>

<td style="text-align:left;">

MIS-6

</td>

<td style="text-align:right;">

0.7012

</td>

<td style="text-align:right;">

0.6937

</td>

<td style="text-align:right;">

0.7007

</td>

<td style="text-align:right;">

0.6878

</td>

<td style="text-align:right;">

0.7158

</td>

<td style="text-align:right;">

0.6902

</td>

<td style="text-align:right;">

0.5883

</td>

</tr>

<tr>

<td style="text-align:left;">

MIS-5

</td>

<td style="text-align:left;">

MIS-6

</td>

<td style="text-align:right;">

1.4473

</td>

<td style="text-align:right;">

1.4393

</td>

<td style="text-align:right;">

1.4563

</td>

<td style="text-align:right;">

1.4706

</td>

<td style="text-align:right;">

1.7039

</td>

<td style="text-align:right;">

1.4866

</td>

<td style="text-align:right;">

0.7359

</td>

</tr>

</tbody>

</table>

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
  labs(fill = "Psi")
```

<img src="man/figures/README-unnamed-chunk-31-1.png" title="Variable importance analysis of three combinations of sequences. The plot suggest that MIS-4 and MIS-6 are more similar (both are glacial periods), and that the column Quercus is the one with a higher contribution to dissimilarity between sequences." alt="Variable importance analysis of three combinations of sequences. The plot suggest that MIS-4 and MIS-6 are more similar (both are glacial periods), and that the column Quercus is the one with a higher contribution to dissimilarity between sequences." width="100%" />

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

<!-- end list -->

``` r
kable(psi.importance$psi.drop)
```

<table>

<thead>

<tr>

<th style="text-align:left;">

A

</th>

<th style="text-align:left;">

B

</th>

<th style="text-align:right;">

Carpinus

</th>

<th style="text-align:right;">

Tilia

</th>

<th style="text-align:right;">

Alnus

</th>

<th style="text-align:right;">

Pinus

</th>

<th style="text-align:right;">

Betula

</th>

<th style="text-align:right;">

Quercus

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

MIS-4

</td>

<td style="text-align:left;">

MIS-5

</td>

<td style="text-align:right;">

\-0.73

</td>

<td style="text-align:right;">

\-0.74

</td>

<td style="text-align:right;">

\-3.16

</td>

<td style="text-align:right;">

\-31.40

</td>

<td style="text-align:right;">

\-1.85

</td>

<td style="text-align:right;">

59.24

</td>

</tr>

<tr>

<td style="text-align:left;">

MIS-4

</td>

<td style="text-align:left;">

MIS-6

</td>

<td style="text-align:right;">

1.07

</td>

<td style="text-align:right;">

0.08

</td>

<td style="text-align:right;">

1.91

</td>

<td style="text-align:right;">

\-2.09

</td>

<td style="text-align:right;">

1.57

</td>

<td style="text-align:right;">

16.10

</td>

</tr>

<tr>

<td style="text-align:left;">

MIS-5

</td>

<td style="text-align:left;">

MIS-6

</td>

<td style="text-align:right;">

0.56

</td>

<td style="text-align:right;">

\-0.62

</td>

<td style="text-align:right;">

\-1.61

</td>

<td style="text-align:right;">

\-17.73

</td>

<td style="text-align:right;">

\-2.71

</td>

<td style="text-align:right;">

49.15

</td>

</tr>

</tbody>

</table>

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
  facet_wrap("name") +
  scale_fill_viridis() +
  ggtitle("Drop in dissimilarity when variables are removed.") +
  ylab("Drop in dissimilarity (%)") +
  labs(fill = "Psi drop (%)")
```

<img src="man/figures/README-unnamed-chunk-33-1.png" title="Drop in psi values, represented as percentage, when a variable is removed from the analysis. Negative values indicate a contribution to similarity, while positive values indicate a contribution to dissimilarity. The plot suggest that Quercus is the variable with a higher contribution to dissimilarity, while Pinus has the higher contribution to similarity." alt="Drop in psi values, represented as percentage, when a variable is removed from the analysis. Negative values indicate a contribution to similarity, while positive values indicate a contribution to dissimilarity. The plot suggest that Quercus is the variable with a higher contribution to dissimilarity, while Pinus has the higher contribution to similarity." width="100%" />

``` r
#cleaning workspace
rm(list = ls())
```

# Partial matching: finding the section in a long sequence more similar to a given short sequence

In this scenario the user has one short and one long sequence, and the
goal is to find the section in the long sequence that better matches the
short one. To recreate this scenario we use the dataset *sequencesMIS*.
The first 10 samples will serve as short sequence, and the first 40
samples as long sequence. These small subsets are selected to speed-up
the execution time of this example.

``` r
#loading the data
data(sequencesMIS)

#removing grouping column
sequencesMIS$MIS <- NULL

#subsetting to get the short sequence
MIS.short <- sequencesMIS[1:10, ]

#subsetting to get the long sequence
MIS.long <- sequencesMIS[1:40, ]
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
  paired.samples = FALSE,
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
kable(MIS.psi[1:15, ], digits = 4)
```

<table>

<thead>

<tr>

<th style="text-align:right;">

first.row

</th>

<th style="text-align:right;">

last.row

</th>

<th style="text-align:right;">

psi

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

10

</td>

<td style="text-align:right;">

0.0000

</td>

</tr>

<tr>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

11

</td>

<td style="text-align:right;">

0.0988

</td>

</tr>

<tr>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

12

</td>

<td style="text-align:right;">

0.1394

</td>

</tr>

<tr>

<td style="text-align:right;">

4

</td>

<td style="text-align:right;">

13

</td>

<td style="text-align:right;">

0.1412

</td>

</tr>

<tr>

<td style="text-align:right;">

5

</td>

<td style="text-align:right;">

14

</td>

<td style="text-align:right;">

0.3108

</td>

</tr>

<tr>

<td style="text-align:right;">

6

</td>

<td style="text-align:right;">

15

</td>

<td style="text-align:right;">

0.6959

</td>

</tr>

<tr>

<td style="text-align:right;">

7

</td>

<td style="text-align:right;">

16

</td>

<td style="text-align:right;">

0.8607

</td>

</tr>

<tr>

<td style="text-align:right;">

8

</td>

<td style="text-align:right;">

17

</td>

<td style="text-align:right;">

0.9114

</td>

</tr>

<tr>

<td style="text-align:right;">

10

</td>

<td style="text-align:right;">

19

</td>

<td style="text-align:right;">

0.9415

</td>

</tr>

<tr>

<td style="text-align:right;">

9

</td>

<td style="text-align:right;">

18

</td>

<td style="text-align:right;">

1.0264

</td>

</tr>

<tr>

<td style="text-align:right;">

11

</td>

<td style="text-align:right;">

20

</td>

<td style="text-align:right;">

1.1342

</td>

</tr>

<tr>

<td style="text-align:right;">

13

</td>

<td style="text-align:right;">

22

</td>

<td style="text-align:right;">

1.1877

</td>

</tr>

<tr>

<td style="text-align:right;">

12

</td>

<td style="text-align:right;">

21

</td>

<td style="text-align:right;">

1.2179

</td>

</tr>

<tr>

<td style="text-align:right;">

17

</td>

<td style="text-align:right;">

26

</td>

<td style="text-align:right;">

1.2744

</td>

</tr>

<tr>

<td style="text-align:right;">

15

</td>

<td style="text-align:right;">

24

</td>

<td style="text-align:right;">

1.2869

</td>

</tr>

</tbody>

</table>

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
path.

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

<img src="man/figures/README-unnamed-chunk-42-1.png" title="Distance matrix and least-cost path of the example sequences 'A' and 'B'.." alt="Distance matrix and least-cost path of the example sequences 'A' and 'B'.." width="100%" />

The function reads the least-cost path in order to find the combination
of samples of both sequences that minimizes dissimilarity, constrained
by the order of the samples on each sequence. The output dataframe has a
column named *original.index*, which has the index of each sample in the
original datasets.

``` r
kable(AB.combined[1:15,1:10], format = "html", digits = 4)
```

<table>

<thead>

<tr>

<th style="text-align:left;">

</th>

<th style="text-align:left;">

id

</th>

<th style="text-align:right;">

original.index

</th>

<th style="text-align:right;">

depth

</th>

<th style="text-align:right;">

age

</th>

<th style="text-align:right;">

Abies

</th>

<th style="text-align:right;">

Juniperus

</th>

<th style="text-align:right;">

Hedera

</th>

<th style="text-align:right;">

Plantago

</th>

<th style="text-align:right;">

Boraginaceae

</th>

<th style="text-align:right;">

Crassulaceae

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

1

</td>

<td style="text-align:left;">

A

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

3.97

</td>

<td style="text-align:right;">

11243

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

5

</td>

<td style="text-align:right;">

12

</td>

<td style="text-align:right;">

21

</td>

<td style="text-align:right;">

95

</td>

</tr>

<tr>

<td style="text-align:left;">

11

</td>

<td style="text-align:left;">

B

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

3.92

</td>

<td style="text-align:right;">

11108

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

7

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

5

</td>

<td style="text-align:right;">

20

</td>

</tr>

<tr>

<td style="text-align:left;">

12

</td>

<td style="text-align:left;">

B

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

3.95

</td>

<td style="text-align:right;">

11189

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

15

</td>

<td style="text-align:right;">

47

</td>

</tr>

<tr>

<td style="text-align:left;">

13

</td>

<td style="text-align:left;">

B

</td>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

4

</td>

<td style="text-align:right;">

4.00

</td>

<td style="text-align:right;">

11324

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

8

</td>

<td style="text-align:right;">

43

</td>

<td style="text-align:right;">

60

</td>

<td style="text-align:right;">

65

</td>

</tr>

<tr>

<td style="text-align:left;">

2

</td>

<td style="text-align:left;">

A

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

6

</td>

<td style="text-align:right;">

4.05

</td>

<td style="text-align:right;">

11459

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

20

</td>

<td style="text-align:right;">

73

</td>

<td style="text-align:right;">

94

</td>

<td style="text-align:right;">

1

</td>

</tr>

<tr>

<td style="text-align:left;">

14

</td>

<td style="text-align:left;">

B

</td>

<td style="text-align:right;">

4

</td>

<td style="text-align:right;">

5

</td>

<td style="text-align:right;">

4.02

</td>

<td style="text-align:right;">

11378

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

44

</td>

<td style="text-align:right;">

76

</td>

<td style="text-align:right;">

110

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;">

3

</td>

<td style="text-align:left;">

A

</td>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

7

</td>

<td style="text-align:right;">

4.07

</td>

<td style="text-align:right;">

11514

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

20

</td>

<td style="text-align:right;">

80

</td>

<td style="text-align:right;">

100

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;">

4

</td>

<td style="text-align:left;">

A

</td>

<td style="text-align:right;">

4

</td>

<td style="text-align:right;">

8

</td>

<td style="text-align:right;">

4.10

</td>

<td style="text-align:right;">

11595

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

34

</td>

<td style="text-align:right;">

80

</td>

<td style="text-align:right;">

155

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;">

5

</td>

<td style="text-align:left;">

A

</td>

<td style="text-align:right;">

5

</td>

<td style="text-align:right;">

9

</td>

<td style="text-align:right;">

4.17

</td>

<td style="text-align:right;">

11784

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

22

</td>

<td style="text-align:right;">

44

</td>

<td style="text-align:right;">

131

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;">

15

</td>

<td style="text-align:left;">

B

</td>

<td style="text-align:right;">

5

</td>

<td style="text-align:right;">

13

</td>

<td style="text-align:right;">

4.27

</td>

<td style="text-align:right;">

12054

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

37

</td>

<td style="text-align:right;">

30

</td>

<td style="text-align:right;">

150

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;">

6

</td>

<td style="text-align:left;">

A

</td>

<td style="text-align:right;">

6

</td>

<td style="text-align:right;">

10

</td>

<td style="text-align:right;">

4.20

</td>

<td style="text-align:right;">

11865

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

35

</td>

<td style="text-align:right;">

30

</td>

<td style="text-align:right;">

112

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;">

7

</td>

<td style="text-align:left;">

A

</td>

<td style="text-align:right;">

7

</td>

<td style="text-align:right;">

11

</td>

<td style="text-align:right;">

4.22

</td>

<td style="text-align:right;">

11919

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

30

</td>

<td style="text-align:right;">

45

</td>

<td style="text-align:right;">

150

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;">

8

</td>

<td style="text-align:left;">

A

</td>

<td style="text-align:right;">

8

</td>

<td style="text-align:right;">

12

</td>

<td style="text-align:right;">

4.25

</td>

<td style="text-align:right;">

12000

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

44

</td>

<td style="text-align:right;">

35

</td>

<td style="text-align:right;">

150

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;">

9

</td>

<td style="text-align:left;">

A

</td>

<td style="text-align:right;">

9

</td>

<td style="text-align:right;">

15

</td>

<td style="text-align:right;">

4.32

</td>

<td style="text-align:right;">

12189

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

43

</td>

<td style="text-align:right;">

17

</td>

<td style="text-align:right;">

120

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;">

16

</td>

<td style="text-align:left;">

B

</td>

<td style="text-align:right;">

6

</td>

<td style="text-align:right;">

14

</td>

<td style="text-align:right;">

4.30

</td>

<td style="text-align:right;">

12135

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

50

</td>

<td style="text-align:right;">

10

</td>

<td style="text-align:right;">

120

</td>

<td style="text-align:right;">

0

</td>

</tr>

</tbody>

</table>

Note that several samples (highlighted in bold) show inverted ages with
respect to the previous samples. This is expected, since the slotting
algorithm only takes into account distance/dissimilarity between
adjacent samples to generate the
ordering.

<img src="man/figures/README-unnamed-chunk-44-1.png" title="Sequences A (green) and B (blue) with their ordered samples (upper panel), and the composite sequence resulting from them (lower panel) after applying the sequence slotting algorithm. Notice that the slotting takes into account all columns in both datasets, and therefore, a single column, as shown in the plot, might not be totally representative of the slotting solution." alt="Sequences A (green) and B (blue) with their ordered samples (upper panel), and the composite sequence resulting from them (lower panel) after applying the sequence slotting algorithm. Notice that the slotting takes into account all columns in both datasets, and therefore, a single column, as shown in the plot, might not be totally representative of the slotting solution." width="100%" />

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

  - **Direct**: each sample in *X* gets the age of its most similar
    sample in *GP*.
  - **Interpolated**: each sample in *X* gets an age interpolated from
    the ages of the two most similar samples in *GP*. The interpolation
    is weighted by the similarity between the samples.

## Direct transfer

A direct transfer of an attribute from the samples of one sequence to
the samples of another requires to compute a distance matrix between
samples, the least-cost matrix and its least-cost path (both with the
option *diagonal* activated), and to parse the least-cost path file to
assign attribute values. This is done by the function
**workflowTransfer** with the option ![mode =
"direct"](https://latex.codecogs.com/png.latex?mode%20%3D%20%22direct%22
"mode = \"direct\"").

``` r
#parameters
X.new <- workflowTransfer(
  sequences = GP.X,
  grouping.column = "id",
  time.column = "age",
  method = "manhattan",
  transfer.what = "age",
  transfer.from = "GP",
  transfer.to = "X",
  mode = "direct"
  )

kable(X.new[1:15, ], digits = 4)
```

<table>

<thead>

<tr>

<th style="text-align:left;">

</th>

<th style="text-align:left;">

id

</th>

<th style="text-align:right;">

depth

</th>

<th style="text-align:right;">

age

</th>

<th style="text-align:right;">

Abies

</th>

<th style="text-align:right;">

Juniperus

</th>

<th style="text-align:right;">

Hedera

</th>

<th style="text-align:right;">

Plantago

</th>

<th style="text-align:right;">

Boraginaceae

</th>

<th style="text-align:right;">

Crassulaceae

</th>

<th style="text-align:right;">

Pinus

</th>

<th style="text-align:right;">

Ranunculaceae

</th>

<th style="text-align:right;">

Rhamnus

</th>

<th style="text-align:right;">

Caryophyllaceae

</th>

<th style="text-align:right;">

Dipsacaceae

</th>

<th style="text-align:right;">

Betula

</th>

<th style="text-align:right;">

Acer

</th>

<th style="text-align:right;">

Armeria

</th>

<th style="text-align:right;">

Tilia

</th>

<th style="text-align:right;">

Hippophae

</th>

<th style="text-align:right;">

Salix

</th>

<th style="text-align:right;">

Thalictrum

</th>

<th style="text-align:right;">

Labiatae

</th>

<th style="text-align:right;">

Valeriana

</th>

<th style="text-align:right;">

Nymphaea

</th>

<th style="text-align:right;">

Umbelliferae

</th>

<th style="text-align:right;">

Sanguisorba\_minor

</th>

<th style="text-align:right;">

Plantago.lanceolata

</th>

<th style="text-align:right;">

Campanulaceae

</th>

<th style="text-align:right;">

Asteroideae

</th>

<th style="text-align:right;">

Gentiana

</th>

<th style="text-align:right;">

Fraxinus

</th>

<th style="text-align:right;">

Cichorioideae

</th>

<th style="text-align:right;">

Taxus

</th>

<th style="text-align:right;">

Rumex

</th>

<th style="text-align:right;">

Cedrus

</th>

<th style="text-align:right;">

Ranunculus.subgen..Batrachium

</th>

<th style="text-align:right;">

Cyperaceae

</th>

<th style="text-align:right;">

Corylus

</th>

<th style="text-align:right;">

Myriophyllum

</th>

<th style="text-align:right;">

Filipendula

</th>

<th style="text-align:right;">

Vitis

</th>

<th style="text-align:right;">

Rubiaceae

</th>

<th style="text-align:right;">

Polypodium

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

41

</td>

<td style="text-align:left;">

X

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

3.92

</td>

<td style="text-align:right;">

11108

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

7

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

5

</td>

<td style="text-align:right;">

20

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

13

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

41

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

8

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

60

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;">

42

</td>

<td style="text-align:left;">

X

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

4.00

</td>

<td style="text-align:right;">

11324

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

8

</td>

<td style="text-align:right;">

43

</td>

<td style="text-align:right;">

60

</td>

<td style="text-align:right;">

65

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

10

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

4

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

4

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

11

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;">

43

</td>

<td style="text-align:left;">

X

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

4.02

</td>

<td style="text-align:right;">

11378

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

44

</td>

<td style="text-align:right;">

76

</td>

<td style="text-align:right;">

110

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

11

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

5

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

6

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

1

</td>

</tr>

<tr>

<td style="text-align:left;">

44

</td>

<td style="text-align:left;">

X

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

4.05

</td>

<td style="text-align:right;">

11459

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

20

</td>

<td style="text-align:right;">

73

</td>

<td style="text-align:right;">

94

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

10

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;">

45

</td>

<td style="text-align:left;">

X

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

4.07

</td>

<td style="text-align:right;">

11514

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

20

</td>

<td style="text-align:right;">

80

</td>

<td style="text-align:right;">

100

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

10

</td>

<td style="text-align:right;">

4

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

8

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;">

46

</td>

<td style="text-align:left;">

X

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

4.07

</td>

<td style="text-align:right;">

11595

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

34

</td>

<td style="text-align:right;">

80

</td>

<td style="text-align:right;">

155

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

13

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

6

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;">

47

</td>

<td style="text-align:left;">

X

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

4.17

</td>

<td style="text-align:right;">

11784

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

22

</td>

<td style="text-align:right;">

44

</td>

<td style="text-align:right;">

131

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

13

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

5

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

5

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

6

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;">

48

</td>

<td style="text-align:left;">

X

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

4.20

</td>

<td style="text-align:right;">

11865

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

35

</td>

<td style="text-align:right;">

30

</td>

<td style="text-align:right;">

112

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

4

</td>

<td style="text-align:right;">

8

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

7

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

10

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;">

49

</td>

<td style="text-align:left;">

X

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

4.22

</td>

<td style="text-align:right;">

11919

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

30

</td>

<td style="text-align:right;">

45

</td>

<td style="text-align:right;">

150

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

4

</td>

<td style="text-align:right;">

11

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

13

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;">

50

</td>

<td style="text-align:left;">

X

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

4.25

</td>

<td style="text-align:right;">

12000

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

44

</td>

<td style="text-align:right;">

35

</td>

<td style="text-align:right;">

150

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

8

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

5

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

6

</td>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;">

51

</td>

<td style="text-align:left;">

X

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

4.25

</td>

<td style="text-align:right;">

12054

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

37

</td>

<td style="text-align:right;">

30

</td>

<td style="text-align:right;">

150

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

6

</td>

<td style="text-align:right;">

10

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

7

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

6

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

7

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

4

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;">

52

</td>

<td style="text-align:left;">

X

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

4.32

</td>

<td style="text-align:right;">

12135

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

50

</td>

<td style="text-align:right;">

10

</td>

<td style="text-align:right;">

120

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

7

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

8

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

8

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;">

53

</td>

<td style="text-align:left;">

X

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

4.32

</td>

<td style="text-align:right;">

12189

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

43

</td>

<td style="text-align:right;">

17

</td>

<td style="text-align:right;">

120

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

15

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

5

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

6

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;">

54

</td>

<td style="text-align:left;">

X

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

4.40

</td>

<td style="text-align:right;">

12324

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

50

</td>

<td style="text-align:right;">

11

</td>

<td style="text-align:right;">

86

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

15

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

4

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

5

</td>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

6

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

5

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;">

55

</td>

<td style="text-align:left;">

X

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

4.40

</td>

<td style="text-align:right;">

12405

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

51

</td>

<td style="text-align:right;">

6

</td>

<td style="text-align:right;">

70

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

16

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

4

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

4

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

5

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

1

</td>

</tr>

</tbody>

</table>

The algorithm finds the most similar samples, and transfers attribute
values directly between them. This can result in duplicated attribute
values, as highlighted in the table above. The Pearson correlation
between the original ages (stored in *pollenX.age*) and the assigned
ones is 0.9996, so it can be concluded that in spite of its simplicity,
this algorithm yields accurate results.

## Interpolated transfer

If we consider:

  - Two samples ![A\_{i}](https://latex.codecogs.com/png.latex?A_%7Bi%7D
    "A_{i}") and
    ![A\_{j}](https://latex.codecogs.com/png.latex?A_%7Bj%7D "A_{j}") of
    the sequence ![A](https://latex.codecogs.com/png.latex?A "A").
  - Each one with a value the attribute
    ![t](https://latex.codecogs.com/png.latex?t "t"),
    ![At\_{i}](https://latex.codecogs.com/png.latex?At_%7Bi%7D "At_{i}")
    and ![At\_{j}](https://latex.codecogs.com/png.latex?At_%7Bj%7D
    "At_{j}").
  - One sample ![B\_{k}](https://latex.codecogs.com/png.latex?B_%7Bk%7D
    "B_{k}") of the sequence ![B](https://latex.codecogs.com/png.latex?B
    "B").
  - With an **unknown attribute**
    ![Bt\_{k}](https://latex.codecogs.com/png.latex?Bt_%7Bk%7D
    "Bt_{k}").
  - The multivariate distance
    ![D\_{B\_{k}A\_{i}}](https://latex.codecogs.com/png.latex?D_%7BB_%7Bk%7DA_%7Bi%7D%7D
    "D_{B_{k}A_{i}}") between the samples
    ![A\_{i}](https://latex.codecogs.com/png.latex?A_%7Bi%7D "A_{i}")
    and ![B\_{k}](https://latex.codecogs.com/png.latex?B_%7Bk%7D
    "B_{k}").
  - The multivariate distance
    ![D\_{B\_{k}A\_{j}}](https://latex.codecogs.com/png.latex?D_%7BB_%7Bk%7DA_%7Bj%7D%7D
    "D_{B_{k}A_{j}}") between the samples
    ![A\_{j}](https://latex.codecogs.com/png.latex?A_%7Bj%7D "A_{j}")
    and ![B\_{k}](https://latex.codecogs.com/png.latex?B_%7Bk%7D
    "B_{k}").
  - The weight ![w\_{i}](https://latex.codecogs.com/png.latex?w_%7Bi%7D
    "w_{i}"), computed as ![D\_{B\_{k}A\_{i}} / (D\_{B\_{k}A\_{i}} +
    D\_{B\_{k}A\_{j}})](https://latex.codecogs.com/png.latex?D_%7BB_%7Bk%7DA_%7Bi%7D%7D%20%2F%20%28D_%7BB_%7Bk%7DA_%7Bi%7D%7D%20%2B%20D_%7BB_%7Bk%7DA_%7Bj%7D%7D%29
    "D_{B_{k}A_{i}} / (D_{B_{k}A_{i}} + D_{B_{k}A_{j}})")
  - The weight ![w\_{j}](https://latex.codecogs.com/png.latex?w_%7Bj%7D
    "w_{j}"), computed as ![D\_{B\_{k}A\_{j}} / (D\_{B\_{k}A\_{i}} +
    D\_{B\_{k}A\_{j}})](https://latex.codecogs.com/png.latex?D_%7BB_%7Bk%7DA_%7Bj%7D%7D%20%2F%20%28D_%7BB_%7Bk%7DA_%7Bi%7D%7D%20%2B%20D_%7BB_%7Bk%7DA_%7Bj%7D%7D%29
    "D_{B_{k}A_{j}} / (D_{B_{k}A_{i}} + D_{B_{k}A_{j}})")

The unknwon value
![Bt\_{k}](https://latex.codecogs.com/png.latex?Bt_%7Bk%7D "Bt_{k}") is
computed as:

  
![Bt\_{k} = w\_{i} \\times At\_{i} + w\_{j} \\times
At\_{j}](https://latex.codecogs.com/png.latex?Bt_%7Bk%7D%20%3D%20w_%7Bi%7D%20%5Ctimes%20At_%7Bi%7D%20%2B%20w_%7Bj%7D%20%5Ctimes%20At_%7Bj%7D
"Bt_{k} = w_{i} \\times At_{i} + w_{j} \\times At_{j}")  

The code below exemplifies the operation, using the samples 1 and 4 of
the dataset *pollenGP* as ![Ai](https://latex.codecogs.com/png.latex?Ai
"Ai") and ![Aj](https://latex.codecogs.com/png.latex?Aj "Aj"), and the
sample 3 as ![Bk](https://latex.codecogs.com/png.latex?Bk "Bk").

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
kable(t(temp.df), digits = 4)
```

<table>

<tbody>

<tr>

<td style="text-align:left;">

Observed

</td>

<td style="text-align:right;">

3.9700

</td>

</tr>

<tr>

<td style="text-align:left;">

Predicted

</td>

<td style="text-align:right;">

3.9735

</td>

</tr>

</tbody>

</table>

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
  method = "manhattan",
  transfer.what = "age",
  transfer.from = "GP",
  transfer.to = "X",
  mode = "interpolated"
  )

kable(X.new[1:15, ], digits = 4)  %>% 
  row_spec(c(8, 13), bold = T)
```

<table>

<thead>

<tr>

<th style="text-align:left;">

</th>

<th style="text-align:left;">

id

</th>

<th style="text-align:right;">

depth

</th>

<th style="text-align:right;">

age

</th>

<th style="text-align:right;">

Abies

</th>

<th style="text-align:right;">

Juniperus

</th>

<th style="text-align:right;">

Hedera

</th>

<th style="text-align:right;">

Plantago

</th>

<th style="text-align:right;">

Boraginaceae

</th>

<th style="text-align:right;">

Crassulaceae

</th>

<th style="text-align:right;">

Pinus

</th>

<th style="text-align:right;">

Ranunculaceae

</th>

<th style="text-align:right;">

Rhamnus

</th>

<th style="text-align:right;">

Caryophyllaceae

</th>

<th style="text-align:right;">

Dipsacaceae

</th>

<th style="text-align:right;">

Betula

</th>

<th style="text-align:right;">

Acer

</th>

<th style="text-align:right;">

Armeria

</th>

<th style="text-align:right;">

Tilia

</th>

<th style="text-align:right;">

Hippophae

</th>

<th style="text-align:right;">

Salix

</th>

<th style="text-align:right;">

Thalictrum

</th>

<th style="text-align:right;">

Labiatae

</th>

<th style="text-align:right;">

Valeriana

</th>

<th style="text-align:right;">

Nymphaea

</th>

<th style="text-align:right;">

Umbelliferae

</th>

<th style="text-align:right;">

Sanguisorba\_minor

</th>

<th style="text-align:right;">

Plantago.lanceolata

</th>

<th style="text-align:right;">

Campanulaceae

</th>

<th style="text-align:right;">

Asteroideae

</th>

<th style="text-align:right;">

Gentiana

</th>

<th style="text-align:right;">

Fraxinus

</th>

<th style="text-align:right;">

Cichorioideae

</th>

<th style="text-align:right;">

Taxus

</th>

<th style="text-align:right;">

Rumex

</th>

<th style="text-align:right;">

Cedrus

</th>

<th style="text-align:right;">

Ranunculus.subgen..Batrachium

</th>

<th style="text-align:right;">

Cyperaceae

</th>

<th style="text-align:right;">

Corylus

</th>

<th style="text-align:right;">

Myriophyllum

</th>

<th style="text-align:right;">

Filipendula

</th>

<th style="text-align:right;">

Vitis

</th>

<th style="text-align:right;">

Rubiaceae

</th>

<th style="text-align:right;">

Polypodium

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

41

</td>

<td style="text-align:left;">

X

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

3.9498

</td>

<td style="text-align:right;">

11108

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

7

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

5

</td>

<td style="text-align:right;">

20

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

13

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

41

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

8

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

60

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;">

42

</td>

<td style="text-align:left;">

X

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

3.9705

</td>

<td style="text-align:right;">

11324

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

8

</td>

<td style="text-align:right;">

43

</td>

<td style="text-align:right;">

60

</td>

<td style="text-align:right;">

65

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

10

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

4

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

4

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

11

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;">

43

</td>

<td style="text-align:left;">

X

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

4.0003

</td>

<td style="text-align:right;">

11378

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

44

</td>

<td style="text-align:right;">

76

</td>

<td style="text-align:right;">

110

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

11

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

5

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

6

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

1

</td>

</tr>

<tr>

<td style="text-align:left;">

44

</td>

<td style="text-align:left;">

X

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

4.0212

</td>

<td style="text-align:right;">

11459

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

20

</td>

<td style="text-align:right;">

73

</td>

<td style="text-align:right;">

94

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

10

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;">

45

</td>

<td style="text-align:left;">

X

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

4.0512

</td>

<td style="text-align:right;">

11514

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

20

</td>

<td style="text-align:right;">

80

</td>

<td style="text-align:right;">

100

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

10

</td>

<td style="text-align:right;">

4

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

8

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;">

46

</td>

<td style="text-align:left;">

X

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

4.1308

</td>

<td style="text-align:right;">

11595

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

34

</td>

<td style="text-align:right;">

80

</td>

<td style="text-align:right;">

155

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

13

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

6

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;">

47

</td>

<td style="text-align:left;">

X

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

4.1985

</td>

<td style="text-align:right;">

11784

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

22

</td>

<td style="text-align:right;">

44

</td>

<td style="text-align:right;">

131

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

13

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

5

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

5

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

6

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;font-weight: bold;">

48

</td>

<td style="text-align:left;font-weight: bold;">

X

</td>

<td style="text-align:right;font-weight: bold;">

0

</td>

<td style="text-align:right;font-weight: bold;">

NA

</td>

<td style="text-align:right;font-weight: bold;">

11865

</td>

<td style="text-align:right;font-weight: bold;">

0

</td>

<td style="text-align:right;font-weight: bold;">

35

</td>

<td style="text-align:right;font-weight: bold;">

30

</td>

<td style="text-align:right;font-weight: bold;">

112

</td>

<td style="text-align:right;font-weight: bold;">

0

</td>

<td style="text-align:right;font-weight: bold;">

0

</td>

<td style="text-align:right;font-weight: bold;">

0

</td>

<td style="text-align:right;font-weight: bold;">

0

</td>

<td style="text-align:right;font-weight: bold;">

0

</td>

<td style="text-align:right;font-weight: bold;">

4

</td>

<td style="text-align:right;font-weight: bold;">

8

</td>

<td style="text-align:right;font-weight: bold;">

0

</td>

<td style="text-align:right;font-weight: bold;">

0

</td>

<td style="text-align:right;font-weight: bold;">

0

</td>

<td style="text-align:right;font-weight: bold;">

2

</td>

<td style="text-align:right;font-weight: bold;">

2

</td>

<td style="text-align:right;font-weight: bold;">

0

</td>

<td style="text-align:right;font-weight: bold;">

1

</td>

<td style="text-align:right;font-weight: bold;">

2

</td>

<td style="text-align:right;font-weight: bold;">

0

</td>

<td style="text-align:right;font-weight: bold;">

0

</td>

<td style="text-align:right;font-weight: bold;">

7

</td>

<td style="text-align:right;font-weight: bold;">

0

</td>

<td style="text-align:right;font-weight: bold;">

1

</td>

<td style="text-align:right;font-weight: bold;">

0

</td>

<td style="text-align:right;font-weight: bold;">

0

</td>

<td style="text-align:right;font-weight: bold;">

10

</td>

<td style="text-align:right;font-weight: bold;">

1

</td>

<td style="text-align:right;font-weight: bold;">

0

</td>

<td style="text-align:right;font-weight: bold;">

0

</td>

<td style="text-align:right;font-weight: bold;">

0

</td>

<td style="text-align:right;font-weight: bold;">

1

</td>

<td style="text-align:right;font-weight: bold;">

0

</td>

<td style="text-align:right;font-weight: bold;">

1

</td>

<td style="text-align:right;font-weight: bold;">

1

</td>

<td style="text-align:right;font-weight: bold;">

0

</td>

<td style="text-align:right;font-weight: bold;">

2

</td>

<td style="text-align:right;font-weight: bold;">

1

</td>

<td style="text-align:right;font-weight: bold;">

0

</td>

</tr>

<tr>

<td style="text-align:left;">

49

</td>

<td style="text-align:left;">

X

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

4.2014

</td>

<td style="text-align:right;">

11919

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

30

</td>

<td style="text-align:right;">

45

</td>

<td style="text-align:right;">

150

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

4

</td>

<td style="text-align:right;">

11

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

13

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;">

50

</td>

<td style="text-align:left;">

X

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

4.2223

</td>

<td style="text-align:right;">

12000

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

44

</td>

<td style="text-align:right;">

35

</td>

<td style="text-align:right;">

150

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

8

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

5

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

6

</td>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;">

51

</td>

<td style="text-align:left;">

X

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

4.2301

</td>

<td style="text-align:right;">

12054

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

37

</td>

<td style="text-align:right;">

30

</td>

<td style="text-align:right;">

150

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

6

</td>

<td style="text-align:right;">

10

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

7

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

6

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

7

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

4

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;">

52

</td>

<td style="text-align:left;">

X

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

4.2726

</td>

<td style="text-align:right;">

12135

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

50

</td>

<td style="text-align:right;">

10

</td>

<td style="text-align:right;">

120

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

7

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

8

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

8

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;font-weight: bold;">

53

</td>

<td style="text-align:left;font-weight: bold;">

X

</td>

<td style="text-align:right;font-weight: bold;">

0

</td>

<td style="text-align:right;font-weight: bold;">

NA

</td>

<td style="text-align:right;font-weight: bold;">

12189

</td>

<td style="text-align:right;font-weight: bold;">

0

</td>

<td style="text-align:right;font-weight: bold;">

43

</td>

<td style="text-align:right;font-weight: bold;">

17

</td>

<td style="text-align:right;font-weight: bold;">

120

</td>

<td style="text-align:right;font-weight: bold;">

0

</td>

<td style="text-align:right;font-weight: bold;">

0

</td>

<td style="text-align:right;font-weight: bold;">

0

</td>

<td style="text-align:right;font-weight: bold;">

0

</td>

<td style="text-align:right;font-weight: bold;">

0

</td>

<td style="text-align:right;font-weight: bold;">

2

</td>

<td style="text-align:right;font-weight: bold;">

15

</td>

<td style="text-align:right;font-weight: bold;">

0

</td>

<td style="text-align:right;font-weight: bold;">

0

</td>

<td style="text-align:right;font-weight: bold;">

1

</td>

<td style="text-align:right;font-weight: bold;">

1

</td>

<td style="text-align:right;font-weight: bold;">

2

</td>

<td style="text-align:right;font-weight: bold;">

0

</td>

<td style="text-align:right;font-weight: bold;">

0

</td>

<td style="text-align:right;font-weight: bold;">

2

</td>

<td style="text-align:right;font-weight: bold;">

0

</td>

<td style="text-align:right;font-weight: bold;">

0

</td>

<td style="text-align:right;font-weight: bold;">

5

</td>

<td style="text-align:right;font-weight: bold;">

1

</td>

<td style="text-align:right;font-weight: bold;">

0

</td>

<td style="text-align:right;font-weight: bold;">

0

</td>

<td style="text-align:right;font-weight: bold;">

0

</td>

<td style="text-align:right;font-weight: bold;">

6

</td>

<td style="text-align:right;font-weight: bold;">

2

</td>

<td style="text-align:right;font-weight: bold;">

0

</td>

<td style="text-align:right;font-weight: bold;">

2

</td>

<td style="text-align:right;font-weight: bold;">

0

</td>

<td style="text-align:right;font-weight: bold;">

1

</td>

<td style="text-align:right;font-weight: bold;">

0

</td>

<td style="text-align:right;font-weight: bold;">

2

</td>

<td style="text-align:right;font-weight: bold;">

1

</td>

<td style="text-align:right;font-weight: bold;">

0

</td>

<td style="text-align:right;font-weight: bold;">

0

</td>

<td style="text-align:right;font-weight: bold;">

0

</td>

<td style="text-align:right;font-weight: bold;">

0

</td>

</tr>

<tr>

<td style="text-align:left;">

54

</td>

<td style="text-align:left;">

X

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

4.3521

</td>

<td style="text-align:right;">

12324

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

50

</td>

<td style="text-align:right;">

11

</td>

<td style="text-align:right;">

86

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

15

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

4

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

5

</td>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

6

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

5

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;">

55

</td>

<td style="text-align:left;">

X

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

4.4177

</td>

<td style="text-align:right;">

12405

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

51

</td>

<td style="text-align:right;">

6

</td>

<td style="text-align:right;">

70

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

16

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

4

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

4

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

5

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

1

</td>

</tr>

</tbody>

</table>

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

Without taking into account these *NA* values, the Pearson correlation
of the interpolated ages with the real ones is 0.9984.

**IMPORTANT:** the interpretation of the interpolated ages requires a
careful consideration. Please, don’t do it blindly, because this
algorithm has its limitations. For example, significant hiatuses in the
data can introduce wild variations in interpolated ages.

``` r
#cleaning workspace
rm(list = ls())
```
