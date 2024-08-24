#include <Rcpp.h>
using namespace Rcpp;

//' (C++) Least Cost Matrix Considering Diagonals
//' @description Computes the least cost matrix from a distance matrix.
//' Considers diagonals during computation of least-costs.
//' @param dist_matrix (required, distance matrix). Square distance matrix, output of [distance_matrix_cpp()].
//' @return Least cost matrix.
//' @export
//' @family Rcpp
// [[Rcpp::export]]
NumericMatrix cost_matrix_diag_cpp(
    NumericMatrix dist_matrix
){

  int yn = dist_matrix.nrow();
  int xn = dist_matrix.ncol();
  NumericMatrix m(yn, xn);

  m(0, 0) = dist_matrix(0, 0);

  for (int i = 1; i < yn; ++i) {
    m(i, 0) = m(i - 1, 0) + dist_matrix(i, 0);
  }

  for (int j = 1; j < xn; ++j) {
    m(0, j) = m(0, j - 1) + dist_matrix(0, j);
  }

  for (int i = 1; i < yn; ++i) {
    for (int j = 1; j < xn; ++j) {
      m(i, j) = std::min({m(i - 1, j), m(i, j - 1), m(i - 1, j - 1)}) + dist_matrix(i, j);
    }
  }

  // Adjusting the last cell to include the return cost to the starting point
  m(yn - 1, xn - 1) += m(0, 0);

  return m;
}

//' (C++) Least Cost Matrix with Weighted Diagonals
//' @description Computes the least cost matrix from a distance matrix.
//' Weights diagonals by a factor of 1.414214 with respect to orthogonal paths.
//' @param dist_matrix (required, distance matrix). Distance matrix.
//' @return Least cost matrix.
//' @export
//' @family Rcpp
// [[Rcpp::export]]
NumericMatrix cost_matrix_weighted_diag_cpp(
    NumericMatrix dist_matrix
){

  int yn = dist_matrix.nrow();
  int xn = dist_matrix.ncol();
  NumericMatrix m(yn, xn);

  // Define the diagonal weight
  double diagonal_weight = 1.414214;

  m(0, 0) = dist_matrix(0, 0);

  for (int i = 1; i < yn; ++i) {
    m(i, 0) = m(i - 1, 0) + dist_matrix(i, 0);
  }

  for (int j = 1; j < xn; ++j) {
    m(0, j) = m(0, j - 1) + dist_matrix(0, j);
  }

  for (int i = 1; i < yn; ++i) {
    for (int j = 1; j < xn; ++j) {
      // Apply the weight factor for diagonal movements
      if (i == j) {
        m(i, j) = std::min({m(i - 1, j), m(i, j - 1), m(i - 1, j - 1)}) + dist_matrix(i, j) * diagonal_weight;
      } else {
        m(i, j) = std::min({m(i - 1, j), m(i, j - 1)}) + dist_matrix(i, j);
      }
    }
  }

  // Adjusting the last cell to include the return cost to the starting point
  m(yn - 1, xn - 1) += m(0, 0);

  return m;
}

//' (C++) Least Cost Matrix
//' @description Computes the least cost matrix from a distance matrix.
//' @param dist_matrix (required, distance matrix). Output of [distance_matrix_cpp()].
//' @return Least cost matrix.
//' @export
//' @family Rcpp
// [[Rcpp::export]]
NumericMatrix cost_matrix_cpp(
     NumericMatrix dist_matrix
 ){

   int yn = dist_matrix.nrow();
   int xn = dist_matrix.ncol();
   NumericMatrix m(yn, xn);

   m(0, 0) = dist_matrix(0, 0);

   for (int i = 1; i < yn; ++i) {
     m(i, 0) = m(i - 1, 0) + dist_matrix(i, 0);
   }

   for (int j = 1; j < xn; ++j) {
     m(0, j) = m(0, j - 1) + dist_matrix(0, j);
   }

   for (int i = 1; i < yn; ++i) {
     for (int j = 1; j < xn; ++j) {
       m(i, j) = std::min({m(i - 1, j), m(i, j - 1)}) + dist_matrix(i, j);
     }
   }

   // Adjusting the last cell to include the return cost to the starting point
   m(yn - 1, xn - 1) += m(0, 0);

   return m;
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

d <- distance_matrix_cpp(x, y)

m <- cost_matrix_cpp(dist_matrix = d)
m[1:5, 1:5]

m <- cost_matrix_diag_cpp(dist_matrix = d)
m[1:5, 1:5]

m <- cost_matrix_weighted_diag_cpp(dist_matrix = d)
m[1:5, 1:5]
*/
