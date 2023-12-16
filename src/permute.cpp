#include <Rcpp.h>
#include <random>
using namespace Rcpp;

//' Restricted Permutation by Blocks
//' @description Divides a matrix in blocks of a given size and permutes rows
//' within these blocks. Used to compute null distributions for psi distances.
//' Larger block sizes increasingly disrupt data structure over time.
//' @param x (required, numeric matrix). Numeric matrix to permute.
//' @param block_size (optional, integer) block size in number of rows.
//' Minimum value is 2, and maximum value is nrow(x).
//' @param seed (optional, integer) random seed to use.
//' @return Numeric matrix, permuted version of x.
//' @export
// [[Rcpp::export]]
NumericMatrix permute_cpp(
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
  std::srand(seed);

  // Iterate over the matrix in blocks and shuffle rows within each block
  for (int i = 0; i < num_rows; i += block_size) {
    int end = std::min(i + block_size, num_rows);
    for (int j = i; j < end - 1; ++j) {

      // Generate a random index within the current block
      int rand_index = std::rand() % (end - j) + j;

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


//' Restricted Permutation by Blocks and Columns
//' @description Divides a sequence or time-series in blocks and permutes cases
//' within these blocks, but independently by column.
//' Used to compute p-values for psi distances when columns are independent.
//' Larger block sizes increasingly disrupt data structure over time.
//' @param x (required, numeric matrix). Numeric matrix to permute.
//' @param block_size (optional, integer) block size in number of rows.
//' Minimum value is 2, and maximum value is nrow(x).
//' @param seed (optional, integer) random seed to use.
//' @return Numeric matrix, permuted version of x.
//' @export
// [[Rcpp::export]]
NumericMatrix permute_independent_cpp(
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
  std::srand(seed);

  // Iterate over the matrix in blocks and shuffle rows within each block
  for (int i = 0; i < num_rows; i += block_size) {
    int end = std::min(i + block_size, num_rows);
    for (int j = i; j < end - 1; ++j) {

      // Swap rows to perform the shuffle within the block
      for (int k = 0; k < num_cols; ++k) {
        int rand_index = std::rand() % (end - j) + j;
        double temp = x_(j, k);
        x_(j, k) = x_(rand_index, k);
        x_(rand_index, k) = temp;
      }

    }
  }

  return x_;

}



/*** R
# Example usage in R
a <- matrix(
  c(rep(1:6, 2)),
  nrow = 6,
  ncol = 2
  )

a

permute_cpp(a, 6, 2)

permute_cpp(a, 3, 1)

permute_cpp(a, 3, 2)

permute_cpp(a, 3, 2)

permute_independent_cpp(a, 3, 1)

permute_independent_cpp(a, 3, 2)

permute_independent_cpp(a, 3, 3)

permute_independent_cpp(a, 3, 4)

*/
