#include <Rcpp.h>
#include "distance_methods.h"
#include "distance_matrix.h"
#include "cost_matrix.h"
#include "cost_path.h"
#include "auto_sum.h"
#include "permute.h"
using namespace Rcpp;


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
double psi_paired_cpp(
    NumericMatrix a,
    NumericMatrix b,
    Rcpp::Nullable<std::string> method
){

    //pairwise distances
    NumericVector dist_vector = distance_pairwise_cpp(
      a,
      b,
      method
    );

    double cost_path_sum = sum(dist_vector);

    //auto sum sequences
    double ab_sum = auto_sum_no_path_cpp(
      a,
      b,
      method
    );


  //compute psi
  return ((cost_path_sum * 2) - ab_sum) / ab_sum;

}

//' Computes Psi Distance Between Two Time-Series
//' @description Computes the distance psi between two matrices
//' \code{a} and \code{b} with the same number of columns and arbitrary numbers of rows.
//' NA values should be removed before using this function.
//' If the selected distance function is "chi" or "cosine", pairs of zeros should
//' be either removed or replaced with pseudo-zeros (i.e. 0.00001).
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
//' @return Psi distance
//' @export
// [[Rcpp::export]]
double psi_full_cpp(
    NumericMatrix a,
    NumericMatrix b,
    Rcpp::Nullable<std::string> method,
    bool diagonal = false,
    bool weighted = false,
    bool trim_blocks = false
){

  if(weighted){diagonal = true;}

  //distance matrix
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
  if (trim_blocks){
    cost_path = cost_path_trim_cpp(cost_path);
  }

  //sum cost path
  double cost_path_sum = cost_path_sum_cpp(cost_path);

  //auto sum sequences
  double ab_sum = auto_sum_path_cpp(
    a,
    b,
    cost_path,
    method
  );

  //compute psi
  return ((cost_path_sum * 2) - ab_sum) / ab_sum;

}



//' Computes Null Distribution of Psi Distances Between Two Time-Series With Paired Samples
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
//' @param block_size (optional, integer vector) vector with block sizes for the
//' restricted permutation. A block size of 3 indicates that a row can only be permuted
//' within a block of 3 adjacent rows. Default: c(2, 3, 4).
//' @param seed (optional, integer) initial random seed to use for replicability. Default: 1
//' @param repetitions (optional, integer) number of null psi values to generate. Default: 100
//' @return Psi distance
//' @export
// [[Rcpp::export]]
NumericVector null_psi_paired_cpp(
    NumericMatrix a,
    NumericMatrix b,
    Rcpp::Nullable<std::string> method,
    IntegerVector block_size = IntegerVector::create(2, 3, 4),
    int seed = 1,
    int repetitions = 100
){

  // Calculate the minimum number of rows between matrices a and b
  int min_rows = std::min(a.nrow(), b.nrow());

  // Adjust block_size to ensure it doesn't exceed the minimum number of rows
  block_size = block_size[block_size <= min_rows];

  // Create numeric vector to store Psi distances
  NumericVector psi_null(repetitions);

  // Add psi value of original matrices
  psi_null[0] = psi_paired_cpp(a, b, method);

  // Iterate over repetitions
  for (int i = 1; i < repetitions; ++i) {

    //new seed
    int seed_i = seed + i;

    // Use the integer seed value
    std::srand(seed);

    // Select a block size
    int block_size_i = block_size[rand() % block_size.size()];

    // Permute matrix a
    NumericMatrix permuted_a = permute(
      a,
      block_size_i,
      seed_i
    );

    // Permute matrix b
    NumericMatrix permuted_b = permute(
      b,
      block_size_i,
      seed_i + 1
    );

    // Compute Psi distance on permuted matrices and store result
    psi_null[i] = psi_paired_cpp(
      permuted_a,
      permuted_b,
      method
      );

  }

  // Return the null distribution vector
  return psi_null;

}


