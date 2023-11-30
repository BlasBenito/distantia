#include <Rcpp.h>
#include "distance_metrics.h"
#include "distance_matrix.h"
#include "cost_matrix.h"
#include "cost_path.h"
#include "auto_sum.h"
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


//' Computes Psi Distance Between Two Time-Series
//' @description Computes the distance psi between two matrices
//' \code{a} and \code{b} with the same number of columns and arbitrary numbers of rows.
//' NA values should be removed before using this function.
//' If the selected distance function is "chi" or "cosine", pairs of zeros should
//' be either removed or replaced with pseudo-zeros (i.e. 0.00001).
//' @param a (required, numeric matrix).
//' @param b (required, numeric matrix) of same number of columns as 'a'.
//' @param method (optional, character string) name of the distance metric. Valid entries are:
//' \itemize{
//' \item "euclidean" and "euc" (Default).
//' \item "manhattan" and "man".
//' \item "chi.
//' \item "hellinger" and "hel".
//' \item "chebyshev" and "che".
//' \item "canberra" and "can".
//' \item "cosine" and "cos".
//' \item "russelrao" and "rus".
//' \item "jaccard" and "jac".
//' }
//' @param diagonal (optional, logical). If `TRUE`, diagonals are included in the computation of the cost matrix Default: FALSE.
//' @param weighted (optional, logical). Only relevant if `diagonal = TRUE`. If `TRUE`, weights diagonal cost by a factor of 1.414214.
//' @return Psi distance
//' @export
// [[Rcpp::export]]
double distantia_cpp(
    NumericMatrix a,
    NumericMatrix b,
    Rcpp::Nullable<std::string> method,
    bool diagonal = false,
    bool weighted = false,
    bool trim = false
){

  //compute distance matrix
  NumericMatrix dist_matrix = distance_matrix_cpp(
    a,
    b,
    method
  );

  //compute cost matrix
  int an = dist_matrix.nrow();
  int bn = dist_matrix.ncol();
  NumericMatrix cost_matrix(an, bn);

  if (diagonal && weighted) {
    cost_matrix = cost_matrix_weighted_diag_cpp(dist_matrix);
  } else if (diagonal) {
    cost_matrix = cost_matrix_diag_cpp(dist_matrix);
  } else {
    cost_matrix = cost_matrix_cpp(dist_matrix);
  }

  //compute cost path
  DataFrame cost_path;
  if (diagonal) {
    cost_path = cost_path_diag_cpp(dist_matrix, cost_matrix);
  } else {
    cost_path = cost_path_cpp(dist_matrix, cost_matrix);
  }

  //trim cost path
  if (trim){
    cost_path = cost_path_trim_cpp(cost_path);
  }

  //sum cost path
  double cost_path_sum = cost_path_sum_cpp(cost_path);

  //auto sum sequences
  double ab_sum = auto_sum_cpp(
    a,
    b,
    cost_path,
    method
  );

  //compute psi
  double psi = ((cost_path_sum * 2) - ab_sum) / ab_sum;

  return psi;

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

distantia_cpp(
  a = a,
  b = b,
  method = "euclidean",
  diagonal = TRUE,
  weighted = TRUE,
  trim = TRUE
)

distantia_cpp(
  a = a,
  b = b,
  method = "euclidean",
  diagonal = FALSE,
  weighted = FALSE,
  trim = FALSE
)

distantia_cpp(
  a = a,
  b = b,
  method = "euclidean",
  diagonal = TRUE,
  weighted = FALSE,
  trim = TRUE
)

distantia_cpp(
  a = a,
  b = b,
  method = "euclidean",
  diagonal = FALSE,
  weighted = FALSE,
  trim = TRUE
)


*/
