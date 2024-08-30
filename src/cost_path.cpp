#include <Rcpp.h>
#include "distance_methods.h"
#include "distance_matrix.h"
#include "cost_matrix.h"
using namespace Rcpp;

//' (C++) Least Cost Path for Sequence Slotting
//' @description Computes a least-cost matrix from a distance matrix.
//' This version differs from [cost_path_orthogonal_cpp()] in the way it solves ties.
//' In the case of a tie, [cost_path_orthogonal_cpp()] uses the first neighbor satisfying
//' the minimum distance condition, while this function selects the neighbor
//' that changes the axis of movement within the least-cost matrix. This function
//' is not used anywhere within the package, but was left here for future reference.
//' @param dist_matrix (required, numeric matrix). Distance matrix between two
//' time series.
//' @param cost_matrix (required, numeric matrix). Least-cost matrix generated from
//' `dist_matrix`.
//' @return data frame
//' @examples
//' #simulate two time series
//' x <- zoo_simulate(seed = 1)
//' y <- zoo_simulate(seed = 2)
//'
//' #distance matrix
//' dist_matrix <- distance_matrix_cpp(
//'   x = x,
//'   y = y,
//'   distance = "euclidean"
//' )
//'
//' #least cost matrix
//' cost_matrix <- cost_matrix_cpp(
//'   dist_matrix = dist_matrix
//' )
//'
//' #least cost path
//' cost_path <- cost_path_slotting_cpp(
//'   dist_matrix = dist_matrix,
//'   cost_matrix = cost_matrix
//' )
//'
//' cost_path
//' @export
//' @family Rcpp
// [[Rcpp::export]]
DataFrame cost_path_slotting_cpp(
    NumericMatrix dist_matrix,
    NumericMatrix cost_matrix
){

  int d_rows = dist_matrix.nrow();
  int d_cols = dist_matrix.ncol();

  // Initialize the path vectors
  std::vector<int> path_x;
  std::vector<int> path_y;
  std::vector<double> path_dist;
  std::vector<double> path_cost;

  // Define initial coordinates
  int y = d_rows - 1;
  int x = d_cols - 1;

  // Index of path_y and path_x
  int i = -1;

  // Iterate to find the path
  while (true) {

    // Add current coordinates to the path
    // Adding 1 to convert from 0-based index to 1-based index
    path_y.push_back(y + 1);
    path_x.push_back(x + 1);
    path_dist.push_back(dist_matrix(y, x));
    path_cost.push_back(cost_matrix(y, x));

    // declare neighbors
    std::vector<int> neighbor_y = {y - 1, y};
    std::vector<int> neighbor_x = {x, x - 1};

    // Increase index
    i += 1;

    if(i > 1){

      // Modify order of neighbors if there are repeated indices
      //in the rows axis
      if(path_y[i] == path_y[i-1]){

        neighbor_y = {y, y - 1};
        neighbor_x = {x - 1, x};

      }

      // Modify order of neighbors if there are repeated indices
      //in the columns axis
      if(path_x[i] == path_x[i-1]){

        neighbor_y = {y - 1, y};
        neighbor_x = {x, x - 1};

      }

    }

    // Find neighbor with minimum cost
    int min_cost_neighbor = -1;
    double min_cost = std::numeric_limits<double>::max();

    for (int j = 0; j < 2; ++j) {
      if (neighbor_y[j] != -1 && neighbor_x[j] != -1) {
        if (cost_matrix(neighbor_y[j], neighbor_x[j]) < min_cost) {
          min_cost = cost_matrix(neighbor_y[j], neighbor_x[j]);
          min_cost_neighbor = j;
        }
      }
    }

    // Check for termination
    if (min_cost_neighbor == -1) {
      break;
    }

    // Update current coordinates
    x = neighbor_x[min_cost_neighbor];
    y = neighbor_y[min_cost_neighbor];


  }

  // Create output data frame
  return DataFrame::create(
    _["x"] = path_x,
    _["y"] = path_y,
    _["dist"] = path_dist,
    _["cost"] = path_cost
  );

}

