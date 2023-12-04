#include <Rcpp.h>
using namespace Rcpp;

//' Restricted permutation
//' @description Divides a sequence or time-series in blocks and permutes rows
//' within these blocks. Used to compute p-values for psi distances. Larger block
//' sizes disrupt the time-series structure in the data.
//' @param x (required, numeric matrix). Numeric matrix to permute.
//' @param block_size (optional, integer) block size in number of rows.
//' Minimum value is 2, and maximum value is nrow(x).
//' @param seed (optional, integer) random seed to use.
//' @return Numeric matrix, permuted version of x.
//' @export
// [[Rcpp::export]]
NumericMatrix permute(
    NumericMatrix x,
    int block_size,
    int seed = 1
) {

  int num_rows = x.nrow();
  int num_cols = x.ncol();

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
      int rand_index = rand() % (end - j) + j;

      // Swap rows to perform the shuffle within the block
      for (int k = 0; k < num_cols; ++k) {
        double temp = x(j, k);
        x(j, k) = x(rand_index, k);
        x(rand_index, k) = temp;
      }
    }
  }

  return x;
}


/*** R
# Example usage in R
a <- matrix(
  c(rep(1:6, 1)),
  nrow = 6,
  ncol = 1
  )

a

permute(a, 2)

permute(a, 2)

permute(a, 2)

permute(a, 2)

*/