//' Computes Psi Distance Between Two Time-Series
//' @description Computes the distance psi between two matrices
//' \code{a} and \code{b} with the same number of columns and arbitrary numbers of rows.
//' NA values should be removed before using this function.
//' If the selected distance function is "chi" or "cosine", pairs of zeros should
//' be either removed or replaced with pseudo-zeros (i.e. 0.00001).
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
//' coordinates are trimmed to avoid inflating the psi distance. This argument
//' has nothing to do with block_size!. Default: FALSE.
//' @param block_size (optional, integer vector) vector with block sizes for the
//' restricted permutation. A block size of 3 indicates that a row can only be permuted
//' within a block of 3 adjacent rows. Default: c(2, 3, 4).
//' @param seed (optional, integer) initial random seed to use for replicability. Default: 1
//' @param repetitions (optional, integer) number of null psi values to generate. Default: 100
//' @return Psi distance
//' @export
// [[Rcpp::export]]
NumericVector null_psi_full_cpp(
    NumericMatrix a,
    NumericMatrix b,
    Rcpp::Nullable<std::string> method,
    bool diagonal = false,
    bool weighted = false,
    bool trim_blocks = false,
    IntegerVector block_size = IntegerVector::create(2, 3, 4),
    int seed = 1,
    int repetitions = 100
){

  // Calculate the minimum number of rows between matrices a and b
  int min_rows = std::min(a.nrow(), b.nrow());

  // Adjust block_size to ensure it doesn't exceed the minimum number of rows
  block_size = block_size[block_size <= min_rows];

  // Create numeric vector to store Psi distances
  NumericVector psi_null(repetitions);

  // Add psi value of original matrices
  psi_null[0] = psi_full_cpp(
    a,
    b,
    method,
    diagonal,
    weighted,
    trim_blocks
    );

  // Iterate over repetitions
  for (int i = 1; i < repetitions; ++i) {

    //new seed
    int seed_i = seed + i;

    // Use the integer seed value
    std::srand(seed);

    // Select a block size
    int block_size_i = block_size[rand() % block_size.size()];

    // Permute matrix a
    NumericMatrix permuted_a = permute(
      a,
      block_size_i,
      seed_i
    );

    // Permute matrix b
    NumericMatrix permuted_b = permute(
      b,
      block_size_i,
      seed_i + 1
    );

    // Compute Psi distance on permuted matrices and store result
    psi_null[i] = psi_full_cpp(
      permuted_a,
      permuted_b,
      method,
      diagonal,
      weighted,
      trim_blocks
      );

  }

  // Return the null distribution vector
  return psi_null;

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

psi_full_cpp(
  a = a,
  b = b,
  method = "euclidean",
  diagonal = TRUE,
  weighted = TRUE,
  trim_blocks = TRUE
)

psi_full_cpp(
  a = a,
  b = b,
  method = "euclidean",
  diagonal = FALSE,
  weighted = TRUE,
  trim_blocks = TRUE
)

psi_full_cpp(
  a = a,
  b = b,
  method = "euclidean",
  diagonal = FALSE,
  weighted = FALSE,
  trim_blocks = FALSE
)

psi_full_cpp(
  a = a,
  b = b,
  method = "euclidean",
  diagonal = TRUE,
  weighted = FALSE,
  trim_blocks = TRUE
)

psi_full_cpp(
  a = a,
  b = b,
  method = "euclidean",
  diagonal = FALSE,
  weighted = FALSE,
  trim_blocks = TRUE
)

a <- a[1:nrow(b), ]

psi_paired_cpp(
  a = a,
  b = b,
  method = "euclidean"
)

null_psi_paired_cpp(
  a,
  b,
  method = "euclidean",
  block_size = 3:5,
  seed = 1,
  repetitions = 9
)

null_psi_paired_cpp(
  a,
  b,
  method = "euclidean",
  block_size = 3:5,
  seed = 1,
  repetitions = 9
)

null_psi_paired_cpp(
  a,
  b,
  method = "euclidean",
  block_size = 3:5,
  seed = 2,
  repetitions = 9
)

null_psi_paired_cpp(
  a,
  b,
  method = "euclidean",
  block_size = 3:5,
  seed = 2,
  repetitions = 9
)

null_psi_full_cpp(
  a,
  b,
  method = "euclidean",
  block_size = 3:5,
  seed = 1,
  repetitions = 9
)

null_psi_full_cpp(
  a,
  b,
  method = "euclidean",
  block_size = 3:5,
  seed = 1,
  repetitions = 9
)

null_psi_full_cpp(
  a,
  b,
  method = "euclidean",
  block_size = 3:5,
  seed = 2,
  repetitions = 9
)

null_psi_full_cpp(
  a,
  b,
  method = "euclidean",
  block_size = 3:5,
  seed = 2,
  repetitions = 9
)



*/