//' (C++) Find Orthogonal Least Cost Path within a Least Cost Matrix
//' @description
//' Computes an orthogonal least-cost path within a cost matrix. Each steps within
//' the least-cost path either moves in the x or the y direction, but never diagonally.
//' @param dist_matrix (required, numeric matrix). Distance matrix between two
//' time series.
//' @param cost_matrix (required, numeric matrix). Cost matrix generated from
//' `dist_matrix`.
//' @return data frame
//' @examples
//' #simulate two time series
//' x <- zoo_simulate(seed = 1)
//' y <- zoo_simulate(seed = 2)
//'
//' #distance matrix
//' dist_matrix <- distance_matrix_cpp(
//'   x = x,
//'   y = y,
//'   distance = "euclidean"
//' )
//'
//' #least cost matrix
//' cost_matrix <- cost_matrix_cpp(
//'   dist_matrix = dist_matrix
//' )
//'
//' #least cost path
//' cost_path <- cost_path_orthogonal_cpp(
//'   dist_matrix = dist_matrix,
//'   cost_matrix = cost_matrix
//' )
//'
//' cost_path
//' @export
//' @family Rcpp
// [[Rcpp::export]]
DataFrame cost_path_orthogonal_cpp(
    NumericMatrix dist_matrix,
    NumericMatrix cost_matrix
){

  int d_rows = dist_matrix.nrow();
  int d_cols = dist_matrix.ncol();

  // Initialize the path vectors
  std::vector<int> path_x;
  std::vector<int> path_y;
  std::vector<double> path_dist;
  std::vector<double> path_cost;

  // Define initial coordinates
  int x = d_cols - 1;
  int y = d_rows - 1;


  // Iterate to find the path
  while (true) {

    // Add current coordinates to the path
    // Adding 1 to convert from 0-based index to 1-based index
    path_x.push_back(x + 1);
    path_y.push_back(y + 1);
    path_dist.push_back(dist_matrix(y, x));
    path_cost.push_back(cost_matrix(y, x));

    // declare neighbors
    std::vector<int> neighbor_x = {x, x - 1};
    std::vector<int> neighbor_y = {y - 1, y};

    // Find neighbor with minimum cost
    int min_cost_neighbor = -1;
    double min_cost = std::numeric_limits<double>::max();

    for (int j = 0; j < 2; ++j) {
      if (neighbor_y[j] != -1 && neighbor_x[j] != -1) {
        if (cost_matrix(neighbor_y[j], neighbor_x[j]) < min_cost) {
          min_cost = cost_matrix(neighbor_y[j], neighbor_x[j]);
          min_cost_neighbor = j;
        }
      }
    }

    // Check for termination
    if (min_cost_neighbor == -1) {
      break;
    }

    // Update current coordinates
    x = neighbor_x[min_cost_neighbor];
    y = neighbor_y[min_cost_neighbor];

  }

  // Create output data frame
  return DataFrame::create(
    _["x"] = path_x,
    _["y"] = path_y,
    _["dist"] = path_dist,
    _["cost"] = path_cost
  );

}


