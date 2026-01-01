# Distance Between Two Numeric Vectors

Computes the distance between two numeric vectors with a distance metric
included in the data frame
[`distantia::distances`](https://blasbenito.github.io/distantia/reference/distances.md).

## Usage

``` r
distance(x = NULL, y = NULL, distance = "euclidean")
```

## Arguments

- x:

  (required, numeric vector).

- y:

  (required, numeric vector) of same length as `x`.

- distance:

  (optional, character string) name or abbreviation of the distance
  method. Valid values are in the columns "names" and "abbreviation" of
  the dataset `distances`. Default: "euclidean".

## Value

numeric value

## See also

Other distances:
[`distance_matrix()`](https://blasbenito.github.io/distantia/reference/distance_matrix.md),
[`distances`](https://blasbenito.github.io/distantia/reference/distances.md)

## Examples

``` r
distance(
  x = runif(100),
  y = runif(100),
  distance = "euclidean"
)
#> [1] 4.210524
#> attr(,"distance")
#> [1] "euclidean"
```
