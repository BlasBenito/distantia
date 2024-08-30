#include <Rcpp.h>
#include "distance_methods.h"
using namespace Rcpp;

//' (C++) Sum Distances Between Consecutive Samples in a Time Series
//' @description Computes the cumulative sum of distances between consecutive
//' samples in a univariate or multivariate time series.
//' NA values should be removed before using this function.
//' @param x (required, numeric matrix) univariate or multivariate time series.
//' @param distance (optional, character string) distance name from the "names"
//' column of the dataset `distances` (see `distances$name`). Default: "euclidean"
//' @return numeric
//' @examples
//' #simulate a time series
//' x <- zoo_simulate()
//'
//' #compute auto distance
//' auto_distance_cpp(
//'   x = x,
//'   distance = "euclidean"
//'   )
//' @export
//' @family Rcpp
// [[Rcpp::export]]
double auto_distance_cpp(
    NumericMatrix x,
    const std::string& distance = "euclidean"
){

  DistanceFunction f = select_distance_function_cpp(distance);

  int x_rows = x.nrow();
  double dist = 0.0;

  for (int i = 0; i < (x_rows - 1); i++) {
    dist += f(x.row(i), x.row(i + 1));
  }

  return dist;

}

//' (C++) Subset Matrix by Rows
//' @description Subsets a time series matrix to the coordinates of a trimmed
//' least-cost path when blocks are ignored during a dissimilarity analysis.
//' @param m (required, numeric matrix) a univariate or multivariate time series.
//' @param rows (required, integer vector) vector of rows to subset from a
//' least-cost path data frame.
//' @return numeric matrix
//' @examples
//' #simulate a time series
//' m <- zoo_simulate(seed = 1)
//'
//' #sample some rows
//' rows <- sample(
//'   x = nrow(m),
//'   size = 10
//'   ) |>
//'   sort()
//'
//' #subset by rows
//' m_subset <- subset_matrix_by_rows_cpp(
//'   m = m,
//'   rows = rows
//'   )
//'
//' #compare with original
//' m[rows, ]
//'
//' @export
//' @family Rcpp
// [[Rcpp::export]]
NumericMatrix subset_matrix_by_rows_cpp(
    NumericMatrix m,
    NumericVector rows
){

  std::vector<int> uniqueRows;
  std::unordered_set<int> seen;

  for (int row : rows) {
    if (seen.insert(row).second) {
      uniqueRows.push_back(row);
   }
 }

  int rl = uniqueRows.size();
  NumericMatrix m_subset(rl, m.ncol());

  int i = 0;
  for (int row : uniqueRows) {
    m_subset(i++, _) = m(row - 1, _);
  }

  return m_subset;
}

//' (C++) Sum Distances Between All Consecutive Samples in Two Time Series
//' @description Computes the cumulative auto sum of autodistances of two time series.
//' The output value is used as normalization factor when computing dissimilarity scores.
//' @param x (required, numeric matrix) univariate or multivariate time series.
//' @param y (required, numeric matrix) univariate or multivariate time series
//' with the same number of columns as 'x'.
//' @param distance (optional, character string) distance name from the "names"
//' column of the dataset `distances` (see `distances$name`). Default: "euclidean"
//' @return numeric
//' @examples
//' #simulate two time series
//' x <- zoo_simulate(seed = 1)
//' y <- zoo_simulate(seed = 2)
//'
//' #auto sum
//' auto_sum_full_cpp(
//'   x = x,
//'   y = y,
//'   distance = "euclidean"
//' )
//' @export
//' @family Rcpp
// [[Rcpp::export]]
double auto_sum_full_cpp(
    NumericMatrix x,
    NumericMatrix y,
    const std::string& distance = "euclidean"
){

  double x_distance = auto_distance_cpp(
    x,
    distance
  );


  double y_distance = auto_distance_cpp(
    y,
    distance
  );

  return x_distance + y_distance;

}


