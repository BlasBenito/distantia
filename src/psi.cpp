#include <Rcpp.h>
#include "distance_methods.h"
#include "distance_matrix.h"
#include "cost_matrix.h"
#include "cost_path.h"
#include "auto_sum.h"
#include "permute.h"
using namespace Rcpp;

//' Generates Least Cost Path
//' @description Least cost path between two sequences \code{y} and \code{x}
//' with the same number of columns and arbitrary numbers of rows to compute the
//' ABbetween component of the psi dissimilarity computation.
//' NA values should be removed before using this function.
//' If the selected distance function is "chi" or "cosine", pairs of zeros should
//' be either removed or replaced with pseudo-zeros (i.e. 0.00001).
//' @param x (required, numeric matrix) of same number of columns as 'y'.
//' @param y (required, numeric matrix) of same number of columns as 'x'.
//' @param distance (optional, character string) name or abbreviation of the
//' distance method. Valid values are in the columns "names" and "abbreviation"
//' of the dataset `distances`. Default: "euclidean".
//' @param diagonal (optional, logical). If TRUE, diagonals are included in the
//' computation of the cost matrix. Default: FALSE.
//' @param weighted (optional, logical). If TRUE, diagonal is set to TRUE, and
//' diagonal cost is weighted by y factor of 1.414214. Default: FALSE.
//' @param ignore_blocks (optional, logical). If TRUE, blocks of consecutive path
//' coordinates are trimmed to avoid inflating the psi distance. Default: FALSE.
//' @return Data frame with least cost path
//' @export
// [[Rcpp::export]]
DataFrame psi_cost_path_cpp(
    NumericMatrix x,
    NumericMatrix y,
    const std::string& distance = "euclidean",
    bool diagonal = false,
    bool weighted = false,
    bool ignore_blocks = false
){

  if(weighted){diagonal = true;}

  //distance matrix
  NumericMatrix dist_matrix = distance_matrix_cpp(
    x,
    y,
    distance
  );

  //compute cost matrix
  int yn = dist_matrix.nrow();
  int xn = dist_matrix.ncol();
  NumericMatrix cost_matrix(yn, xn);

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
  if (ignore_blocks){
    cost_path = cost_path_trim_cpp(cost_path);
  }

  return cost_path;

}

//' Auto Sum of Two Sequences
//' @description Cumulative sum times two of two sequences \code{y} and \code{x}
//' with the same number of columns and arbitrary numbers of rows to compute the
//' ABwithin component of the psi dissimilarity computation. This component is
//' used to normalize the least cost distance between the sequences.
//' @param x (required, numeric matrix) of same number of columns as 'y'.
//' @param y (required, numeric matrix) of same number of columns as 'x'.
//' @param path (required, data frame) dataframe produced by [cost_path()].
//' Default: NULL
//' @param distance (optional, character string) name or abbreviation of the
//' distance method. Valid values are in the columns "names" and "abbreviation"
//' of the dataset `distances`. Default: "euclidean".
//' @param ignore_blocks (optional, logical). If TRUE, blocks of consecutive path
//' coordinates are trimmed to avoid inflating the psi distance. Default: FALSE.
//' @return Auto sum of matrices y and x.
//' @export
// [[Rcpp::export]]
double psi_auto_sum_cpp(
    NumericMatrix x,
    NumericMatrix y,
    DataFrame path,
    const std::string& distance = "euclidean",
    bool ignore_blocks = false
){

  double xy_sum = 0;

  //trim cost path
  if (ignore_blocks){

    xy_sum = auto_sum_path_cpp(
      x,
      y,
      path,
      distance
    );

  } else {

    xy_sum = auto_sum_no_path_cpp(
      x,
      y,
      distance
    );

  }

  return(xy_sum);

}

