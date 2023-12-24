#include <Rcpp.h>
#include "distance_methods.h"
using namespace Rcpp;

//' Least Cost Path
//' @description Computes the least cost matrix from a distance matrix.
//' Considers diagonals during computation of least-costs.
//' @param dist_matrix (required, distance matrix). Distance matrix.
//' @param cost_matrix (required, numeric matrix) Cost matrix generated from the distance matrix.
//' @return A data frame with least-cost path coordiantes.
//' @export
// [[Rcpp::export]]
DataFrame cost_path_cpp(
    NumericMatrix dist_matrix,
    NumericMatrix cost_matrix
){

  int d_rows = dist_matrix.nrow();
  int d_cols = dist_matrix.ncol();

  // Initialize the path vectors
  std::vector<int> path_a;
  std::vector<int> path_b;
  std::vector<double> path_dist;
  std::vector<double> path_cost;

  // Define initial coordinates
  int y = d_rows - 1;
  int x = d_cols - 1;

  // Iterate to find the path
  while (true) {

    // Add current coordinates to the path
    path_a.push_back(y + 1); // Adding 1 to convert from 0-based index to 1-based index
    path_b.push_back(x + 1);
    path_dist.push_back(dist_matrix(y, x));
    path_cost.push_back(cost_matrix(y, x));

    // Find neighbors
    std::vector<int> neighbor_y = {y - 1, y};
    std::vector<int> neighbor_x = {x, x - 1};

    // Find neighbor with minimum cost
    int min_cost_neighbor = -1;
    double min_cost = std::numeric_limits<double>::max();

    for (int i = 0; i < 2; ++i) {
      if (neighbor_y[i] != -1 && neighbor_x[i] != -1) {
        if (cost_matrix(neighbor_y[i], neighbor_x[i]) < min_cost) {
          min_cost = cost_matrix(neighbor_y[i], neighbor_x[i]);
          min_cost_neighbor = i;
        }
      }
    }

    // Check for termination
    if (min_cost_neighbor == -1) {
      break;
    }

    // Update current coordinates
    y = neighbor_y[min_cost_neighbor];
    x = neighbor_x[min_cost_neighbor];
  }

  // Create output data frame
  return DataFrame::create(
    _["a"] = path_a,
    _["b"] = path_b,
    _["dist"] = path_dist,
    _["cost"] = path_cost
  );

}


//' Least Cost Path Considering Diagonals
//' @description Computes the least cost matrix from a distance matrix.
//' Considers diagonals during computation of least-costs.
//' @param dist_matrix (required, distance matrix). Distance matrix.
//' @param cost_matrix (required, numeric matrix) Cost matrix generated from the distance matrix.
//' @return A data frame with least-cost path coordiantes.
//' @export
// [[Rcpp::export]]
DataFrame cost_path_diag_cpp(
    NumericMatrix dist_matrix,
    NumericMatrix cost_matrix
){

  int d_rows = dist_matrix.nrow();
  int d_cols = dist_matrix.ncol();

  // Initialize the path vectors
  std::vector<int> path_a;
  std::vector<int> path_b;
  std::vector<double> path_dist;
  std::vector<double> path_cost;

  // Define initial coordinates
  int y = d_rows - 1;
  int x = d_cols - 1;

  // Iterate to find the path
  while (true) {

    // Add current coordinates to the path
    path_a.push_back(y + 1); // Adding 1 to convert from 0-based index to 1-based index
    path_b.push_back(x + 1);
    path_dist.push_back(dist_matrix(y, x));
    path_cost.push_back(cost_matrix(y, x));

    // Find neighbors
    std::vector<int> neighbor_y = {y-1, y-1, y};
    std::vector<int> neighbor_x = {x, x-1, x-1};

    // Find neighbor with minimum cost
    int min_cost_neighbor = -1;
    double min_cost = std::numeric_limits<double>::max();

    for (int i = 0; i < 3; ++i) {
      if (neighbor_y[i] != -1 && neighbor_x[i] != -1) {
        if (cost_matrix(neighbor_y[i], neighbor_x[i]) < min_cost) {
          min_cost = cost_matrix(neighbor_y[i], neighbor_x[i]);
          min_cost_neighbor = i;
        }
      }
    }

    // Check for termination
    if (min_cost_neighbor == -1) {
      break;
    }

    // Update current coordinates
    y = neighbor_y[min_cost_neighbor];
    x = neighbor_x[min_cost_neighbor];

  }

  // Create output data frame
  return DataFrame::create(
    _["a"] = path_a,
    _["b"] = path_b,
    _["dist"] = path_dist,
    _["cost"] = path_cost
  );

}


//' Trims Blocks from Least Cost Path
//' @param path (required, data frame) dataframe produced by [cost_path()]. Default: NULL
//' @return A data frame with least-cost path coordinates.
//' @export
// [[Rcpp::export]]
DataFrame cost_path_trim_cpp(DataFrame path) {

  NumericVector a = path["a"];
  NumericVector b = path["b"];
  NumericVector dist = path["dist"];
  NumericVector cost = path["cost"];
  LogicalVector keep_a(a.size(), true);
  LogicalVector keep_b(b.size(), true);

  // Mark sequences in 'a'
  for (int i = 1; i < a.size() - 1; ++i) {
    if (a[i] == a[i - 1] && a[i] == a[i + 1]) {
      keep_a[i] = false;
    }
  }

  // Mark sequences in 'b'
  for (int i = 1; i < b.size() - 1; ++i) {
    if (b[i] == b[i - 1] && b[i] == b[i + 1]) {
      keep_b[i] = false;
    }
  }

  LogicalVector keep_final = keep_a & keep_b;

  // Logical indexing to subset the DataFrame
  NumericVector filtered_a = a[keep_final];
  NumericVector filtered_b = b[keep_final];
  NumericVector filtered_dist = dist[keep_final];
  NumericVector filtered_cost = cost[keep_final];

  // Create a new DataFrame with filtered columns
  return DataFrame::create(
    _["a"] = filtered_a,
    _["b"] = filtered_b,
    _["dist"] = filtered_dist,
    _["cost"] = filtered_cost
  );

}


//' Sum of Least Cost Distance Times Two
//' @param path (required, data frame) dataframe produced by [cost_path()]. Default: NULL
//' @return Sum of distances
//' @export
// [[Rcpp::export]]
double cost_path_sum_cpp(
    DataFrame path
){

  NumericVector dist = path["dist"];

  return(sum(dist)*2);

}

// You can include R code blocks in C++ files processed with sourceCpp
// (useful for testing and development). The R code will be automatically
// run after the compilation.
//

/*** R
a <- sequenceA |>
  na.omit() |>
  as.matrix()

b <- sequenceB |>
  na.omit() |>
  as.matrix()

dist_matrix <- distance_matrix(a, b, distance = "euclidean")

cost_matrix <- cost_matrix(dist_matrix = dist_matrix)

message("Computing least cost path without diagonals.")
cost_path <- cost_path_cpp(
  dist_matrix = dist_matrix,
  cost_matrix = cost_matrix
)

head(cost_path)

message("Trimming blocks from least cost path.")
cost_path_trimmed <- cost_path_trim_cpp(path)

nrow(cost_path)
nrow(cost_path_trimmed)

message("Computing least cost path with diagonals")
cost_path_diag <- cost_path_diag_cpp(
  dist_matrix = dist_matrix,
  cost_matrix = cost_matrix
)

head(cost_path_diag)

message("Sum of distances in least cost paths")
cost_path_sum_cpp(cost_path_diag)

*/
