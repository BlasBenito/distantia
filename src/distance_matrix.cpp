#include <Rcpp.h>
#include "distance_methods.h"
using namespace Rcpp;


//' Distance Matrix
//' @description Computes the distance matrix between the rows of two matrices
//' \code{a} and \code{b} with the same number of columns and arbitrary numbers
//' of rows.
//' NA values should be removed before using this function.
//' If the selected distance function is "chi" or "cosine", pairs of zeros should
//' be either removed or replaced with pseudo-zeros (i.e. 0.00001).
//' @param a (required, numeric matrix).
//' @param b (required, numeric matrix) of same number of columns as 'a'.
//' @param distance (optional, character string) name or abbreviation of the
//' distance method. Valid values are in the columns "names" and "abbreviation"
//' of the dataset `distances`. Default: "euclidean".
//' @return Matrix of distances between 'a' (rows) and 'b' (columns).
//' @export
//' @name distance_matrix_cpp
// [[Rcpp::export]]
NumericMatrix distance_matrix_cpp(
    NumericMatrix a,
    NumericMatrix b,
    const std::string& distance = "euclidean"
){

  DistanceFunction f = select_distance_function_cpp(distance);

  int an = a.nrow();
  int bn = b.nrow();
  NumericMatrix D(an, bn);

  for (int i = 0; i < an; i++) {
    for (int j = 0; j < bn; j++) {
      D(i, j) = f(a.row(i), b.row(j));
    }
  }

  return D;
}


//' Sum of Pairwise Distances Between Paired Sequences
//' @description Computes the sum of distances between paired rows in two
//' sequences of the same length.
//' NA values should be removed before using this function.
//' If the selected distance function is "chi" or "cosine", pairs of zeros should
//' be either removed or replaced with pseudo-zeros (i.e. 0.00001).
//' @param a (required, numeric matrix).
//' @param b (required, numeric matrix) of same number of columns and rows as 'a'.
//' @param distance (optional, character string) name or abbreviation of the
//' distance method. Valid values are in the columns "names" and "abbreviation"
//' of the dataset `distances`. Default: "euclidean".
//' @return Vector of distances between 'a' (rows) and 'b' (columns).
//' @export
// [[Rcpp::export]]
double distance_pairwise_cpp(
    NumericMatrix a,
    NumericMatrix b,
    const std::string& distance = "euclidean"
){

  DistanceFunction f = select_distance_function_cpp(distance);

  int an = a.nrow();

  if (an != b.nrow()) {
    Rcpp::stop("Number of rows in 'a' and 'b' must be the same.");
  }

  NumericVector D(an);

  for (int i = 0; i < an; i++) {
    D(i) = f(a.row(i), b.row(i));
  }

  return sum(D*2);
}


// You can include R code blocks in C++ files processed with sourceCpp
// (useful for testing and development). The R code will be automatically
// run after the compilation.
//

/*** R
library(distantia)

a <- sequenceA |>
  na.omit() |>
  as.matrix()

b <- sequenceB |>
  na.omit() |>
  as.matrix()

a[a == 0] <- 0.0001
b[b == 0] <- 0.0001

d <- distance_matrix_cpp(a, b, distance = "euclidean")
dim(d)
d[1:5, 1:5]

d <- distance_matrix_cpp(a, b)
dim(d)
d[1:5, 1:5]

d <- distance_matrix_cpp(a, b, distance = "manhattan")
dim(d)
d[1:5, 1:5]

d <- distance_matrix_cpp(a, b, distance = "jaccard")
dim(d)
d[1:5, 1:5]

d <- distance_matrix_cpp(a, b, distance = "hellinger")
dim(d)
d[1:5, 1:5]

d <- distance_matrix_cpp(a, b, distance = "chi")
dim(d)
d[1:5, 1:5]

d <- distance_matrix_cpp(a, b, distance = "canberra")
dim(d)
d[1:5, 1:5]

d <- distance_matrix_cpp(a, b, distance = "chebyshev")
dim(d)
d[1:5, 1:5]

d <- distance_matrix_cpp(a, b, distance = "russelrao")
dim(d)
d[1:5, 1:5]

d <- distance_matrix_cpp(a, b, distance = "cosine")
dim(d)
d[1:5, 1:5]


message("distance_pairwise_cpp")

a <- a[1:nrow(b), ]

d <- distance_pairwise_cpp(a, b, distance = "euclidean")
d[1:5]

d <- distance_pairwise_cpp(a, b, distance = "manhattan")
d[1:5]

d <- distance_pairwise_cpp(a, b, distance = "jaccard")
d[1:5]

d <- distance_pairwise_cpp(a, b, distance = "hellinger")
d[1:5]

d <- distance_pairwise_cpp(a, b, distance = "chi")
d[1:5]

d <- distance_pairwise_cpp(a, b, distance = "canberra")
d[1:5]

d <- distance_pairwise_cpp(a, b, distance = "chebyshev")
d[1:5]

d <- distance_pairwise_cpp(a, b, distance = "russelrao")
d[1:5]

d <- distance_pairwise_cpp(a, b, distance = "cosine")
d[1:5]
*/