//' Psi Dissimilarity Metric
//' @description Computes the psi dissimilarity score between two sequences from
//' their least cost path and their auto sums.
//' @param path (required, data frame) dataframe produced by [cost_path()].
//' Default: NULL
//' @param auto_sum (required, numeric) auto sum of both sequences,
//' result of [psi_auto_sum_cpp()].
//' @param diagonal (optional, logical). If TRUE, diagonals are included in the
//' computation of the cost matrix. Default: FALSE.
//' @return Numeric, psi dissimilarity
//' @export
// [[Rcpp::export]]
double psi_formula_cpp(
    DataFrame path,
    double auto_sum,
    bool diagonal = false
){

  //sum cost path
  double cost_path_sum = cost_path_sum_cpp(path);

  //compute psi
  double psi_score = (cost_path_sum - auto_sum) / auto_sum;

  //add one if diagonals were used
  if(diagonal){
    psi_score = psi_score + 1;
  }

  return psi_score;

}



//' Computes Psi Distance Between Two Time-Series With Paired Samples
//' @description Computes the distance psi between two matrices
//' \code{y} and \code{x} with the same number of columns and rows. Distances
//' between \code{y} and \code{x} are computed row wise rather than via distance
//' matrix and least-cost path computation.
//' NA values should be removed before using this function.
//' If the selected distance function is "chi" or "cosine", pairs of zeros should
//' be either removed or replaced with pseudo-zeros (i.e. 0.00001).
//' @param x (required, numeric matrix) of same number of columns as 'y'.
//' @param y (required, numeric matrix) of same number of columns as 'x'.
//' @param distance (optional, character string) name or abbreviation of the
//' distance method. Valid values are in the columns "names" and "abbreviation"
//' of the dataset `distances`. Default: "euclidean".
//' @return Psi distance
//' @export
// [[Rcpp::export]]
double psi_lock_step_cpp(
    NumericMatrix x,
    NumericMatrix y,
    const std::string& distance = "euclidean"
){

    //pairwise distances
    double cost_path_sum = distance_lock_step_cpp(
      x,
      y,
      distance
    );

    //auto sum sequences
    double xy_sum = auto_sum_no_path_cpp(
      x,
      y,
      distance
    );

  //compute psi
  return ((cost_path_sum  - xy_sum) / xy_sum) + 1;

}


//' Null Distribution of Psi Distances Between Two Paired Time-Series
//' @description Computes null psi distances for permuted versions of the paired sequences
//' \code{y} and \code{x} with the same number of rows and columns.
//' NA values should be removed before using this function.
//' If the selected distance function is "chi" or "cosine", pairs of zeros should
//' be either removed or replaced with pseudo-zeros (i.e. 0.00001).
//' @param x (required, numeric matrix) of same number of columns as 'y'.
//' @param y (required, numeric matrix) of same number of columns as 'x'.
//' @param distance (optional, character string) name or abbreviation of the
//' distance method. Valid values are in the columns "names" and "abbreviation"
//' of the dataset `distances`. Default: "euclidean".
//' @param repetitions (optional, integer) number of null psi values to generate. Default: 100
//' @param permutation (optional, character) permutation method. Valid values are listed below from higher to lower randomness:
//' \itemize{
//'   \item "free": unrestricted shuffling of rows and columns. Ignores block_size.
//'   \item "free_by_row": unrestricted shuffling of complete rows. Ignores block size.
//'   \item "restricted": restricted shuffling of rows and columns within blocks.
//'   \item "restricted_by_row": restricted shuffling of rows within blocks.
//' }
//' @param block_size (optional, integer) block size in rows for
//' restricted permutation. A block size of 3 indicates that a row can only be permuted
//' within a block of 3 adjacent rows. Minimum value is 2. Default: 3.
//' @param seed (optional, integer) initial random seed to use for replicability. Default: 1
//' @return Numeric vector with null distribution of psi distances.
//' @export
// [[Rcpp::export]]
NumericVector null_psi_lock_step_cpp(
    NumericMatrix x,
    NumericMatrix y,
    const std::string& distance = "euclidean",
    int repetitions = 100,
    const std::string& permutation = "restricted_by_row",
    int block_size = 3,
    int seed = 1
){

  // Select permutation function
  PermutationFunction permutation_function = select_permutation_function_cpp(
    permutation
  );

  // Minimum number of repetitions
  if (repetitions < 2) {
    repetitions = 2;
  }


  // Create numeric vector to store Psi distances
  NumericVector psi_null(repetitions);

  //pairwise distances
  double cost_path_sum = distance_lock_step_cpp(
    x,
    y,
    distance
  );

  //auto sum sequences
  double xy_sum = auto_sum_no_path_cpp(
    x,
    y,
    distance
  );

  //compute psi
  psi_null[0] = ((cost_path_sum  - xy_sum) / xy_sum) + 1;

  // Use the integer seed value
  Environment base_env("package:base");
  Function set_seed = base_env["set.seed"];
  set_seed(seed);

  // Iterate over repetitions
  for (int i = 1; i < repetitions; ++i) {

    // Permute matrix y
    NumericMatrix permuted_y = permutation_function(
      y,
      block_size,
      seed + i
    );

    // Permute matrix x
    NumericMatrix permuted_x = permutation_function(
      x,
      block_size,
      seed + i + 1
    );

    //pairwise distances
    double permuted_ab_distance = distance_lock_step_cpp(
      permuted_y,
      permuted_x,
      distance
    );

    // Compute Psi distance on permuted matrices and store result
    psi_null[i] = ((permuted_ab_distance - xy_sum) / xy_sum) + 1;

  }

  // Return the null distribution vector
  return psi_null;

}


