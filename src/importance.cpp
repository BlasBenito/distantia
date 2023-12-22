#include <Rcpp.h>
using namespace Rcpp;
#include "psi.h"
#include "cost_path.h"
#include "distance_methods.h"


// [[Rcpp::export]]
NumericVector reverse_vector_cpp(NumericVector x) {
  std::reverse(x.begin(), x.end());
  return x;
}

//' @export
// [[Rcpp::export]]
DataFrame update_path_dist_cpp(
    NumericMatrix a,
    NumericMatrix b,
    DataFrame path,
    const std::string& method = "euclidean"
){

  //Select distance function
  DistanceFunction f = select_distance_function_cpp(method);

  //separate path in vectors
  NumericVector path_a = path["a"];
  NumericVector path_b = path["b"];
  NumericVector path_dist = path["dist"];
  NumericVector path_cost = path["cost"];

  //count path rows
  int path_rows = path.nrow();

  //iterate over path rows
  for (int i = 0; i < path_rows; i++) {

    //correct between 1-based and 0-based indexing
    int path_a_row = path_a[i] - 1;
    int path_b_row = path_b[i] - 1;

    //distance
    path_dist[i] = f(a.row(path_a_row), b.row(path_b_row));

    //cost
    path_cost[i] = 0;

  }

  // Create a new DataFrame with filtered columns
  return DataFrame::create(
    _["a"] = path_a,
    _["b"] = path_b,
    _["dist"] = path_dist,
    _["cost"] = path_cost
  );

}

// Function to extract one column from the matrix x
// [[Rcpp::export]]
NumericMatrix select_column_cpp(NumericMatrix x, int column_index) {

  NumericMatrix x_ = Rcpp::clone(x);

  int rows = x_.nrow();

  NumericMatrix result(rows, 1);

  for (int i = 0; i < rows; ++i) {
    result(i, 0) = x_(i, column_index);
  }

  return result;
}

//function to remove one column from the matrix x
// [[Rcpp::export]]
NumericMatrix delete_column_cpp(NumericMatrix x, int column_index) {

  NumericMatrix x_ = Rcpp::clone(x);

  NumericMatrix result(x_.nrow(), x_.ncol() - 1);

  for (int j = 0; j < x_.nrow(); ++j) {
    for (int k = 0, l = 0; k < x_.ncol(); ++k) {
      if (k != column_index) {
        result(j, l) = x_(j, k);
        ++l;
      }
    }
  }

  return result;

}


//' Contribution of Individual Columns to Overall Psi Distance for Paired Sequences
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
    const std::string& method = "euclidean"
){

  // Check dimensions of a and b
  if (a.nrow() != b.nrow() || a.ncol() != b.ncol()) {
    Rcpp::stop("Matrices a and b must have the same dimensions.");
  }

  //vectors to store results
  NumericVector psi_all(a.ncol());
  NumericVector psi_without(a.ncol());
  NumericVector psi_only_with(a.ncol());
  NumericVector psi_drop(a.ncol());
  NumericVector psi_difference(a.ncol());
  NumericVector importance(a.ncol());

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

    //difference between only with and without
    psi_difference[i] = psi_only_with[i] - psi_without[i];

    //importance as percentage of psi
    importance[i] = (psi_difference[i] * 100) / psi_all_variables;

    //psi drop when removing a variable
    psi_drop[i] = ((psi_all_variables - psi_without[i]) * 100) / psi_all_variables;


  }

  // Create output data frame
  return DataFrame::create(
    _["variable"] = colnames(a),
    _["psi"] = psi_all,
    _["psi_only_with"] = psi_only_with,
    _["psi_without"] = psi_without,
    _["psi_difference"] = psi_difference,
    _["psi_drop"] = psi_drop,
    _["importance"] = importance
  );

}

