#include <Rcpp.h>
using namespace Rcpp;

//' Manhattan Distance Between Two Vectors
//'
//' @param x (required, numeric vector).
//' @param y (required, numeric vector) of same length as `x`.
//' @return Manhattan distance between x and y.
//' @details Cannot handle NA values.
//' @export
// [[Rcpp::export]]
double distance_manhattan_cpp(NumericVector x, NumericVector y) {

  int length = x.size();

  double dist;

  for (int j = 0; j < length; j++) {

    dist += std::fabs(x[j] - y[j]);

  }

  return dist;

}

//' Euclidean Distance Between Two Vectors
//'
//' @param x (required, numeric vector).
//' @param y (required, numeric vector) of same length as `x`.
//' @return Euclidean distance between x and y.
//' @details Cannot handle NA values.
//' @export
// [[Rcpp::export]]
double distance_euclidean_cpp(NumericVector x, NumericVector y) {

  int length = x.size();

  double dist;

  for (int j = 0; j < length; j++) {

    dist += (x[j] - y[j])*(x[j] - y[j]);

  }

  return std::sqrt(dist);

}

//' Hellinger Distance Between Two Vectors
//'
//' @param x (required, numeric vector).
//' @param y (required, numeric vector) of same length as `x`.
//' @return Hellinger distance between x and y.
//' @details Cannot handle NA values.
//' @examples distance_hellinger_cpp(x = runif(100), y = runif(100))
//' @export
// [[Rcpp::export]]
double distance_hellinger_cpp(NumericVector x, NumericVector y) {

  int length = x.size();

  double dist;

  for (int j = 0; j < length; j++) {

    dist += (std::sqrt(x[j]) - std::sqrt(y[j])) * (std::sqrt(x[j]) - std::sqrt(y[j]));

  }

  return std::sqrt(0.5 * dist);

}

//' Chi Distance Between Two Vectors
//'
//' @param x (required, numeric vector).
//' @param y (required, numeric vector) of same length as `x`.
//' @return Chi distance between x and y.
//' @details Cannot handle NA values.
//' @examples distance_chi_cpp(x = runif(100), y = runif(100))
//' @export
// [[Rcpp::export]]
double distance_chi_cpp(NumericVector x, NumericVector y) {

  int length = x.size();

  double dist;

  double x_sum = sum(x);

  double y_sum = sum(y);

  double xy_sum = x_sum + y_sum;

  for (int j = 0; j < length; j++) {

    double x_norm = x[j] / x_sum;

    double y_norm = y[j] / y_sum;

    dist += ((x_norm - y_norm) * (x_norm - y_norm)) / ((x[j] + y[j]) / xy_sum);
  }

  return std::sqrt(dist);

}

// You can include R code blocks in C++ files processed with sourceCpp
// (useful for testing and development). The R code will be automatically
// run after the compilation.
//

/*** R
#generating data
set.seed(1)
x <- runif(1000)
y <- runif(1000)

#computing distances
distance_chi_cpp(x, y)
distance_manhattan_cpp(x, y)
distance_euclidean_cpp(x, y)
distance_hellinger_cpp(x, y)
*/
