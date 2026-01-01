# Random or Restricted Permutation of Zoo Time Series

Fast permutation of zoo time series for null model testing using a fast
and efficient C++ implementations of different restricted and free
permutation methods.

The available permutation methods are:

- "free" (see
  [`permute_free_cpp()`](https://blasbenito.github.io/distantia/reference/permute_free_cpp.md)):
  Unrestricted and independent re-shuffling of individual cases across
  rows and columns. Individual values are relocated to a new row and
  column within the dimensions of the original matrix.

- "free_by_row" (see
  [`permute_free_by_row_cpp()`](https://blasbenito.github.io/distantia/reference/permute_free_by_row_cpp.md)):
  Unrestricted re-shuffling of complete rows. Each individual row is
  given a new random row number, and the data matrix is re-ordered
  accordingly.

- "restricted" (see
  [`permute_restricted_cpp()`](https://blasbenito.github.io/distantia/reference/permute_restricted_cpp.md)):
  Data re-shuffling across rows and columns is restricted to blocks of
  contiguous rows. The algorithm divides the data matrix into a set of
  blocks of contiguous rows, and individual cases are then assigned to a
  new row and column within their original block.

- "restricted_by_row" (see
  [`permute_restricted_by_row_cpp()`](https://blasbenito.github.io/distantia/reference/permute_restricted_by_row_cpp.md)):
  Re-shuffling of complete rows is restricted to blocks of contiguous
  rows. The algorithm divides the data matrix into a set of blocks of
  contiguous rows, each individual row is given a new random row number
  within its original block, and the block is reordered accordingly to
  generate the permuted output.

This function supports a parallelization setup via
[`future::plan()`](https://future.futureverse.org/reference/plan.html),
and progress bars provided by the package
[progressr](https://CRAN.R-project.org/package=progressr).

## Usage

``` r
zoo_permute(
  x = NULL,
  repetitions = 1L,
  permutation = "restricted_by_row",
  block_size = NULL,
  seed = 1L
)
```

## Arguments

- x:

  (required, zoo object) zoo time series. Default: NULL

- repetitions:

  (optional, integer) number of permutations to compute. Large numbers
  may compromise your R session. Default: 1

- permutation:

  (optional, character string) permutation method. Valid values are
  listed below from higher to lower induced randomness:

  - "free": unrestricted re-shuffling of individual cases across rows
    and columns. Ignores block_size.

  - "free_by_row": unrestricted re-shuffling of complete rows. Ignores
    block size.

  - "restricted": restricted shuffling across rows and columns within
    blocks of rows.

  - "restricted_by_row": restricted re-shuffling of rows within blocks.

- block_size:

  (optional, integer) Block size in number of rows for restricted
  permutations. Only relevant when permutation methods are "restricted"
  or "restricted_by_row". A block of size `n` indicates that the
  original data is pre-divided into blocks of such size, and a given row
  can only be permuted within their original block. If NULL, defaults to
  the rounded one tenth of the number of rows in `x`. Default: NULL.

- seed:

  (optional, integer) initial random seed to use during permutations.
  Default: 1

## Value

Time Series List

## See also

Other zoo_functions:
[`zoo_aggregate()`](https://blasbenito.github.io/distantia/reference/zoo_aggregate.md),
[`zoo_name_clean()`](https://blasbenito.github.io/distantia/reference/zoo_name_clean.md),
[`zoo_name_get()`](https://blasbenito.github.io/distantia/reference/zoo_name_get.md),
[`zoo_name_set()`](https://blasbenito.github.io/distantia/reference/zoo_name_set.md),
[`zoo_plot()`](https://blasbenito.github.io/distantia/reference/zoo_plot.md),
[`zoo_resample()`](https://blasbenito.github.io/distantia/reference/zoo_resample.md),
[`zoo_smooth_exponential()`](https://blasbenito.github.io/distantia/reference/zoo_smooth_exponential.md),
[`zoo_smooth_window()`](https://blasbenito.github.io/distantia/reference/zoo_smooth_window.md),
[`zoo_time()`](https://blasbenito.github.io/distantia/reference/zoo_time.md),
[`zoo_to_tsl()`](https://blasbenito.github.io/distantia/reference/zoo_to_tsl.md),
[`zoo_vector_to_matrix()`](https://blasbenito.github.io/distantia/reference/zoo_vector_to_matrix.md)

## Examples

``` r
#simulate zoo time series
x <- zoo_simulate(cols = 2)

if(interactive()){
  zoo_plot(x)
}

#free
x_free <- zoo_permute(
  x = x,
  permutation = "free",
  repetitions = 2
)

if(interactive()){
  tsl_plot(
    tsl = x_free,
    guide = FALSE
    )
}

#free by row
x_free_by_row <- zoo_permute(
  x = x,
  permutation = "free_by_row",
  repetitions = 2
)

if(interactive()){
  tsl_plot(
    tsl = x_free_by_row,
    guide = FALSE
  )
}

#restricted
x_restricted <- zoo_permute(
  x = x,
  permutation = "restricted",
  repetitions = 2
)

if(interactive()){
  tsl_plot(
    tsl = x_restricted,
    guide = FALSE
  )
}

#restricted by row
x_restricted_by_row <- zoo_permute(
  x = x,
  permutation = "restricted_by_row",
  repetitions = 2
)

if(interactive()){
  tsl_plot(
    tsl = x_restricted_by_row,
    guide = FALSE
  )
}
```
