#include <Rcpp.h>
#include "distance_metrics.h"
using namespace Rcpp;

//' Distance Matrix
//' @description Computes the distance matrix between the rows of two matrices
//' \code{a} and \code{b} with the same number of columns and arbitrary numbers of rows.
//' NA values should be removed before using this function.
//' If the selected distance function is [distance_chi_cpp], pairs of zeros should
//' be either removed or replaced with pseudo-zeros (i.e. 0.00001).
//' @param a (required, numeric matrix).
//' @param b (required, numeric matrix) of same number of columns as 'a'.
//' @param f (required, function) a distance function. One of:
//' \itemize{
//'   \item distance_manhattan_cpp.
//'   \item distance_euclidean_cpp.
//'   \item distance_hellinger_cpp.
//'   \item distance_chi_cpp.
//' }
//' @return Matrix of distances between 'a' (rows) and 'b' (columns).
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
a <- matrix(runif(1000), 100, 10)
b <- matrix(runif(1000), 50, 10)
d <- distance_matrix_cpp(a, b, f = distance_manhattan_cpp)
dim(d)
d[1:5, 1:5]
*/