//' (C++) Sum Distances Between All Consecutive Samples in the Least Cost Path Between Two Time Series
//' @description Computes the cumulative auto sum of auto-distances of two time series
//' for the coordinates of a trimmed least cost path. The output value is used
//' as normalization factor when computing dissimilarity scores.
//' @param x (required, numeric matrix) univariate or multivariate time series.
//' @param y (required, numeric matrix) univariate or multivariate time series
//' with the same number of columns as 'x'.
//' @param path (required, data frame) least-cost path produced by [cost_path_orthogonal_cpp()].
//' Default: NULL
//' @param distance (optional, character string) distance name from the "names"
//' column of the dataset `distances` (see `distances$name`). Default: "euclidean".
//' @return numeric
//' @export
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
//' nrow(cost_path)
//'
//' #remove blocks from least-cost path
//' cost_path_trimmed <- cost_path_trim_cpp(
//'   path = cost_path
//' )
//'
//' nrow(cost_path_trimmed)
//'
//' #auto sum
//' auto_sum_path_cpp(
//'   x = x,
//'   y = y,
//'   path = cost_path_trimmed,
//'   distance = "euclidean"
//' )
//' @export
//' @family Rcpp
// [[Rcpp::export]]
double auto_sum_path_cpp(
  NumericMatrix x,
  NumericMatrix y,
  DataFrame path,
  const std::string& distance = "euclidean"
){

  NumericMatrix x_subset = subset_matrix_by_rows_cpp(
    x,
    path["x"]
  );

  double x_distance = auto_distance_cpp(
    x_subset,
    distance
  );


  NumericMatrix y_subset = subset_matrix_by_rows_cpp(
    y,
    path["y"]
    );

  double y_distance = auto_distance_cpp(
    y_subset,
    distance
  );


  return x_distance + y_distance;

}

//' (C++) Sum Distances Between Consecutive Samples in Two Time Series
//' @description Sum of auto-distances of two time series.
//' This function switches between [auto_sum_full_cpp()] and [auto_sum_path_cpp()]
//' depending on the value of the argument `ignore_blocks`.
//' @param x (required, numeric matrix) of same number of columns as 'y'.
//' @param y (required, numeric matrix) of same number of columns as 'x'.
//' @param path (required, data frame) output of [cost_path_orthogonal_cpp()].
//' @param distance (optional, character string) distance name from the "names"
//' column of the dataset `distances` (see `distances$name`). Default: "euclidean"
//' @param ignore_blocks (optional, logical). If TRUE, blocks of consecutive path
//' coordinates are trimmed to avoid inflating the psi distance. Default: FALSE.
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
//' cost_path <- cost_path_orthogonal_cpp(
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
//'
//' #auto sum
//' auto_sum_cpp(
//'   x = x,
//'   y = y,
//'   path = cost_path_trimmed,
//'   distance = "euclidean",
//'   ignore_blocks = FALSE
//' )
//' @export
//' @family Rcpp
// [[Rcpp::export]]
double auto_sum_cpp(
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

 xy_sum = auto_sum_full_cpp(
   x,
   y,
   distance
 );

}

return(xy_sum);

}

// You can include R code blocks in C++ files processed with sourceCpp
// (useful for testing and development). The R code will be automatically
// run after the compilation.
//

/*** R
x <- zoo_simulate()
y <- zoo_simulate()

#testing subset_matrix_by_rows_cpp
a_test <- y[1:4, 1:3]

a_test

subset_matrix_by_rows_cpp(
  a_test, c(1, 3)
  )

a_test[c(1, 3), ]

auto_distance_cpp(
  m = a_test,
  distance = "euclidean"
)

#Testing all functions together

dist_matrix <- distance_matrix_cpp(
  y,
  x,
  distance
)

cost_matrix <- cost_matrix_cpp(
  dist_matrix
)

path <- cost_path_orthogonal_cpp(
  dist_matrix,
  cost_matrix
)

y_subset = subset_matrix_by_rows_cpp(
  y,
  path$y
)

nrow(y)
nrow(y_subset)
ncol(y)
ncol(y_subset)
sum(y)
sum(y_subset)

auto_distance_cpp(
  y,
  distance
)

auto_distance_cpp(
  y_subset,
  distance
)




x_subset = subset_matrix_by_rows_cpp(
  x,
  path$x
)

auto_distance_cpp(
  x,
  distance
)

auto_distance_cpp(
  x_subset,
  distance
)


auto_sum_full_cpp(y, x, distance)

auto_sum_path_cpp(y, x, path, distance)

path_trimmed <- cost_path_trim_cpp(path)

auto_sum_path_cpp(y, x, path_trimmed, distance)

*/