//' Classic Computation of Variable Importance
//' @description Returns the contribution of each variable to the overall dissimilarity
//' of two sequences. In opposition to the robust version, least-cost paths for each combination
//' of variables are computed independently. To compute importance,
//' the function first computes the psi distance dissimilarity between seuqences
//' using all columns ("psi"), with each column separately ("psi_only_with"),
//' and without each column ("psi_without). Then, it computes "psi_difference" as
//' psi_only_with - psi_without. Highest positive values in this column represent the
//' variables that better explain the dissimilarity between the sequences.
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
//' @param ignore_blocks (optional, logical). If TRUE, blocks of consecutive path
//' coordinates are trimmed to avoid inflating the psi distance. Default: FALSE.
//' @return Data frame with psi distances
//' @export
// [[Rcpp::export]]
DataFrame importance_cpp(
    NumericMatrix a,
    NumericMatrix b,
    const std::string& method = "euclidean",
    bool diagonal = false,
    bool weighted = false,
    bool ignore_blocks = false
){

  //vectors to store results
  NumericVector psi_all(a.ncol());
  NumericVector psi_without(a.ncol());
  NumericVector psi_only_with(a.ncol());
  NumericVector psi_drop(a.ncol());
  NumericVector psi_difference(a.ncol());
  NumericVector importance(a.ncol());

  //compute psi with all variables
  double psi_all_variables = psi_cpp(
    a,
    b,
    method,
    diagonal,
    weighted,
    ignore_blocks
  );

  //iterate over columns
  for (int i = 0; i < a.ncol(); ++i){

    //fill psi_all
    psi_all[i] = psi_all_variables;

    //create subsets
    NumericMatrix a_only_with = select_column_cpp(a, i);
    NumericMatrix b_only_with = select_column_cpp(b, i);

    //compute psi only with the column i
    psi_only_with[i] = psi_cpp(
      a_only_with,
      b_only_with,
      method,
      diagonal,
      weighted,
      ignore_blocks
    );

    //create subsets
    NumericMatrix a_without = delete_column_cpp(a, i);
    NumericMatrix b_without = delete_column_cpp(b, i);

    //compute psi without the column i
    psi_without[i] = psi_cpp(
      a_without,
      b_without,
      method,
      diagonal,
      weighted,
      ignore_blocks
    );

    //difference between only with and without
    psi_difference[i] = psi_only_with[i] - psi_without[i];

    //importance as percentage of psi
    importance[i] = (psi_difference[i] * 100) / psi_all_variables;

    //psi drop when removing a variable
    psi_drop[i] = ((psi_all_variables - psi_without[i]) * 100) / psi_all_variables;

  }

  // Create output data frame
  return DataFrame::create(
    _["variable"] = colnames(a),
    _["psi"] = psi_all,
    _["psi_only_with"] = psi_only_with,
    _["psi_without"] = psi_without,
    _["psi_difference"] = psi_difference,
    _["psi_drop"] = psi_drop,
    _["importance"] = importance
  );

}


