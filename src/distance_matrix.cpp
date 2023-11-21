#include <Rcpp.h>
using namespace Rcpp;

//' Distance Matrix
//' @description Computes the distance matrix between two matrices
//' \code{a} and \code{b} using one distance function.
//' @param a (required, numeric matrix).
//' @param b (required, numeric matrix) of same ncol as `a`.
//' @param f (required, function) a function. One of:
//' \itemize{
//'   \item [distance_manhattan_cpp].
//'   \item [distance_euclidean_cpp].
//'   \item [distance_hellinger_cpp].
//'   \item [distance_chi_cpp]
//' }
//' @return Matrix of distances between `a` (rows) and `b` (columns).
//' @details Cannot handle NA values.
//' @export
// [[Rcpp::export]]
NumericMatrix distance_matrix_cpp(
    NumericMatrix a,
    NumericMatrix b,
    Function f
){

  int an = a.nrow();
  int bn = b.nrow();
  NumericMatrix D(an, bn);

  for (int i = 0; i < an; i++) {
    for (int j = 0; j < bn; j++) {
      double dist = as<double>(f(a.row(i), b.row(j)));
      D(i, j) = dist;
    }
  }

  return D;
}


// You can include R code blocks in C++ files processed with sourceCpp
// (useful for testing and development). The R code will be automatically
// run after the compilation.
//

/*** R
set.seed(1)
n <- 100
a <- data.frame(
  x = runif(n),
  y = runif(n),
  z = runif(n)
) |>
  as.matrix()

b <- data.frame(
  x = runif(n),
  y = runif(n),
  z = runif(n)
) |>
  as.matrix()

D <- distance_matrix_cpp(a, b, f = distance_manhattan_cpp)
dim(D)
D[1:5, 1:5]
*/
