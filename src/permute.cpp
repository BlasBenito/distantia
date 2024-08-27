#include <Rcpp.h>
#include <random>
using namespace Rcpp;

//' (C++) Restricted Permutation of Complete Rows Within Blocks
//' @description Divides a sequence in blocks of a given size and permutes rows
//' within these blocks.
//' Larger block sizes increasingly disrupt the data structure over time.
//' @param x (required, numeric matrix). Numeric matrix to permute.
//' @param block_size (optional, integer) block size in number of rows.
//' Minimum value is 2, and maximum value is nrow(x).
//' @param seed (optional, integer) random seed to use.
//' @return numeric matrix
//' @family Rcpp
//' @export
// [[Rcpp::export]]
NumericMatrix permute_restricted_by_row_cpp(
    NumericMatrix x,
    int block_size,
    int seed = 1
) {

  NumericMatrix x_ = Rcpp::clone(x);

  int num_rows = x_.nrow();
  int num_cols = x_.ncol();

  // Ensure block_size is not smaller than 2
  if (block_size < 2) {
    block_size = 2; // Set block_size to a minimum value of 2
  }
  if (block_size > num_rows){
    block_size = num_rows; // Set block_size to a maximum value of num_rows
  }

  // Use the integer seed value
  Environment base_env("package:base");
  Function set_seed = base_env["set.seed"];
  set_seed(seed);

  // Iterate over the matrix in blocks and shuffle rows within each block
  for (int i = 0; i < num_rows; i += block_size) {
    int end = std::min(i + block_size, num_rows);
    for (int j = i; j < end - 1; ++j) {

      // Generate a random index within the current block
      int rand_index = j + floor(R::runif(0, end - j));

      // Swap rows to perform the shuffle within the block
      for (int k = 0; k < num_cols; ++k) {
        double temp = x_(j, k);
        x_(j, k) = x_(rand_index, k);
        x_(rand_index, k) = temp;
      }

    }
  }

  return x_;

}


//' (C+++) Unrestricted Permutation of Complete Rows
//' @description Unrestricted shuffling of rows within the whole sequence.
//' @param x (required, numeric matrix). Numeric matrix to permute.
//' @param block_size (optional, integer) this function ignores this argument and sets it to x.nrow().
//' @param seed (optional, integer) random seed to use.
//' @return numeric matrix
//' @family Rcpp
//' @export
// [[Rcpp::export]]
NumericMatrix permute_free_by_row_cpp(
    NumericMatrix x,
    int block_size,
    int seed = 1
){

  NumericMatrix permuted_x = permute_restricted_by_row_cpp(
    x,
    x.nrow(),
    seed
  );

  return(permuted_x);

}


//' (C++) Restricted Permutation of Cases Within Blocks
//' @description Divides a sequence or time series in blocks and permutes cases
//' within these blocks. This function does not preserve rows, and should not be
//' used if the sequence has dependent columns.
//' Larger block sizes increasingly disrupt the data structure over time.
//' @param x (required, numeric matrix). Numeric matrix to permute.
//' @param block_size (optional, integer) block size in number of rows.
//' Minimum value is 2, and maximum value is nrow(x).
//' @param seed (optional, integer) random seed to use.
//' @return numeric matrix
//' @family Rcpp
//' @export
// [[Rcpp::export]]
NumericMatrix permute_restricted_cpp(
    NumericMatrix x,
    int block_size,
    int seed = 1
) {

  NumericMatrix x_ = Rcpp::clone(x);

  int num_rows = x_.nrow();
  int num_cols = x_.ncol();

  // Ensure block_size is not smaller than 2
  if (block_size < 2) {
    block_size = 2; // Set block_size to a minimum value of 2
  }
  if (block_size > num_rows){
    block_size = num_rows; // Set block_size to a maximum value of num_rows
  }

  // Use the integer seed value
  Environment base_env("package:base");
  Function set_seed = base_env["set.seed"];
  set_seed(seed);

  // Iterate over the matrix in blocks and shuffle rows within each block
  for (int i = 0; i < num_rows; i += block_size) {
    int end = std::min(i + block_size, num_rows);
    for (int j = i; j < end - 1; ++j) {

      // Swap rows to perform the shuffle within the block
      for (int k = 0; k < num_cols; ++k) {
        int rand_index = j + floor(R::runif(0, end - j));
        double temp = x_(j, k);
        x_(j, k) = x_(rand_index, k);
        x_(rand_index, k) = temp;
      }

    }
  }

  return x_;

}

//' (C++) Unrestricted Permutation of Cases
//' @description Unrestricted shuffling of cases within the whole sequence.
//' @param x (required, numeric matrix). Numeric matrix to permute.
//' @param block_size (optional, integer) this function ignores this argument and sets it to x.nrow().
//' @param seed (optional, integer) random seed to use.
//' @return numeric matrix
//' @family Rcpp
//' @export
// [[Rcpp::export]]
NumericMatrix permute_free_cpp(
    NumericMatrix x,
    int block_size,
    int seed = 1
){

  NumericMatrix permuted_x = permute_restricted_cpp(
    x,
    x.nrow(),
    seed
  );

  return(permuted_x);

}



//define the type for the distance function
typedef NumericMatrix (*PermutationFunction)(NumericMatrix, int, int);

// Internal function to select a distance function
PermutationFunction select_permutation_function_cpp(const std::string& permutation = "restricted_by_row") {
  if (permutation == "restricted_by_row") {
    return &permute_restricted_by_row_cpp;
  } else if (permutation == "free_by_row") {
    return &permute_free_by_row_cpp;
  } else if (permutation == "restricted") {
    return &permute_restricted_cpp;
  } else if (permutation == "free") {
    return &permute_free_cpp;
  }  else {
    Rcpp::stop("Invalid permutation method. Valid values are: 'free', 'free_by_row', 'restricted', and 'restricted_by_row'");
  }
}




/*** R
# Example usage in R
x <- matrix(
  c(rep(1:6, 2)),
  nrow = 6,
  ncol = 2
  )

x

#checking seed
permute_restricted_by_row_cpp(x, 3, 1)

permute_restricted_by_row_cpp(x, 3, 1)

permute_restricted_by_row_cpp(x, 3, 2)

permute_restricted_cpp(x, 3, 1)

permute_restricted_cpp(x, 3, 1)

permute_restricted_cpp(x, 3, 2)

#free versions
permute_free_by_row_cpp(x, 3, 1)

permute_free_by_row_cpp(x, 3, 1)

permute_free_by_row_cpp(x, 3, 2)

permute_free_cpp(x, 3, 1)

permute_free_cpp(x, 3, 1)

permute_free_cpp(x, 3, 2)


*/
