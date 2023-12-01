#include <Rcpp.h>
#include "distance_metrics.h"
using namespace Rcpp;

//' Distance Matrix
//' @description Computes the distance matrix between the rows of two matrices
//' \code{a} and \code{b} with the same number of columns and arbitrary numbers of rows.
//' NA values should be removed before using this function.
//' If the selected distance function is [distance_chi_cpp], pairs of zeros should
//' be either removed or replaced with pseudo-zeros (i.e. 0.00001).
//' @param a (required, numeric matrix).
//' @param b (required, numeric matrix) of same number of columns as 'a'.
 //' @param method (optional, character string) name of the distance metric. Valid entries are:
 //' \itemize{
 //' \item "euclidean" and "euc" (Default).
 //' \item "manhattan" and "man".
 //' \item "chi.
 //' \item "hellinger" and "hel".
 //' \item "chebyshev" and "che".
 //' \item "canberra" and "can".
 //' \item "cosine" and "cos".
 //' \item "russelrao" and "rus".
 //' \item "jaccard" and "jac".
 //' }
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

  //define output matrix
  int rl = rows.length();
  int m_cols = m.ncol();
  NumericMatrix m_subset(rl, m_cols);

  //iterate over rows
  for (int i = 0; i < rl; i++) {
    NumericMatrix::Row old_row = m(rows[i] - 1, _);
    NumericMatrix::Row new_row = m_subset(i, _);
    new_row = old_row;
  }

  return m_subset;

}


//'Auto-sum of Two Paired Sequences
 //' @description Sum of the the cumulative auto-sum of two sequences with paired samples. This is
 //' a key component of the psi computation.
 //' @param a (required, numeric matrix).
 //' @param b (required, numeric matrix) of same number of columns as 'a'.
 //' @param method (optional, character string) name of the distance metric.
 //' Valid entries are:
 //' \itemize{
 //' \item "euclidean" and "euc" (Default).
 //' \item "manhattan" and "man".
 //' \item "chi.
 //' \item "hellinger" and "hel".
 //' \item "chebyshev" and "che".
 //' \item "canberra" and "can".
 //' \item "cosine" and "cos".
 //' \item "russelrao" and "rus".
 //' \item "jaccard" and "jac".
 //' }
 //' @return Numeric.
 //' @export
 // [[Rcpp::export]]
 double auto_sum_pairwise_cpp(
     NumericMatrix a,
     NumericMatrix b,
     Rcpp::Nullable<std::string> method
 ){

   if (a.nrow() != b.nrow()) {
     Rcpp::stop("Number of rows in 'a' and 'b' must be the same.");
   }

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
//' @param path (required, data frame) dataframe produced by [cost_path()]. Default: NULL
//' @param method (optional, character string) name of the distance metric. Valid entries are:
//' \itemize{
//' \item "euclidean" and "euc" (Default).
//' \item "manhattan" and "man".
//' \item "chi.
//' \item "hellinger" and "hel".
//' \item "chebyshev" and "che".
//' \item "canberra" and "can".
//' \item "cosine" and "cos".
//' \item "russelrao" and "rus".
//' \item "jaccard" and "jac".
//' }
//' @return Numeric.
//' @export
// [[Rcpp::export]]
double auto_sum_cpp(
  NumericMatrix a,
  NumericMatrix b,
  DataFrame path,
  Rcpp::Nullable<std::string> method
){

  //working with a
  NumericVector a_path = path["a"];
  a_path = unique(a_path);

  NumericMatrix a_subset = subset_matrix_by_rows_cpp(
    a,
    a_path
    );

  double a_distance = auto_distance_cpp(
    a_subset,
    method
  );

  //working with b
  NumericVector b_path = path["b"];
  b_path = unique(b_path);

  NumericMatrix b_subset = subset_matrix_by_rows_cpp(
    b,
    b_path
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

a <- sequenceA |>
  na.omit() |>
  as.matrix()

b <- sequenceB |>
  na.omit() |>
  as.matrix()

message("Testing subset_matrix_by_rows_cpp().")
m_subset <- subset_matrix_by_rows_cpp(m = a, rows = c(1, 2, 3, 4))
m_subset

message("Testing sauto_distance_cpp().")
auto_distance_cpp(
  m = m_subset,
  method = "euclidean"
)

message("Testing all functions together.")

d <- distance_matrix_cpp(
  a,
  b,
  method = "euclidean"
)

m <- cost_matrix_diag_cpp(
  dist_matrix = d
)

path <- cost_path_diag_cpp(
  dist_matrix = d,
  cost_matrix = m
)

nrow(path)

path <- cost_path_trim_cpp(
  path = path
)

nrow(path)

path_sum <- cost_path_sum(path)
path_sum

ab_sum <- auto_sum_cpp(
  a = a,
  b = b,
  path = path,
  method = "euclidean"
)

ab_sum

*/
