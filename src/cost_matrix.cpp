#include <Rcpp.h>
using namespace Rcpp;

// This is a simple example of exporting a C++ function to R. You can
// source this function into an R session using the Rcpp::sourceCpp
// function (or via the Source button on the editor toolbar). Learn
// more about Rcpp at:
//
//   http://www.rcpp.org/
//   http://adv-r.had.co.nz/Rcpp.html
//   http://gallery.rcpp.org/
//

//' Least Cost Matrix Considering Diagonals
//' @description Computes the least cost matrix from a distance matrix.
//' Considers diagonals during computation of least-costs.
//' @param d (required, distance matrix). Distance matrix.
//' @return Least cost matrix.
//' @export
// [[Rcpp::export]]
NumericMatrix cost_matrix_diag_cpp(
    NumericMatrix dist_matrix
){

  int an = dist_matrix.nrow();
  int bn = dist_matrix.ncol();
  NumericMatrix m(an, bn);

  m(0, 0) = dist_matrix(0, 0);

  for (int i = 1; i < an; ++i) {
    m(i, 0) = m(i - 1, 0) + dist_matrix(i, 0);
  }

  for (int j = 1; j < bn; ++j) {
    m(0, j) = m(0, j - 1) + dist_matrix(0, j);
  }

  for (int i = 1; i < an; ++i) {
    for (int j = 1; j < bn; ++j) {
      m(i, j) = std::min({m(i - 1, j), m(i, j - 1), m(i - 1, j - 1)}) + dist_matrix(i, j);
    }
  }

  return m;
}

//' Least Cost Matrix with Weighted Diagonals
//' @description Computes the least cost matrix from a distance matrix.
//' Weights diagonals by a factor of 1.414214 with respect to orthogonal paths.
//' @param dist_matrix (required, distance matrix). Distance matrix.
//' @return Least cost matrix.
//' @export
// [[Rcpp::export]]
NumericMatrix cost_matrix_weighted_diag_cpp(
    NumericMatrix dist_matrix
){

  int an = dist_matrix.nrow();
  int bn = dist_matrix.ncol();
  NumericMatrix m(an, bn);

  // Define the diagonal weight
  double diagonal_weight = 1.414214;

  m(0, 0) = dist_matrix(0, 0);

  for (int i = 1; i < an; ++i) {
    m(i, 0) = m(i - 1, 0) + dist_matrix(i, 0);
  }

  for (int j = 1; j < bn; ++j) {
    m(0, j) = m(0, j - 1) + dist_matrix(0, j);
  }

  for (int i = 1; i < an; ++i) {
    for (int j = 1; j < bn; ++j) {
      // Apply the weight factor for diagonal movements
      if (i == j) {
        m(i, j) = std::min({m(i - 1, j), m(i, j - 1), m(i - 1, j - 1)}) + dist_matrix(i, j) * diagonal_weight;
      } else {
        m(i, j) = std::min({m(i - 1, j), m(i, j - 1)}) + dist_matrix(i, j);
      }
    }
  }

  return m;
}

//' Least Cost Matrix
//' @description Computes the least cost matrix from a distance matrix.
//' @param dist_matrix (required, distance matrix). Output of [distance_matrix_cpp()].
//' @return Least cost matrix.
//' @export
// [[Rcpp::export]]
NumericMatrix cost_matrix_cpp(
     NumericMatrix dist_matrix
 ){

   int an = dist_matrix.nrow();
   int bn = dist_matrix.ncol();
   NumericMatrix m(an, bn);

   m(0, 0) = dist_matrix(0, 0);

   for (int i = 1; i < an; ++i) {
     m(i, 0) = m(i - 1, 0) + dist_matrix(i, 0);
   }

   for (int j = 1; j < bn; ++j) {
     m(0, j) = m(0, j - 1) + dist_matrix(0, j);
   }

   for (int i = 1; i < an; ++i) {
     for (int j = 1; j < bn; ++j) {
       m(i, j) = std::min({m(i - 1, j), m(i, j - 1)}) + dist_matrix(i, j);
     }
   }

   return m;
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

d <- distance_matrix_cpp(a, b, f = distance_euclidean_cpp)

m <- cost_matrix_cpp(dist_matrix = d)
m[1:5, 1:5]

m <- cost_matrix_diag_cpp(dist_matrix = d)
m[1:5, 1:5]

m <- cost_matrix_weighted_diag_cpp(dist_matrix = d)
m[1:5, 1:5]
*/
