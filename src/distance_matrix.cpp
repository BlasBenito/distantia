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
NumericMatrix distance_matrix_cpp(
    NumericMatrix a,
    NumericMatrix b,
    Rcpp::Nullable<std::string> method
){

  std::string selected_method = Rcpp::as<std::string>(method);
  DistanceFunction f = distance_function(selected_method);

  int an = a.nrow();
  int bn = b.nrow();
  NumericMatrix D(an, bn);

  for (int i = 0; i < an; i++) {
    for (int j = 0; j < bn; j++) {
      double dist = f(a.row(i), b.row(j));
      D(i, j) = dist;
    }
  }

  return D;
}


// You can include R code blocks in C++ files processed with sourceCpp
// (useful for testing and development). The R code will be automatically
// run after the compilation.
//

/*** R
message("method = euclidean")
d <- distance_matrix_method_cpp(a, b, method = "euclidean")
dim(d)
d[1:5, 1:5]

message("method = manhattan")
d <- distance_matrix_method_cpp(a, b, method = "manhattan")
dim(d)
d[1:5, 1:5]

message("method = jaccard")
d <- distance_matrix_method_cpp(a, b, method = "jaccard")
dim(d)
d[1:5, 1:5]

message("method = hellinger")
d <- distance_matrix_cpp(a, b, method = "hellinger")
dim(d)
d[1:5, 1:5]

message("method = chi")
d <- distance_matrix_cpp(a, b, method = "chi")
dim(d)
d[1:5, 1:5]

message("method = canberra")
d <- distance_matrix_cpp(a, b, method = "canberra")
dim(d)
d[1:5, 1:5]

message("method = chebyshev")
d <- distance_matrix_cpp(a, b, method = "chebyshev")
dim(d)
d[1:5, 1:5]

message("method = russelrao")
d <- distance_matrix_cpp(a, b, method = "russelrao")
dim(d)
d[1:5, 1:5]

message("method = cosine")
d <- distance_matrix_cpp(a, b, method = "cosine")
dim(d)
d[1:5, 1:5]
*/