//' (C++) Find Orthogonal And Diagonal Least Cost Path within a Least Cost Matrix
//' @description Computes the least cost matrix from a distance matrix.
//' Considers diagonals during computation of least-costs. In case of ties,
//' diagonals are favored.
//' @param dist_matrix (required, numeric matrix). Distance matrix between two
//' time series.
//' @param cost_matrix (required, numeric matrix). Cost matrix generated from
//' `dist_matrix`.
//' @return data frame
//' @examples
//' #simulate two time series
//' x <- zoo_simulate(seed = 1)
//' y <- zoo_simulate(seed = 2)
//'
//' #distance matrix
//' dist_matrix <- distance_matrix_cpp(
//'   x = x,
//'   y = y,
//'   distance = "euclidean"
//' )
//'
//' #least cost matrix
//' cost_matrix <- cost_matrix_cpp(
//'   dist_matrix = dist_matrix
//' )
//'
//' #least cost path
//' cost_path <- cost_path_diagonal_cpp(
//'   dist_matrix = dist_matrix,
//'   cost_matrix = cost_matrix
//' )
//'
//' cost_path
//' @export
//' @family Rcpp
// [[Rcpp::export]]
DataFrame cost_path_diagonal_cpp(
    NumericMatrix dist_matrix,
    NumericMatrix cost_matrix
){

  int d_rows = dist_matrix.nrow();
  int d_cols = dist_matrix.ncol();

  // Initialize the path vectors
  std::vector<int> path_x;
  std::vector<int> path_y;
  std::vector<double> path_dist;
  std::vector<double> path_cost;

  // Define initial coordinates
  int x = d_cols - 1;
  int y = d_rows - 1;

  // Iterate to find the path
  while (true) {

    // Add current coordinates to the path
    path_x.push_back(x + 1);
    path_y.push_back(y + 1); // Adding 1 to convert from 0-based index to 1-based index
    path_dist.push_back(dist_matrix(y, x));
    path_cost.push_back(cost_matrix(y, x));

    // Find neighbors
    std::vector<int> neighbor_x = {x-1, x, x-1};
    std::vector<int> neighbor_y = {y-1, y-1, y};

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
    x = neighbor_x[min_cost_neighbor];
    y = neighbor_y[min_cost_neighbor];

  }

  // Create output data frame
  return DataFrame::create(
    _["x"] = path_x,
    _["y"] = path_y,
    _["dist"] = path_dist,
    _["cost"] = path_cost
  );

}


//' (C++) Remove Blocks from a Least Cost Path
//' @param path (required, data frame) least-cost path produced by [cost_path_orthogonal_cpp()].
//' @return data frame
//' @examples
//' #simulate two time series
//' x <- zoo_simulate(seed = 1)
//' y <- zoo_simulate(seed = 2)
//'
//' #distance matrix
//' dist_matrix <- distance_matrix_cpp(
//'   x = x,
//'   y = y,
//'   distance = "euclidean"
//' )
//'
//' #least cost matrix
//' cost_matrix <- cost_matrix_cpp(
//'   dist_matrix = dist_matrix
//' )
//'
//' #least cost path
//' cost_path <- cost_path_slotting_cpp(
//'   dist_matrix = dist_matrix,
//'   cost_matrix = cost_matrix
//' )
//'
//' nrow(cost_path)
//'
//' #remove blocks from least-cost path
//' cost_path_trimmed <- cost_path_trim_cpp(
//'   path = cost_path
//' )
//'
//' nrow(cost_path_trimmed)
//' @export
//' @family Rcpp
// [[Rcpp::export]]
DataFrame cost_path_trim_cpp(DataFrame path) {

  NumericVector x = path["x"];
  NumericVector y = path["y"];
  NumericVector dist = path["dist"];
  NumericVector cost = path["cost"];
  LogicalVector keep_y(y.size(), true);
  LogicalVector keep_x(x.size(), true);

  // Mark sequences in 'y'
  for (int i = 1; i < y.size() - 1; ++i) {
    if (y[i] == y[i - 1] && y[i] == y[i + 1]) {
      keep_y[i] = false;
    }
  }

  // Mark sequences in 'x'
  for (int i = 1; i < x.size() - 1; ++i) {
    if (x[i] == x[i - 1] && x[i] == x[i + 1]) {
      keep_x[i] = false;
    }
  }

  LogicalVector keep_final = keep_y & keep_x;

  // Logical indexing to subset the DataFrame
  NumericVector filtered_x = x[keep_final];
  NumericVector filtered_y = y[keep_final];
  NumericVector filtered_dist = dist[keep_final];
  NumericVector filtered_cost = cost[keep_final];

  // Create a new DataFrame with filtered columns
  return DataFrame::create(
    _["x"] = filtered_x,
    _["y"] = filtered_y,
    _["dist"] = filtered_dist,
    _["cost"] = filtered_cost
  );

}


