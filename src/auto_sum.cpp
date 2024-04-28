#include <Rcpp.h>
#include "distance_methods.h"
using namespace Rcpp;

//' Auto Distance
//' @description Computes the distance matrix between the rows of two matrices
//' \code{y} and \code{x} with the same number of columns and arbitrary numbers of rows.
//' NA values should be removed before using this function.
//' If the selected distance function is [distance_chi_cpp], pairs of zeros should
//' be either removed or replaced with pseudo-zeros (i.e. 0.00001).
//' @param y (required, numeric matrix).
//' @param x (required, numeric matrix) of same number of columns as 'y'.
//' @param distance (optional, character string) name or abbreviation of the
//' distance method. Valid values are in the columns "names" and "abbreviation"
//'  of the dataset `distances`. Default: "euclidean".
//' @return Matrix of distances between 'y' (rows) and 'x' (columns).
//' @export
// [[Rcpp::export]]
double auto_distance_cpp(
    NumericMatrix m,
    const std::string& distance = "euclidean"
){

  DistanceFunction f = select_distance_function_cpp(distance);

  int m_rows = m.nrow();
  double dist = 0.0;

  for (int i = 0; i < (m_rows - 1); i++) {
    dist += f(m.row(i), m.row(i + 1));
  }

  return dist;

}

//' Subset Matrix by Rows
//' @description Subsets the matrix \code{m} to the indices given in the vector \code{rows}.
//' Used to subset a sequence to the coordinates of a trimmed least-cost path.
//' @param m (required, numeric matrix) a sequence.
//' @param rows (required, integer vector) vector of rows to subset.
//' @return Numeric matrix of length rows.
//' @export
// [[Rcpp::export]]
NumericMatrix subset_matrix_by_rows_cpp(
    NumericMatrix m,
    NumericVector rows
){

  std::vector<int> uniqueRows;
  std::unordered_set<int> seen;

  for (int row : rows) {
    if (seen.insert(row).second) { // Check if row is already seen
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

//'Auto Sum of Two Time Series
//' @description Sum of the the cumulative auto-sum of two sequences with paired samples. This is
//' a key component of the psi computation.
//' @param y (required, numeric matrix).
//' @param x (required, numeric matrix) of same number of columns as 'y'.
//' @param distance (optional, character string) name or abbreviation of the
//' distance method. Valid values are in the columns "names" and "abbreviation"
//' of the dataset `distances`. Default: "euclidean".
//' @return Auto sum of distances.
//' @export
// [[Rcpp::export]]
double auto_sum_no_path_cpp(
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


//'Auto-sum of Two Sequences
//' @description Sum of the the cumulative auto-sum of two sequences. This is
//' a key component of the psi computation.
//' @param y (required, numeric matrix).
//' @param x (required, numeric matrix) of same number of columns as 'y'.
//' @param path (required, data frame) dataframe produced by [cost_path()].
//' Default: NULL
//' @param distance (optional, character string) name or abbreviation of the
//' distance method. Valid values are in the columns "names" and "abbreviation"
//' of the dataset `distances`. Default: "euclidean".
//' @return Numeric.
//' @export
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

// You can include R code blocks in C++ files processed with sourceCpp
// (useful for testing and development). The R code will be automatically
// run after the compilation.
//

/*** R
data(sequenceA)
data(sequenceB)
distance = "euclidean"

sequences <- prepare_xy(
  x = na.omit(sequenceB),
  y = na.omit(sequenceA)
)

x <- sequences[[1]]
y <- sequences[[2]]

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

path <- cost_path_cpp(
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


auto_sum_no_path_cpp(y, x, distance)

auto_sum_path_cpp(y, x, path, distance)

path_trimmed <- cost_path_trim_cpp(path)

auto_sum_path_cpp(y, x, path_trimmed, distance)

*/
