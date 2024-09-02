#include <Rcpp.h>
#include "distance_methods.h"
#include "distance_matrix.h"
#include "cost_path.h"
#include "auto_sum.h"
#include "permute.h"
using namespace Rcpp;



//' (C++) Computation of the Psi Dissimilarity Score
//' @description Computes the psi dissimilarity score between two time series from
//' their least cost path sum and their auto sums.
//' @param path_sum (required, numeric) output of [cost_path_sum_cpp()] on a least cost path.
//' @param auto_sum (required, numeric) auto sum of both sequences,
//' result of [auto_sum_cpp()].
//' @param diagonal (optional, logical). If TRUE, diagonals are included in the
//' computation of the cost matrix. Default: FALSE.
//' @return numeric
//' @family Rcpp
//' @export
// [[Rcpp::export]]
double psi_formula_cpp(
    double path_sum,
    double auto_sum,
    bool diagonal = true
){

  //compute psi
  double psi_score = ((path_sum * 2) / auto_sum) - 1;

  //add one if diagonals were used
  if(diagonal){
    psi_score = psi_score + 1;
  }

  return psi_score;

}



//' (C++) Psi Dissimilarity Score of Two Aligned Time Series
//' @description Computes the psi dissimilarity score between two time series
//' observed at the same times. Time series \code{y} and \code{x} with the same
//' number of columns and rows. NA values should be removed before using this function.
//' If the selected distance function is "chi" or "cosine", pairs of zeros should
//' be either removed or replaced with pseudo-zeros (i.e. 0.00001).
//' @param x (required, numeric matrix) of same number of columns as 'y'.
//' @param y (required, numeric matrix) of same number of columns as 'x'.
//' @param distance (optional, character string) distance name from the "names"
//' column of the dataset `distances` (see `distances$name`). Default: "euclidean".
//' @return numeric
//' @family Rcpp
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
    double xy_sum = auto_sum_full_cpp(
      x,
      y,
      distance
    );

  //compute psi
  return ((cost_path_sum  - xy_sum) / xy_sum) + 1;

}


//' (C++) Null Distribution of the Dissimilarity Scores of Two Aligned Time Series
//' @description Applies permutation methods to compute null distributions for
//' the psi scores of two time series observed at the same times.
//' NA values should be removed before using this function.
//' If the selected distance function is "chi" or "cosine", pairs of zeros should
//' be either removed or replaced with pseudo-zeros (i.e. 0.00001).
//' @param x (required, numeric matrix) of same number of columns as 'y'.
//' @param y (required, numeric matrix) of same number of columns as 'x'.
//' @param distance (optional, character string) distance name from the "names"
//' column of the dataset `distances` (see `distances$name`). Default: "euclidean".
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
//' @return numeric vector
//' @family Rcpp
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
  double xy_sum = auto_sum_full_cpp(
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


//' (C++) Psi Dissimilarity Score of Two Time-Series
//' @description Computes the psi score of two time series \code{y} and \code{x}
//' with the same number of columns.
//' NA values should be removed before using this function.
//' If the selected distance function is "chi" or "cosine", pairs of zeros should
//' be either removed or replaced with pseudo-zeros (i.e. 0.00001).
//' @param y (required, numeric matrix).
//' @param x (required, numeric matrix) of same number of columns as 'y'.
//' @param distance (optional, character string) distance name from the "names"
//' column of the dataset `distances` (see `distances$name`). Default: "euclidean".
//' @param diagonal (optional, logical). If TRUE, diagonals are included in the
//' computation of the cost matrix. Default: FALSE.
//' @param weighted (optional, logical). If TRUE, diagonal is set to TRUE, and
//' diagonal cost is weighted by a factor of 1.414214. Default: FALSE.
//' @param ignore_blocks (optional, logical). If TRUE, blocks of consecutive path
//' coordinates are trimmed to avoid inflating the psi distance. Default: FALSE.
//' @return numeric
//' @family Rcpp
//' @export
// [[Rcpp::export]]
double psi_cpp(
    NumericMatrix x,
    NumericMatrix y,
    const std::string& distance = "euclidean",
    bool diagonal = true,
    bool weighted = true,
    bool ignore_blocks = false
){

  DataFrame path = cost_path_cpp(
    x,
    y,
    distance,
    diagonal,
    weighted,
    ignore_blocks
  );

  double path_sum = cost_path_sum_cpp(path);

  double xy_sum = auto_sum_cpp(
    x,
    y,
    path,
    distance,
    ignore_blocks
  );

  double psi_score = psi_formula_cpp(
    path_sum,
    xy_sum,
    diagonal
  );

  return psi_score;

}





//' (C++) Null Distribution of Dissimilarity Scores of Two Time Series
//' @description Applies permutation methods to compute null distributions for
//' the psi scores of two time series.
//' NA values should be removed before using this function.
//' If the selected distance function is "chi" or "cosine", pairs of zeros should
//' be either removed or replaced with pseudo-zeros (i.e. 0.00001).
//' @param y (required, numeric matrix).
//' @param x (required, numeric matrix) of same number of columns as 'y'.
//' @param distance (optional, character string) distance name from the "names"
//' column of the dataset `distances` (see `distances$name`). Default: "euclidean".
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
//' @return numeric vector
//' @family Rcpp
//' @export
// [[Rcpp::export]]
NumericVector null_psi_cpp(
    NumericMatrix x,
    NumericMatrix y,
    const std::string& distance = "euclidean",
    bool diagonal = true,
    bool weighted = true,
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
  DataFrame path = cost_path_cpp(
    x,
    y,
    distance,
    diagonal,
    weighted,
    ignore_blocks
  );

  double path_sum = cost_path_sum_cpp(path);

  // auto sum of distances to normalize cost path sum
  double xy_sum = auto_sum_cpp(
    x,
    y,
    path,
    distance,
    ignore_blocks
  );

  // Add psi value of original matrices
  psi_null[0] = psi_formula_cpp(
    path_sum,
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
      seed + i
    );

    // Permute matrix y
    NumericMatrix permuted_y = permutation_function(
      y,
      block_size,
      seed + i + 1
    );

    // Create cost path of permuted sequences
    DataFrame permuted_path = cost_path_cpp(
      permuted_x,
      permuted_y,
      distance,
      diagonal,
      weighted,
      ignore_blocks
    );

    double permuted_path_sum = cost_path_sum_cpp(permuted_path);

    // Compute Psi distance on permuted matrices and store result
    psi_null[i] = psi_formula_cpp(
      permuted_path_sum,
      xy_sum,
      diagonal
    );

  }

  // Return the null distribution vector
  return psi_null;

}


/*** R

library(distantia)
x <- zoo_simulate()
y <- zoo_simulate()

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
