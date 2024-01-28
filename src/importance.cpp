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
    NumericMatrix x,
    NumericMatrix y,
    DataFrame path,
    const std::string& distance = "euclidean"
){

  //Select distance function
  DistanceFunction f = select_distance_function_cpp(distance);

  //separate path in vectors
  NumericVector path_x = path["x"];
  NumericVector path_y = path["y"];
  NumericVector path_dist = path["dist"];
  NumericVector path_cost = path["cost"];

  //count path rows
  int path_rows = path.nrow();

  //iterate over path rows
  for (int i = 0; i < path_rows; i++) {

    //correct between 1-based and 0-based indexing
    int path_x_row = path_x[i] - 1;
    int path_y_row = path_y[i] - 1;

    //distance
    path_dist[i] = f(y.row(path_y_row), x.row(path_x_row));

    //cost
    path_cost[i] = 0;

  }

  // Create a new DataFrame with filtered columns
  return DataFrame::create(
    _["x"] = path_x,
    _["y"] = path_y,
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
DataFrame importance_paired_cpp(
    NumericMatrix x,
    NumericMatrix y,
    const std::string& distance = "euclidean"
){

  // Check dimensions of y and x
  if (y.nrow() != x.nrow() || y.ncol() != x.ncol()) {
    Rcpp::stop("Matrices y and x must have the same dimensions.");
  }

  //vectors to store results
  NumericVector psi_all(y.ncol());
  NumericVector psi_without(y.ncol());
  NumericVector psi_only_with(y.ncol());
  NumericVector psi_drop(y.ncol());
  NumericVector psi_difference(y.ncol());
  NumericVector importance(y.ncol());

  //compute psi with all variables
  double psi_all_variables = psi_paired_cpp(
    x,
    y,
    distance
  );

  //iterate over columns
  for (int i = 0; i < y.ncol(); ++i){

    //fill psi_all
    psi_all[i] = psi_all_variables;

    //create subsets
    NumericMatrix y_only_with = select_column_cpp(y, i);
    NumericMatrix x_only_with = select_column_cpp(x, i);

    //compute psi for the column i
    psi_only_with[i] = psi_paired_cpp(
      y_only_with,
      x_only_with,
      distance
    );

    //create subsets
    NumericMatrix y_without = delete_column_cpp(y, i);
    NumericMatrix x_without = delete_column_cpp(x, i);

    //compute psi without the column i
    psi_without[i] = psi_paired_cpp(
      y_without,
      x_without,
      distance
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
    _["variable"] = colnames(y),
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
//' @description Computes the psi distance between y and x using all columns,
//' with each column, and without each column
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
//' @return Data frame with psi distances
//' @export
// [[Rcpp::export]]
DataFrame importance_cpp(
    NumericMatrix y,
    NumericMatrix x,
    const std::string& distance = "euclidean",
    bool diagonal = false,
    bool weighted = false,
    bool ignore_blocks = false
){

  //vectors to store results
  NumericVector psi_all(y.ncol());
  NumericVector psi_without(y.ncol());
  NumericVector psi_only_with(y.ncol());
  NumericVector psi_drop(y.ncol());
  NumericVector psi_difference(y.ncol());
  NumericVector importance(y.ncol());

  //compute psi with all variables
  double psi_all_variables = psi_cpp(
    x,
    y,
    distance,
    diagonal,
    weighted,
    ignore_blocks
  );

  //iterate over columns
  for (int i = 0; i < y.ncol(); ++i){

    //fill psi_all
    psi_all[i] = psi_all_variables;

    //create subsets
    NumericMatrix x_only_with = select_column_cpp(x, i);
    NumericMatrix y_only_with = select_column_cpp(y, i);

    //compute psi only with the column i
    psi_only_with[i] = psi_cpp(
      x_only_with,
      y_only_with,
      distance,
      diagonal,
      weighted,
      ignore_blocks
    );

    //create subsets
    NumericMatrix x_without = delete_column_cpp(x, i);
    NumericMatrix y_without = delete_column_cpp(y, i);

    //compute psi without the column i
    psi_without[i] = psi_cpp(
      x_without,
      y_without,
      distance,
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
    _["variable"] = colnames(y),
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
//' @param x (required, numeric matrix) of same number of columns as 'y'.
//' @param y (required, numeric matrix) of same number of columns as 'x'.
//' @param distance (optional, character string) name or abbreviation of the
//' distance method. Valid values are in the columns "names" and "abbreviation"
//' of the dataset `distances`. Default: "euclidean".
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
    NumericMatrix x,
    NumericMatrix y,
    const std::string& distance = "euclidean",
    bool diagonal = false,
    bool weighted = false,
    bool ignore_blocks = false
){

  //vectors to store results
  NumericVector psi_all(y.ncol());
  NumericVector psi_only_with(y.ncol());
  NumericVector psi_without(y.ncol());
  NumericVector psi_drop(y.ncol());
  NumericVector psi_difference(y.ncol());
  NumericVector importance(y.ncol());


  //compute psi with all variables
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

  // overall psi distance
  double psi_all_variables = psi_formula_cpp(
    path,
    xy_sum,
    diagonal
  );

  //iterate over columns
  for (int i = 0; i < y.ncol(); ++i){

    //fill psi_all
    psi_all[i] = psi_all_variables;

    //create subsets
    NumericMatrix x_only_with = select_column_cpp(x, i);
    NumericMatrix y_only_with = select_column_cpp(y, i);

    //update dist in path
    DataFrame path_only_with = update_path_dist_cpp(
      x_only_with,
      y_only_with,
      path,
      distance
    );

    //compute autosum of y_only_with and x_only_with for testing
    double xy_sum_only_with = psi_auto_sum_cpp(
      x_only_with,
      y_only_with,
      path,
      distance,
      ignore_blocks
    );

    //compute psi normalizing by the original xy_sum
    psi_only_with[i] = psi_formula_cpp(
      path_only_with,
      xy_sum_only_with,
      diagonal
    );

    //create subsets
    NumericMatrix y_without = delete_column_cpp(y, i);
    NumericMatrix x_without = delete_column_cpp(x, i);

    //update dist in path
    DataFrame path_without = update_path_dist_cpp(
      x_without,
      y_without,
      path,
      distance
    );

    //compute autosum of y_only_with and x_only_with for testing
    double xy_sum_without = psi_auto_sum_cpp(
      x_without,
      y_without,
      path,
      distance,
      ignore_blocks
    );

    //compute psi normalizing by the original xy_sum
    psi_without[i] = psi_formula_cpp(
      path_without,
      xy_sum_without,
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
    _["variable"] = colnames(y),
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
distance = "euclidean"

sequences <- prepare_xy(
  x = na.omit(sequenceB),
  y = na.omit(sequenceA)
)

x <- sequences[[1]]
y <- sequences[[2]]



#failing case
df <- importance_robust_cpp(
  x = x,
  y = y,
  distance = "manhattan",
  diagonal = TRUE,
  weighted = TRUE,
  ignore_blocks = TRUE
)

df <- importance_robust_cpp(
  x = x,
  y = y,
  distance = "manhattan",
  diagonal = TRUE,
  weighted = TRUE,
  ignore_blocks = TRUE
)

df <- importance_robust_cpp(
  x = x,
  y = y,
  distance = "manhattan",
  diagonal = TRUE,
  weighted = TRUE,
  ignore_blocks = TRUE
)

df <- importance_robust_cpp(
  x = x,
  y = y,
  distance = "manhattan",
  diagonal = TRUE,
  weighted = TRUE,
  ignore_blocks = TRUE
)

#testing update_path_dist_cpp
########################################
path = psi_cost_path_cpp(
  x,
  y
)

path_update = update_path_dist_cpp(
  x,
  y,
  path
)

path_update = update_path_dist_cpp(
  x[, 1, drop = FALSE],
  y[, 1, drop = FALSE],
  path
)


#overall psi value
psi_cpp(x, y)

#old importance
importance_vintage <- importance_cpp(
  x,
  y
)

importance_vintage

#new importance
importance_robust <- importance_robust_cpp(
  x,
  y
)

importance_robust

#paired
y <- y[1:nrow(x), ]

importance_paired <- importance_paired_cpp(
  x,
  y
)

importance_paired
*/
