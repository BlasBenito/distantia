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
//' @param d (required, distance matrix). Output of [distance_matrix_cpp()].
//' @return Least cost matrix.
//' @export
// [[Rcpp::export]]
NumericMatrix least_cost_matrix_diag_cpp(
    NumericMatrix d
){

  int an = d.nrow();
  int bn = d.ncol();
  NumericMatrix m(an, bn);

  rownames(m) = rownames(d);
  colnames(m) = colnames(d);

  m(0, 0) = d(0, 0);

  for (int i = 1; i < an; ++i) {
    m(i, 0) = m(i - 1, 0) + d(i, 0);
  }

  for (int j = 1; j < bn; ++j) {
    m(0, j) = m(0, j - 1) + d(0, j);
  }

  for (int i = 1; i < an; ++i) {
    for (int j = 1; j < bn; ++j) {
      m(i, j) = std::min({m(i - 1, j), m(i, j - 1), m(i - 1, j - 1)}) + d(i, j);
    }
  }

  return m;
}

//' Least Cost Matrix
//' @description Computes the least cost matrix from a distance matrix.
//' @param d (required, distance matrix). Output of [distance_matrix_cpp()].
//' @return Least cost matrix.
//' @export
// [[Rcpp::export]]
NumericMatrix least_cost_matrix_cpp(
     NumericMatrix d
 ){

   int an = d.nrow();
   int bn = d.ncol();
   NumericMatrix m(an, bn);

   rownames(m) = rownames(d);
   colnames(m) = colnames(d);

   m(0, 0) = d(0, 0);

   for (int i = 1; i < an; ++i) {
     m(i, 0) = m(i - 1, 0) + d(i, 0);
   }

   for (int j = 1; j < bn; ++j) {
     m(0, j) = m(0, j - 1) + d(0, j);
   }

   for (int i = 1; i < an; ++i) {
     for (int j = 1; j < bn; ++j) {
       m(i, j) = std::min({m(i - 1, j), m(i, j - 1)}) + d(i, j);
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

least_cost <- least_cost_matrix_cpp(d = d)
least_cost[1:5, 1:5]

least_cost_diag <- least_cost_matrix_diag_cpp(d = d)
least_cost_diag[1:5, 1:5]
*/
