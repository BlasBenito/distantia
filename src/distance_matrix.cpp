#include <Rcpp.h>
#include "distance_methods.h"
using namespace Rcpp;


//' (C++) Distance Matrix of Two Time Series
//' @description Computes the distance matrix between the rows of two matrices
//' \code{y} and \code{x} representing regular or irregular time series with the same number of
//' columns. NA values should be removed before using this function. If the selected distance function is "chi" or "cosine", pairs of zeros should
//' be either removed or replaced with pseudo-zeros (i.e. 0.00001).
//' @param x (required, numeric matrix) univariate or multivariate time series.
//' @param y (required, numeric matrix) univariate or multivariate time series
//' with the same number of columns as 'x'.
//' @param distance (optional, character string) distance name from the "names"
//' column of the dataset `distances` (see `distances$name`). Default: "euclidean".
//' @return numeric matrix
//' @examples
//' #simulate two time series
//' x <- zoo_simulate(seed = 1)
//' y <- zoo_simulate(seed = 2)
//'
//' #distance matrix
//' dist_matrix <- distance_matrix_cpp(
//'   x = x,
//'   y = y,
//'   distance = "euclidean"
//' )
//' @export
//' @family Rcpp_matrix
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


//' (C++) Sum of Pairwise Distances Between Cases in Two Aligned Time Series
//' @description Computes the lock-step sum of distances between two regular
//' and aligned time series. NA values should be removed before using this function.
//' If the selected distance function is "chi" or "cosine", pairs of zeros should
//' be either removed or replaced with pseudo-zeros (i.e. 0.00001).
//' @param x (required, numeric matrix) univariate or multivariate time series.
//' @param y (required, numeric matrix) univariate or multivariate time series
//' with the same number of columns and rows as 'x'.
//' @param distance (optional, character string) distance name from the "names"
//' column of the dataset `distances` (see `distances$name`). Default: "euclidean".
//' @return numeric
//' @examples
//' #simulate two regular time series
//' x <- zoo_simulate(
//'   seed = 1,
//'   irregular = FALSE
//'   )
//' y <- zoo_simulate(
//'   seed = 2,
//'   irregular = FALSE
//'   )
//'
//' #distance matrix
//' dist_matrix <- distance_lock_step_cpp(
//'   x = x,
//'   y = y,
//'   distance = "euclidean"
//' )
//' @export
//' @family Rcpp_matrix
// [[Rcpp::export]]
double distance_lock_step_cpp(
    NumericMatrix x,
    NumericMatrix y,
    const std::string& distance = "euclidean"
){

  DistanceFunction f = select_distance_function_cpp(distance);

  int yn = y.nrow();

  if (yn != x.nrow()) {
    Rcpp::stop("distantia::distance_lock_step_cpp(): number of rows in 'y' and 'x' must be the same.");
  }

  NumericVector D(yn);

  for (int i = 0; i < yn; i++) {
    D(i) = f(y.row(i), x.row(i));
  }

  return sum(D);
}


// You can include R code blocks in C++ files processed with sourceCpp
// (useful for testing and development). The R code will be automatically
// run after the compilation.
//

/*** R
library(distantia)


y <- zoo_simulate()

x <- zoo_simulate()

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