//' Robust Computation of Variable Importance
//' @description Returns the contribution of each variable to the overall dissimilarity
//' of two sequences. In opposition to the classic version, importance computation is
//' performed over the least-cost path of the whole sequence. To compute importance,
//' the function first computes the psi distance dissimilarity between seuqences
//'  using all columns ("psi"), with each column separately ("psi_only_with"),
//'  and without each column ("psi_without). Then, it computes "psi_difference" as
//' psi_only_with - psi_without. Highest positive values highlight the variables that
//' better explain the dissimilarity between the sequences.
//' @param a (required, numeric matrix).
//' @param b (required, numeric matrix) of same number of columns as 'a'.
//' @param method (optional, character string) name or abbreviation of the
//' distance method. Valid values are in the columns "names" and "abbreviation"
//' of the dataset `methods`. Default: "euclidean".
//' @param diagonal (optional, logical). If TRUE, diagonals are included in the
//' computation of the cost matrix. Default: FALSE.
//' @param weighted (optional, logical). If TRUE, diagonal is set to TRUE, and
//' diagonal cost is weighted by a factor of 1.414214. Default: FALSE.
//' @param ignore_blocks (optional, logical). If TRUE, blocks of consecutive path
//' coordinates are trimmed to avoid inflating the psi distance. Default: FALSE.
//' @return Data frame with psi distances
//' @export
// [[Rcpp::export]]
DataFrame importance_robust_cpp(
    NumericMatrix a,
    NumericMatrix b,
    const std::string& method = "euclidean",
    bool diagonal = false,
    bool weighted = false,
    bool ignore_blocks = false
){

  //vectors to store results
  NumericVector psi_all(a.ncol());
  NumericVector psi_only_with(a.ncol());
  NumericVector psi_without(a.ncol());
  NumericVector psi_drop(a.ncol());
  NumericVector psi_difference(a.ncol());
  NumericVector importance(a.ncol());


  //compute psi with all variables
  DataFrame path = psi_cost_path_cpp(
    a,
    b,
    method,
    diagonal,
    weighted,
    ignore_blocks
  );

  // auto sum of distances to normalize cost path sum
  double ab_sum = psi_auto_sum_cpp(
    a,
    b,
    path,
    method,
    ignore_blocks
  );

  // overall psi distance
  double psi_all_variables = psi_formula_cpp(
    path,
    ab_sum,
    diagonal
  );

  //iterate over columns
  for (int i = 0; i < a.ncol(); ++i){

    //fill psi_all
    psi_all[i] = psi_all_variables;

    //create subsets
    NumericMatrix a_only_with = select_column_cpp(a, i);
    NumericMatrix b_only_with = select_column_cpp(b, i);

    //update dist in path
    DataFrame path_only_with = update_path_dist_cpp(
      a_only_with,
      b_only_with,
      path,
      method
    );

    //compute autosum of a_only_with and b_only_with for testing
    double ab_sum_only_with = psi_auto_sum_cpp(
      a_only_with,
      b_only_with,
      path,
      method,
      ignore_blocks
    );

    //compute psi normalizing by the original ab_sum
    psi_only_with[i] = psi_formula_cpp(
      path_only_with,
      ab_sum_only_with,
      diagonal
    );

    //create subsets
    NumericMatrix a_without = delete_column_cpp(a, i);
    NumericMatrix b_without = delete_column_cpp(b, i);

    //update dist in path
    DataFrame path_without = update_path_dist_cpp(
      a_without,
      b_without,
      path,
      method
    );

    //compute autosum of a_only_with and b_only_with for testing
    double ab_sum_without = psi_auto_sum_cpp(
      a_without,
      b_without,
      path,
      method,
      ignore_blocks
    );

    //compute psi normalizing by the original ab_sum
    psi_without[i] = psi_formula_cpp(
      path_without,
      ab_sum_without,
      diagonal
    );

    //difference between only with and without
    psi_difference[i] = psi_only_with[i] - psi_without[i];

    //psi drop as a percentage of psi_alll_variables
    importance[i] = (psi_difference[i] * 100) / psi_all_variables;

    //psi drop when removing a variable
    psi_drop[i] = ((psi_all_variables - psi_without[i]) * 100) / psi_all_variables;


  }

  // Create output data frame
  return DataFrame::create(
    _["variable"] = colnames(a),
    _["psi"] = psi_all,
    _["psi_only_with"] = psi_only_with,
    _["psi_without"] = psi_without,
    _["psi_difference"] = psi_difference,
    _["psi_drop"] = psi_drop,
    _["importance"] = importance
  );

}


/*** R
library(distantia)

data(sequenceA)
data(sequenceB)
method = "euclidean"

sequences <- prepareSequences(
  sequence.A = sequenceA,
  sequence.B = sequenceB,
  merge.mode = "overlap",
  if.empty.cases = "omit",
  transformation = "hellinger"
)

a <- sequences |>
  dplyr::filter(
    id == "A"
  ) |>
  dplyr::select(-id) |>
  as.matrix()

b <- sequences |>
  dplyr::filter(
    id == "B"
  ) |>
  dplyr::select(-id) |>
  as.matrix()

#failing case
df <- importance_robust_cpp(
  a = a,
  b = b,
  method = "manhattan",
  diagonal = TRUE,
  weighted = TRUE,
  ignore_blocks = TRUE
)

df <- importance_robust_cpp(
  a = a,
  b = b,
  method = "manhattan",
  diagonal = TRUE,
  weighted = TRUE,
  ignore_blocks = TRUE
)

df <- importance_robust_cpp(
  a = a,
  b = b,
  method = "manhattan",
  diagonal = TRUE,
  weighted = TRUE,
  ignore_blocks = TRUE
)

df <- importance_robust_cpp(
  a = a,
  b = b,
  method = "manhattan",
  diagonal = TRUE,
  weighted = TRUE,
  ignore_blocks = TRUE
)

#testing update_path_dist_cpp
########################################
path = psi_cost_path_cpp(
  a,
  b
);

path_update = update_path_dist_cpp(
  a,
  b,
  path
)

path_update = update_path_dist_cpp(
  a[, 1, drop = FALSE],
  b[, 1, drop = FALSE],
  path
)


#overall psi value
psi_cpp(a, b)

#old importance
importance_vintage <- importance_cpp(
  a,
  b
)

importance_vintage

#new importance
importance_robust <- importance_robust_cpp(
  a,
  b
)

importance_robust

#paired
a <- a[1:nrow(b), ]

importance_paired <- importance_paired_cpp(
  a,
  b
)

importance_paired
*/
