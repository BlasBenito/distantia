#include <Rcpp.h>
using namespace Rcpp;
#include "psi.h"

// Function to extract one column from the matrix x
// [[Rcpp::export]]
NumericMatrix select_column_cpp(NumericMatrix x, int column_index) {

  int rows = x.nrow();

  NumericMatrix result(rows, 1);

  for (int i = 0; i < rows; ++i) {
    result(i, 0) = x(i, column_index);
  }

  return result;
}

//function to remove one column from the matrix x
// [[Rcpp::export]]
NumericMatrix delete_column_cpp(NumericMatrix x, int column_index) {

  int rows = x.nrow();
  int cols = x.ncol() - 1;

  NumericMatrix result(rows, cols);

  for (int j = 0; j < x.nrow(); ++j) {
    for (int k = 0, l = 0; k < x.ncol(); ++k) {
      if (k != column_index) {
        result(j, l) = x(j, k);
        ++l;
      }
    }
  }

  return result;

}


//' Computes Psi Distance Between Two Time-Series With Paired Samples
//' @description Computes the distance psi between two matrices
//' \code{a} and \code{b} with the same number of columns and rows. Distances
//' between \code{a} and \code{b} are computed row wise rather than via distance
//' matrix and least-cost path computation.
//' NA values should be removed before using this function.
//' If the selected distance function is "chi" or "cosine", pairs of zeros should
//' be either removed or replaced with pseudo-zeros (i.e. 0.00001).
//' @param a (required, numeric matrix).
//' @param b (required, numeric matrix) of same number of columns as 'a'.
//' @param method (optional, character string) name or abbreviation of the
//' distance method. Valid values are in the columns "names" and "abbreviation"
//' of the dataset `methods`. Default: "euclidean".
//' @return Psi distance
//' @export
// [[Rcpp::export]]
DataFrame importance_paired_cpp(
    NumericMatrix a,
    NumericMatrix b,
    Rcpp::Nullable<std::string> method
){

  // Check dimensions of a and b
  if (a.nrow() != b.nrow() || a.ncol() != b.ncol()) {
    Rcpp::stop("Matrices a and b must have the same dimensions.");
  }

  //vectors to store results
  NumericVector psi_all(a.ncol());
  NumericVector psi_only_with(a.ncol());
  NumericVector psi_without(a.ncol());

  //compute psi with all variables
  double psi_all_variables = psi_paired_cpp(
    a,
    b,
    method
  );

  //iterate over columns
  for (int i = 0; i < a.ncol(); ++i){

    //fill psi_all
    psi_all[i] = psi_all_variables;

    //create subsets
    NumericMatrix a_only_with = select_column_cpp(a, i);
    NumericMatrix b_only_with = select_column_cpp(b, i);

    //compute psi for the column i
    psi_only_with[i] = psi_paired_cpp(
      a_only_with,
      b_only_with,
      method
    );

    //create subsets
    NumericMatrix a_without = delete_column_cpp(a, i);
    NumericMatrix b_without = delete_column_cpp(b, i);

    //compute psi without the column i
    psi_without[i] = psi_paired_cpp(
      a_without,
      b_without,
      method
    );

  }

  // Create output data frame
  return DataFrame::create(
    _["psi_all"] = psi_all,
    _["psi_only_with"] = psi_only_with,
    _["psi_without"] = psi_without
  );

}

//' Computes Per Column Psi Importance
//' @description Computes the psi distance between a and b using all columns,
//' with each column, and without each column
//' @param a (required, numeric matrix).
//' @param b (required, numeric matrix) of same number of columns as 'a'.
//' @param method (optional, character string) name or abbreviation of the
//' distance method. Valid values are in the columns "names" and "abbreviation"
//' of the dataset `methods`. Default: "euclidean".
//' @param diagonal (optional, logical). If TRUE, diagonals are included in the
//' computation of the cost matrix. Default: FALSE.
//' @param weighted (optional, logical). If TRUE, diagonal is set to TRUE, and
//' diagonal cost is weighted by a factor of 1.414214. Default: FALSE.
//' @param trim_blocks (optional, logical). If TRUE, blocks of consecutive path
//' coordinates are trimmed to avoid inflating the psi distance. Default: FALSE.
//' @return Data frame with psi distances
//' @export
// [[Rcpp::export]]
DataFrame importance_full_cpp(
    NumericMatrix a,
    NumericMatrix b,
    Rcpp::Nullable<std::string> method,
    bool diagonal = false,
    bool weighted = false,
    bool trim_blocks = false
){

  // Check dimensions of a and b
  if (a.ncol() != b.ncol()) {
    Rcpp::stop("Matrices a and b must have the same columns.");
  }

  //vectors to store results
  NumericVector psi_all(a.ncol());
  NumericVector psi_only_with(a.ncol());
  NumericVector psi_without(a.ncol());

  //compute psi with all variables
  double psi_all_variables = psi_full_cpp(
    a,
    b,
    method,
    diagonal,
    weighted,
    trim_blocks
  );

  //iterate over columns
  for (int i = 0; i < a.ncol(); ++i){

    //fill psi_all
    psi_all[i] = psi_all_variables;

    //create subsets
    NumericMatrix a_only_with = select_column_cpp(a, i);
    NumericMatrix b_only_with = select_column_cpp(b, i);

    //compute psi for the column i
    psi_only_with[i] = psi_full_cpp(
      a_only_with,
      b_only_with,
      method,
      diagonal,
      weighted,
      trim_blocks
    );

    //create subsets
    NumericMatrix a_without = delete_column_cpp(a, i);
    NumericMatrix b_without = delete_column_cpp(b, i);

    //compute psi without the column i
    psi_without[i] = psi_full_cpp(
      a_without,
      b_without,
      method,
      diagonal,
      weighted,
      trim_blocks
    );

  }

  // Create output data frame
  return DataFrame::create(
    _["psi_all"] = psi_all,
    _["psi_only_with"] = psi_only_with,
    _["psi_without"] = psi_without
  );

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

ab_names <- intersect(
  x = colnames(a),
  y = colnames(b)
)

b <- b[, ab_names]
a <- a[, ab_names]

ab_importance <- importance_full_cpp(
  a,
  b,
  method = "euclidean",
  diagonal = FALSE,
  weighted = FALSE,
  trim_blocks = FALSE
)

ab_importance

a <- a[1:nrow(b), ]

ab_importance <- importance_paired_cpp(
  a,
  b,
  method = "euclidean"
)

ab_importance
*/
