#include <Rcpp.h>
using namespace Rcpp;
#include "distance_methods.h"
#include "auto_sum.h"
#include "cost_path.h"
#include "psi.h"


// Internal function to update distances in a least-cost path.
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

// Extracts column from time series for importance computation
// [[Rcpp::export]]
NumericMatrix select_column_cpp(
    NumericMatrix x,
    int column_index
    ) {

  NumericMatrix x_ = Rcpp::clone(x);

  int rows = x_.nrow();

  NumericMatrix result(rows, 1);

  for (int i = 0; i < rows; ++i) {
    result(i, 0) = x_(i, column_index);
  }

  return result;
}

// Deletes column from numeric matrix for importance computation
// [[Rcpp::export]]
NumericMatrix delete_column_cpp(
    NumericMatrix x,
    int column_index
    ) {

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


//' (C++) Contribution of Individual Variables to the Dissimilarity Between Two Aligned Time Series
//' @description Computes the contribution of individual variables to the
//' similarity/dissimilarity between two aligned multivariate time series.
//' This function generates a data frame with the following columns:
//' \itemize{
//'   \item variable: name of the individual variable for which the importance
//'   is being computed, from the column names of the arguments `x` and `y`.
//'   \item psi: global dissimilarity score `psi` of the two time series.
//'   \item psi_only_with: dissimilarity between `x` and `y` computed from the given variable alone.
//'   \item psi_without: dissimilarity between `x` and `y` computed from all other variables.
//'   \item psi_difference: difference between `psi_only_with` and `psi_without`.
//'   \item importance: contribution of the variable to the similarity/dissimilarity
//'   between `x` and `y`, computed as `(psi_difference * 100) / psi_all`.
//'   Positive scores represent contribution to dissimilarity,
//'   while negative scores represent contribution to similarity.
//' }
//' @param x (required, numeric matrix) multivariate time series.
//' @param y (required, numeric matrix) multivariate time series
//' with the same number of columns and rows as 'x'.
//' @param distance (optional, character string) distance name from the "names"
//' column of the dataset `distances` (see `distances$name`). Default: "euclidean".
//' @return data frame
//' @examples
//' #simulate two regular time series
//' x <- zoo_simulate(
//'   seed = 1,
//'   irregular = FALSE
//'   )
//'
//' y <- zoo_simulate(
//'   seed = 2,
//'   irregular = FALSE
//'   )
//'
//' #same number of rows
//' nrow(x) == nrow(y)
//'
//' #compute importance
//' df <- importance_lock_step_cpp(
//'   x = x,
//'   y = y,
//'   distance = "euclidean"
//' )
//'
//' df
//' @family Rcpp
//' @export
// [[Rcpp::export]]
DataFrame importance_lock_step_cpp(
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
  NumericVector psi_difference(y.ncol());
  NumericVector importance(y.ncol());

  //compute psi with all variables
  double psi_all_variables = psi_lock_step_cpp(
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
    psi_only_with[i] = psi_lock_step_cpp(
      y_only_with,
      x_only_with,
      distance
    );

    //create subsets
    NumericMatrix y_without = delete_column_cpp(y, i);
    NumericMatrix x_without = delete_column_cpp(x, i);

    //compute psi without the column i
    psi_without[i] = psi_lock_step_cpp(
      y_without,
      x_without,
      distance
    );

    //difference between only with and without
    psi_difference[i] = psi_only_with[i] - psi_without[i];

    //importance as percentage of psi
    importance[i] = (psi_difference[i] * 100) / psi_all_variables;


  }

  // Create output data frame
  return DataFrame::create(
    _["variable"] = colnames(y),
    _["psi"] = psi_all,
    _["psi_only_with"] = psi_only_with,
    _["psi_without"] = psi_without,
    _["psi_difference"] = psi_difference,
    _["importance"] = importance
  );

}

//' (C++) Contribution of Individual Variables to the Dissimilarity Between Two Time Series (Legacy Version)
//' @description Computes the contribution of individual variables to the
//' similarity/dissimilarity between two irregular multivariate time series.
//' In opposition to the robust version, least-cost paths for each combination
//' of variables are computed independently, which makes the results of individual
//' variables harder to compare. This function should only be used when the objective is
//' replicating importance scores generated with previous versions of the package `distantia`.
//' This function generates a data frame with the following columns:
//' \itemize{
//'   \item variable: name of the individual variable for which the importance
//'   is being computed, from the column names of the arguments `x` and `y`.
//'   \item psi: global dissimilarity score `psi` of the two time series.
//'   \item psi_only_with: dissimilarity between `x` and `y` computed from the given variable alone.
//'   \item psi_without: dissimilarity between `x` and `y` computed from all other variables.
//'   \item psi_difference: difference between `psi_only_with` and `psi_without`.
//'   \item importance: contribution of the variable to the similarity/dissimilarity
//'   between `x` and `y`, computed as `((psi_all - psi_without) * 100) / psi_all`.
//'   Positive scores represent contribution to dissimilarity,
//'   while negative scores represent contribution to similarity.
//' }
//' @param x (required, numeric matrix) multivariate time series.
//' @param y (required, numeric matrix) multivariate time series
//' with the same number of columns as 'x'.
//' @param distance (optional, character string) distance name from the "names"
//' column of the dataset `distances` (see `distances$name`). Default: "euclidean".
//' @param diagonal (optional, logical). If TRUE, diagonals are included in the
//' computation of the cost matrix. Default: FALSE.
//' @param weighted (optional, logical). If TRUE, diagonal is set to TRUE, and
//' diagonal cost is weighted by a factor of 1.414214. Default: FALSE.
//' @param ignore_blocks (optional, logical). If TRUE, blocks of consecutive path
//' coordinates are trimmed to avoid inflating the psi distance. Default: FALSE.
//' @return data frame
//' @examples
//' #simulate two regular time series
//' x <- zoo_simulate(
//'   seed = 1,
//'   rows = 100
//'   )
//'
//' y <- zoo_simulate(
//'   seed = 2,
//'   rows = 150
//'   )
//'
//' #different number of rows
//' #this is not a requirement though!
//' nrow(x) == nrow(y)
//'
//' #compute importance
//' df <- importance_dynamic_time_warping_legacy_cpp(
//'   x = x,
//'   y = y,
//'   distance = "euclidean"
//' )
//'
//' df
//' @family Rcpp
//' @export
// [[Rcpp::export]]
DataFrame importance_dynamic_time_warping_legacy_cpp(
    NumericMatrix y,
    NumericMatrix x,
    const std::string& distance = "euclidean",
    bool diagonal = false,
    bool weighted = true,
    bool ignore_blocks = false
){

  //vectors to store results
  NumericVector psi_all(y.ncol());
  NumericVector psi_without(y.ncol());
  NumericVector psi_only_with(y.ncol());
  NumericVector psi_difference(y.ncol());
  NumericVector importance(y.ncol());

  //compute psi with all variables
  double psi_all_variables = psi_dynamic_time_warping_cpp(
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
    psi_only_with[i] = psi_dynamic_time_warping_cpp(
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
    psi_without[i] = psi_dynamic_time_warping_cpp(
      x_without,
      y_without,
      distance,
      diagonal,
      weighted,
      ignore_blocks
    );

    //difference between only with and without
    psi_difference[i] = psi_only_with[i] - psi_without[i];

    //psi drop when removing a variable
    importance[i] = ((psi_all_variables - psi_without[i]) * 100) / psi_all_variables;

  }

  // Create output data frame
  return DataFrame::create(
    _["variable"] = colnames(y),
    _["psi"] = psi_all,
    _["psi_only_with"] = psi_only_with,
    _["psi_without"] = psi_without,
    _["psi_difference"] = psi_difference,
    _["importance"] = importance
  );

}


//' (C++) Contribution of Individual Variables to the Dissimilarity Between Two Time Series (Robust Version)
//' @description Computes the contribution of individual variables to the
//' similarity/dissimilarity between two irregular multivariate time series.
//' In opposition to the legacy version, importance computation is
//' performed taking the least-cost path of the whole sequence as reference. This
//' operation makes the importance scores of individual variables fully comparable.
//' This function generates a data frame with the following columns:
//' \itemize{
//'   \item variable: name of the individual variable for which the importance
//'   is being computed, from the column names of the arguments `x` and `y`.
//'   \item psi: global dissimilarity score `psi` of the two time series.
//'   \item psi_only_with: dissimilarity between `x` and `y` computed from the given variable alone.
//'   \item psi_without: dissimilarity between `x` and `y` computed from all other variables.
//'   \item psi_difference: difference between `psi_only_with` and `psi_without`.
//'   \item importance: contribution of the variable to the similarity/dissimilarity
//'   between `x` and `y`, computed as `(psi_difference * 100) / psi_all`.
//'   Positive scores represent contribution to dissimilarity,
//'   while negative scores represent contribution to similarity.
//' }
//' @param x (required, numeric matrix) multivariate time series.
//' @param y (required, numeric matrix) multivariate time series
//' with the same number of columns as 'x'.
//' @param distance (optional, character string) distance name from the "names"
//' column of the dataset `distances` (see `distances$name`). Default: "euclidean".
//' @param diagonal (optional, logical). If TRUE, diagonals are included in the
//' computation of the cost matrix. Default: TRUE.
//' @param weighted (optional, logical). If TRUE, diagonal is set to TRUE, and
//' diagonal cost is weighted by a factor of 1.414214. Default: TRUE.
//' @param ignore_blocks (optional, logical). If TRUE, blocks of consecutive path
//' coordinates are trimmed to avoid inflating the psi distance. Default: FALSE.
//' @return data frame
//' @examples
//' #simulate two regular time series
//' x <- zoo_simulate(
//'   seed = 1,
//'   rows = 100
//'   )
//'
//' y <- zoo_simulate(
//'   seed = 2,
//'   rows = 150
//'   )
//'
//' #different number of rows
//' #this is not a requirement though!
//' nrow(x) == nrow(y)
//'
//' #compute importance
//' df <- importance_dynamic_time_warping_robust_cpp(
//'   x = x,
//'   y = y,
//'   distance = "euclidean"
//' )
//'
//' df
//' @family Rcpp
//' @export
// [[Rcpp::export]]
DataFrame importance_dynamic_time_warping_robust_cpp(
    NumericMatrix x,
    NumericMatrix y,
    const std::string& distance = "euclidean",
    bool diagonal = true,
    bool weighted = true,
    bool ignore_blocks = false
){

  //vectors to store results
  NumericVector psi_all(y.ncol());
  NumericVector psi_only_with(y.ncol());
  NumericVector psi_without(y.ncol());
  NumericVector psi_difference(y.ncol());
  NumericVector importance(y.ncol());


  //compute psi with all variables
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

  // overall psi distance
  double psi_all_variables = psi_equation_cpp(
    path_sum,
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

    double path_only_with_sum = cost_path_sum_cpp(path_only_with);

    //compute autosum of y_only_with and x_only_with
    double xy_sum_only_with = auto_sum_cpp(
      x_only_with,
      y_only_with,
      path,
      distance,
      ignore_blocks
    );

    //compute psi
    psi_only_with[i] = psi_equation_cpp(
      path_only_with_sum,
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

    double path_without_sum = cost_path_sum_cpp(path_without);

    //compute autosum of y_without and x_without
    double xy_sum_without = auto_sum_cpp(
      x_without,
      y_without,
      path,
      distance,
      ignore_blocks
    );

    //compute psi
    psi_without[i] = psi_equation_cpp(
      path_without_sum,
      xy_sum_without,
      diagonal
    );

    //difference between only with and without
    psi_difference[i] = psi_only_with[i] - psi_without[i];

    //psi drop as a percentage of psi_all_variables
    importance[i] = (psi_difference[i] * 100) / psi_all_variables;

  }

  // Create output data frame
  return DataFrame::create(
    _["variable"] = colnames(y),
    _["psi"] = psi_all,
    _["psi_only_with"] = psi_only_with,
    _["psi_without"] = psi_without,
    _["psi_difference"] = psi_difference,
    _["importance"] = importance
  );

}


/*** R
library(distantia)

x <- zoo_simulate()
y <- zoo_simulate()

df <- importance_dynamic_time_warping_robust_cpp(
  x = x,
  y = y,
  distance = "manhattan"
)

#testing update_path_dist_cpp
########################################
path = cost_path_cpp(
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
psi_dynamic_time_warping_cpp(x, y)

#old importance
importance_vintage <- importance_dynamic_time_warping_legacy_cpp(
  x,
  y
)

importance_vintage

#new importance
importance_robust <- importance_dynamic_time_warping_robust_cpp(
  x,
  y
)

importance_robust

#lock step
importance_lock_step <- importance_lock_step_cpp(
  x,
  y
)

importance_lock_step
*/