//' (C++) Sum Distances in a Least Cost Path
//' @param path (required, data frame) least-cost path produced by [cost_path_orthogonal_cpp()].
//' @return numeric
//' @examples
//' #simulate two time series
//' x <- zoo_simulate(seed = 1)
//' y <- zoo_simulate(seed = 2)
//'
//' #distance matrix
//' dist_matrix <- distance_matrix_cpp(
//'   x = x,
//'   y = y,
//'   distance = "euclidean"
//' )
//'
//' #least cost matrix
//' cost_matrix <- cost_matrix_cpp(
//'   dist_matrix = dist_matrix
//' )
//'
//' #least cost path
//' cost_path <- cost_path_slotting_cpp(
//'   dist_matrix = dist_matrix,
//'   cost_matrix = cost_matrix
//' )
//'
//' cost_path_sum_cpp(
//'   path = cost_path
//'   )
//' @export
//' @family Rcpp
// [[Rcpp::export]]
double cost_path_sum_cpp(
    DataFrame path
){

  NumericVector dist = path["dist"];

  return(sum(dist)*2);

}


//' Find Least Cost Path within a Least Cost Matrix
//' @description Least cost path between two time series \code{x} and \code{y}.
//' NA values must be removed from \code{x} and \code{y} before using this function.
//' If the selected distance function is "chi" or "cosine", pairs of zeros should
//' be either removed or replaced with pseudo-zeros (i.e. 0.00001).
//' @param x (required, numeric matrix) multivariate time series.
//' @param y (required, numeric matrix) multivariate time series
//' with the same number of columns as 'x'.
//' @param distance (optional, character string) distance name from the "names"
//' column of the dataset `distances` (see `distances$name`). Default: "euclidean".
//' @param diagonal (optional, logical). If TRUE, diagonals are included in the
//' computation of the cost matrix. Default: FALSE.
//' @param weighted (optional, logical). If TRUE, diagonal is set to TRUE, and
//' diagonal cost is weighted by y factor of 1.414214. Default: FALSE.
//' @param ignore_blocks (optional, logical). If TRUE, blocks of consecutive path
//' coordinates are trimmed to avoid inflating the psi distance. Default: FALSE.
//' @return data frame
//' @export
//' @family Rcpp
// [[Rcpp::export]]
DataFrame cost_path_cpp(
   NumericMatrix x,
   NumericMatrix y,
   const std::string& distance = "euclidean",
   bool diagonal = true,
   bool weighted = true,
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
   cost_path = cost_path_diagonal_cpp(dist_matrix, cost_matrix);
 } else {
   cost_path = cost_path_orthogonal_cpp(dist_matrix, cost_matrix);
 }

 //trim cost path
 if (ignore_blocks){
   cost_path = cost_path_trim_cpp(cost_path);
 }

 return cost_path;

}

// You can include R code blocks in C++ files processed with sourceCpp
// (useful for testing and development). The R code will be automatically
// run after the compilation.
//

/*** R
library(distantia)

y <- sequenceA |>
  na.omit() |>
  as.matrix()

x <- sequenceB |>
  na.omit() |>
  as.matrix()

dist_matrix <- distance_matrix_cpp(x, y, distance = "euclidean")

cost_matrix <- cost_matrix_cpp(dist_matrix = dist_matrix)

cost_path <- cost_path_orthogonal_cpp(
  dist_matrix = dist_matrix,
  cost_matrix = cost_matrix
)

cost_path_slotting <- cost_path_slotting_cpp(
  dist_matrix = dist_matrix,
  cost_matrix = cost_matrix
)

head(cost_path)

message("Trimming blocks from least cost path.")
cost_path_trimmed <- cost_path_trim_cpp(cost_path)

nrow(cost_path)
nrow(cost_path_trimmed)

message("Computing least cost path with diagonals")
cost_path_diag <- cost_path_diagonal_cpp(
  dist_matrix = dist_matrix,
  cost_matrix = cost_matrix
)

head(cost_path_diag)

message("Sum of distances in least cost paths")
cost_path_sum_cpp(cost_path_diag)

*/