//' Computes Psi Distance Between Two Time-Series
//' @description Computes the distance psi between two matrices
//' \code{y} and \code{x} with the same number of columns and arbitrary numbers of rows.
//' NA values should be removed before using this function.
//' If the selected distance function is "chi" or "cosine", pairs of zeros should
//' be either removed or replaced with pseudo-zeros (i.e. 0.00001).
//' @param y (required, numeric matrix).
//' @param x (required, numeric matrix) of same number of columns as 'y'.
//' @param distance (optional, character string) name or abbreviation of the
//' distance method. Valid values are in the columns "names" and "abbreviation"
//' of the dataset `distances`. Default: "euclidean".
//' @param diagonal (optional, logical). If TRUE, diagonals are included in the
//' computation of the cost matrix. Default: FALSE.
//' @param weighted (optional, logical). If TRUE, diagonal is set to TRUE, and
//' diagonal cost is weighted by a factor of 1.414214. Default: FALSE.
//' @param ignore_blocks (optional, logical). If TRUE, blocks of consecutive path
//' coordinates are trimmed to avoid inflating the psi distance. Default: FALSE.
//' @return Psi distance
//' @export
// [[Rcpp::export]]
double psi_cpp(
    NumericMatrix x,
    NumericMatrix y,
    const std::string& distance = "euclidean",
    bool diagonal = false,
    bool weighted = false,
    bool ignore_blocks = false
){

  DataFrame path = psi_cost_path_cpp(
    x,
    y,
    distance,
    diagonal,
    weighted,
    ignore_blocks
  );

  double xy_sum = psi_auto_sum_cpp(
    x,
    y,
    path,
    distance,
    ignore_blocks
  );

  double psi_score = psi_formula_cpp(
    path,
    xy_sum,
    diagonal
  );

  return psi_score;

}





