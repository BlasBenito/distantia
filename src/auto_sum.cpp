#include <Rcpp.h>
#include "distance_methods.h"
using namespace Rcpp;

//' Auto Distance
//' @description Computes the distance matrix between the rows of two matrices
//' \code{a} and \code{b} with the same number of columns and arbitrary numbers of rows.
//' NA values should be removed before using this function.
//' If the selected distance function is [distance_chi_cpp], pairs of zeros should
//' be either removed or replaced with pseudo-zeros (i.e. 0.00001).
//' @param a (required, numeric matrix).
//' @param b (required, numeric matrix) of same number of columns as 'a'.
//' @param method (optional, character string) name or abbreviation of the
//' distance method. Valid values are in the columns "names" and "abbreviation"
//'  of the dataset `methods`. Default: "euclidean".
//' @return Matrix of distances between 'a' (rows) and 'b' (columns).
//' @export
// [[Rcpp::export]]
double auto_distance_cpp(
    NumericMatrix m,
    Rcpp::Nullable<std::string> method
){

  std::string selected_method = Rcpp::as<std::string>(method);
  DistanceFunction f = distance_function(selected_method);

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

//'Auto-sum of Two Paired Sequences
//' @description Sum of the the cumulative auto-sum of two sequences with paired samples. This is
//' a key component of the psi computation.
//' @param a (required, numeric matrix).
//' @param b (required, numeric matrix) of same number of columns as 'a'.
//' @param method (optional, character string) name or abbreviation of the
//' distance method. Valid values are in the columns "names" and "abbreviation"
//' of the dataset `methods`. Default: "euclidean".
//' @return Numeric.
//' @export
// [[Rcpp::export]]
double auto_sum_no_path_cpp(
    NumericMatrix a,
    NumericMatrix b,
    Rcpp::Nullable<std::string> method
){

  //working with a
  double a_distance = auto_distance_cpp(
    a,
    method
  );

  //working with b
  double b_distance = auto_distance_cpp(
    b,
    method
  );

  return a_distance + b_distance;

}


//'Auto-sum of Two Sequences
//' @description Sum of the the cumulative auto-sum of two sequences. This is
//' a key component of the psi computation.
//' @param a (required, numeric matrix).
//' @param b (required, numeric matrix) of same number of columns as 'a'.
//' @param path (required, data frame) dataframe produced by [cost_path()].
//' Default: NULL
//' @param method (optional, character string) name or abbreviation of the
//' distance method. Valid values are in the columns "names" and "abbreviation"
//' of the dataset `methods`. Default: "euclidean".
//' @return Numeric.
//' @export
// [[Rcpp::export]]
double auto_sum_path_cpp(
  NumericMatrix a,
  NumericMatrix b,
  DataFrame path,
  Rcpp::Nullable<std::string> method
){

  //working with a
  NumericMatrix a_subset = subset_matrix_by_rows_cpp(
    a,
    path["a"]
    );

  double a_distance = auto_distance_cpp(
    a_subset,
    method
  );

  //working with b
  NumericMatrix b_subset = subset_matrix_by_rows_cpp(
    b,
    path["b"]
  );

  double b_distance = auto_distance_cpp(
    b_subset,
    method
  );

  return a_distance + b_distance;

}

// You can include R code blocks in C++ files processed with sourceCpp
// (useful for testing and development). The R code will be automatically
// run after the compilation.
//

/*** R
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

#testing subset_matrix_by_rows_cpp
a_test <- a[1:4, 1:3]

a_test

subset_matrix_by_rows_cpp(
  a_test, c(1, 3)
  )

a_test[c(1, 3), ]

auto_distance_cpp(
  m = m_subset,
  method = "euclidean"
)

#Testing all functions together

dist_matrix <- distance_matrix_cpp(
  a,
  b,
  method
)

cost_matrix <- cost_matrix_cpp(
  dist_matrix
)

path <- cost_path_cpp(
  dist_matrix,
  cost_matrix
)

a_subset = subset_matrix_by_rows_cpp(
  a,
  path$a
)

nrow(a)
nrow(a_subset)
ncol(a)
ncol(a_subset)
sum(a)
sum(a_subset)

auto_distance_cpp(
  a,
  method
)

auto_distance_cpp(
  a_subset,
  method
)




b_subset = subset_matrix_by_rows_cpp(
  b,
  path$b
)

auto_distance_cpp(
  b,
  method
)

auto_distance_cpp(
  b_subset,
  method
)


auto_sum_no_path_cpp(a, b, method)

auto_sum_path_cpp(a, b, path, method)

path_trimmed <- cost_path_trim_cpp(path)

auto_sum_path_cpp(a, b, path_trimmed, method)

*/
