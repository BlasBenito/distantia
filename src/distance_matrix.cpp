#include <Rcpp.h>
#include "distance_methods.h"
using namespace Rcpp;


//' Distance Matrix
//' @description Computes the distance matrix between the rows of two matrices
//' \code{y} and \code{x} with the same number of columns and arbitrary numbers
//' of rows.
//' NA values should be removed before using this function.
//' If the selected distance function is "chi" or "cosine", pairs of zeros should
//' be either removed or replaced with pseudo-zeros (i.e. 0.00001).
//' @param y (required, numeric matrix).
//' @param x (required, numeric matrix) of same number of columns as 'y'.
//' @param distance (optional, character string) name or abbreviation of the
//' distance method. Valid values are in the columns "names" and "abbreviation"
//' of the dataset `distances`. Default: "euclidean".
//' @return Matrix of distances between 'y' (rows) and 'x' (columns).
//' @export
//' @name distance_matrix_cpp
// [[Rcpp::export]]
NumericMatrix distance_matrix_cpp(
    NumericMatrix x,
    NumericMatrix y,
    const std::string& distance = "euclidean"
){

  DistanceFunction f = select_distance_function_cpp(distance);

  int yn = y.nrow();
  int xn = x.nrow();
  NumericMatrix D(yn, xn);

  for (int i = 0; i < yn; i++) {
    for (int j = 0; j < xn; j++) {
      D(i, j) = f(y.row(i), x.row(j));
    }
  }

  return D;
}


//' Sum of Pairwise Distances Between Paired Sequences
//' @description Computes the lock-step sum of distances between two time series.
//' NA values should be removed before using this function.
//' If the selected distance function is "chi" or "cosine", pairs of zeros should
//' be either removed or replaced with pseudo-zeros (i.e. 0.00001).
//' @param y (required, numeric matrix).
//' @param x (required, numeric matrix) of same number of columns and rows as 'y'.
//' @param distance (optional, character string) name or abbreviation of the
//' distance method. Valid values are in the columns "names" and "abbreviation"
//' of the dataset `distances`. Default: "euclidean".
//' @return Vector of distances between 'y' (rows) and 'x' (columns).
//' @export
// [[Rcpp::export]]
double distance_lock_step_cpp(
    NumericMatrix y,
    NumericMatrix x,
    const std::string& distance = "euclidean"
){

  DistanceFunction f = select_distance_function_cpp(distance);

  int yn = y.nrow();

  if (yn != x.nrow()) {
    Rcpp::stop("Number of rows in 'y' and 'x' must be the same.");
  }

  NumericVector D(yn);

  for (int i = 0; i < yn; i++) {
    D(i) = f(y.row(i), x.row(i));
  }

  return sum(D*2);
}


// You can include R code blocks in C++ files processed with sourceCpp
// (useful for testing and development). The R code will be automatically
// run after the compilation.
//

/*** R
library(distantia)

y <- sequenceA |>
  na.omit() |>
  as.matrix()

x <- sequenceB |>
  na.omit() |>
  as.matrix()

y[y == 0] <- 0.0001
x[x == 0] <- 0.0001

nrow(y)
nrow(x)

d <- distance_matrix_cpp(x, y, distance = "euclidean")
dim(d)
d[1:5, 1:5]

d <- distance_matrix_cpp(x, y)
dim(d)
d[1:5, 1:5]

d <- distance_matrix_cpp(x, y, distance = "manhattan")
dim(d)
d[1:5, 1:5]

d <- distance_matrix_cpp(x, y, distance = "jaccard")
dim(d)
d[1:5, 1:5]

d <- distance_matrix_cpp(x, y, distance = "hellinger")
dim(d)
d[1:5, 1:5]

d <- distance_matrix_cpp(x, y, distance = "chi")
dim(d)
d[1:5, 1:5]

d <- distance_matrix_cpp(x, y, distance = "canberra")
dim(d)
d[1:5, 1:5]

d <- distance_matrix_cpp(x, y, distance = "chebyshev")
dim(d)
d[1:5, 1:5]

d <- distance_matrix_cpp(x, y, distance = "russelrao")
dim(d)
d[1:5, 1:5]

d <- distance_matrix_cpp(x, y, distance = "cosine")
dim(d)
d[1:5, 1:5]


message("distance_lock_step_cpp")

y <- y[1:nrow(x), ]

distance_lock_step_cpp(x, y, distance = "euclidean")

distance_lock_step_cpp(x, y, distance = "manhattan")

distance_lock_step_cpp(x, y, distance = "jaccard")

distance_lock_step_cpp(x, y, distance = "hellinger")

distance_lock_step_cpp(x, y, distance = "chi")

distance_lock_step_cpp(x, y, distance = "canberra")

distance_lock_step_cpp(x, y, distance = "chebyshev")

distance_lock_step_cpp(x, y, distance = "russelrao")

distance_lock_step_cpp(x, y, distance = "cosine")
*/