//' Null Distribution of Psi Distances Between Two Time-Series
//' @description Computes null psi distances for permuted versions of the sequences
//' \code{y} and \code{x} with the same number of columns and arbitrary numbers of rows.
//' NA values should be removed before using this function.
//' If the selected distance function is "chi" or "cosine", pairs of zeros should
//' be either removed or replaced with pseudo-zeros (i.e. 0.00001).
//' @param y (required, numeric matrix).
//' @param x (required, numeric matrix) of same number of columns as 'y'.
//' @param distance (optional, character string) name or abbreviation of the
//' distance method. Valid values are in the columns "names" and "abbreviation"
//' of the dataset `distances`. Default: "euclidean".
//' @param diagonal (optional, logical). If TRUE, diagonals are included in the
//' computation of the cost matrix. Default: FALSE.
//' @param weighted (optional, logical). If TRUE, diagonal is set to TRUE, and
//' diagonal cost is weighted by a factor of 1.414214. Default: FALSE.
//' @param ignore_blocks (optional, logical). If TRUE, blocks of consecutive path
//' coordinates are trimmed to avoid inflating the psi distance. This argument
//' has nothing to do with block_size!. Default: FALSE.
//' @param repetitions (optional, integer) number of null psi values to generate. Default: 100
//' @param permutation (optional, character) permutation method. Valid values are listed below from higher to lower randomness:
//' \itemize{
//'   \item "free": unrestricted shuffling of rows and columns. Ignores block_size.
//'   \item "free_by_row": unrestricted shuffling of complete rows. Ignores block size.
//'   \item "restricted": restricted shuffling of rows and columns within blocks.
//'   \item "restricted_by_row": restricted shuffling of rows within blocks.
//' }
//' @param block_size (optional, integer) block size in rows for
//' restricted permutation. A block size of 3 indicates that a row can only be permuted
//' within a block of 3 adjacent rows. Minimum value is 2. Default: 3.
//' @param seed (optional, integer) initial random seed to use for replicability. Default: 1
//' @return Numeric vector with null distribution of psi distances.
//' @export
// [[Rcpp::export]]
NumericVector null_psi_cpp(
    NumericMatrix x,
    NumericMatrix y,
    const std::string& distance = "euclidean",
    bool diagonal = false,
    bool weighted = false,
    bool ignore_blocks = false,
    int repetitions = 100,
    const std::string& permutation = "restricted_by_row",
    int block_size = 3,
    int seed = 1
){

  // Select permutation function
  PermutationFunction permutation_function = select_permutation_function_cpp(
    permutation
  );

  // Minimum number of repetitions
  if (repetitions < 2) {
    repetitions = 2;
  }

  // Create numeric vector to store Psi distances
  NumericVector psi_null(repetitions);

  // Create cost path
  DataFrame path = psi_cost_path_cpp(
    x,
    y,
    distance,
    diagonal,
    weighted,
    ignore_blocks
  );

  // auto sum of distances to normalize cost path sum
  double xy_sum = psi_auto_sum_cpp(
    x,
    y,
    path,
    distance,
    ignore_blocks
  );

  // Add psi value of original matrices
  psi_null[0] = psi_formula_cpp(
    path,
    xy_sum,
    diagonal
  );

  // Use the integer seed value
  Environment base_env("package:base");
  Function set_seed = base_env["set.seed"];
  set_seed(seed);

  // Iterate over repetitions
  for (int i = 1; i < repetitions; ++i) {

    // Permute matrix x
    NumericMatrix permuted_x = permutation_function(
      x,
      block_size,
      seed + i + 1
    );

    // Permute matrix y
    NumericMatrix permuted_y = permutation_function(
      y,
      block_size,
      seed + i
    );

    // Create cost path of permuted sequences
    DataFrame permuted_path = psi_cost_path_cpp(
      permuted_x,
      permuted_y,
      distance,
      diagonal,
      weighted,
      ignore_blocks
    );

    // Compute Psi distance on permuted matrices and store result
    psi_null[i] = psi_formula_cpp(
      permuted_path,
      xy_sum,
      diagonal
    );

  }

  // Return the null distribution vector
  return psi_null;

}


/*** R
library(distantia)

data(sequenceA)
data(sequenceB)
distance = "euclidean"

sequences <- prepare_xy(
  x = na.omit(sequenceB),
  y = na.omit(sequenceA)
)

x <- sequences[[1]]
y <- sequences[[2]]

psi_cpp(
  x, y
)

null_values <- null_psi_cpp(
  x, y, permutation = "free", seed = 100
)
range(null_values)
mean(null_values)

null_values <- null_psi_cpp(
  x, y, permutation = "free_by_row"
)
range(null_values)
mean(null_values)

null_values <- null_psi_cpp(
  x, y, permutation = "free_by_row"
)
range(null_values)
mean(null_values)

null_values <- null_psi_cpp(
  x, y, permutation = "restricted"
)
range(null_values)
mean(null_values)

null_values <- null_psi_cpp(
  x, y, permutation = "restricted_by_row"
)
range(null_values)
mean(null_values)


*/
