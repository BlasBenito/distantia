#include <Rcpp.h>
using namespace Rcpp;

//' Manhattan Distance Between Two Vectors
//' @description Computed as: \code{sum(abs(x - y))}. Cannot handle NA values.
//' @param x (required, numeric vector).
//' @param y (required, numeric vector) of same length as `x`.
//' @return Manhattan distance between x and y.
//' @examples distance_manhattan_cpp(x = runif(100), y = runif(100))
//' @export
// [[Rcpp::export]]
double distance_manhattan_cpp(NumericVector x, NumericVector y) {

  int length = x.size();

  double dist = 0.0;

  for (int i = 0; i < length; i++) {

    dist += std::fabs(x[i] - y[i]);

  }

  return dist;

}

//' Euclidean Distance Between Two Vectors
//' @description Computed as: \code{sqrt(sum((x - y)^2)}. Cannot handle NA values.
//' @param x (required, numeric vector).
//' @param y (required, numeric vector) of same length as `x`.
//' @return Euclidean distance between x and y.
//' @examples distance_euclidean_cpp(x = runif(100), y = runif(100))
//' @export
// [[Rcpp::export]]
double distance_euclidean_cpp(NumericVector x, NumericVector y) {

  int length = x.size();

  double dist = 0.0;

  for (int i = 0; i < length; i++) {

    dist += (x[i] - y[i])*(x[i] - y[i]);

  }

  return std::sqrt(dist);

}

//' Hellinger Distance Between Two Vectors
//' @description Computed as: \code{sqrt(1/2 * sum((sqrt(x) - sqrt(y))^2))}.
//' Cannot handle NA values.
//' @param x (required, numeric vector).
//' @param y (required, numeric vector) of same length as `x`.
//' @return Hellinger distance between x and y.
//' @examples distance_hellinger_cpp(x = runif(100), y = runif(100))
//' @export
// [[Rcpp::export]]
double distance_hellinger_cpp(NumericVector x, NumericVector y) {

  int length = x.size();

  double dist = 0.0;

  for (int i = 0; i < length; i++) {

    dist += (std::sqrt(x[i]) - std::sqrt(y[i])) * (std::sqrt(x[i]) - std::sqrt(y[i]));

  }

  return std::sqrt(0.5 * dist);

}

//' Normalized Chi Distance Between Two Vectors
//' @description Computed as:
//' \code{xy <- x + y}
//' \code{y. <- y / sum(y)}
//' \code{x. <- x / sum(x)}
//' \code{sqrt(sum(((x. - y.)^2) / (xy / sum(xy))))}.
//' Cannot handle NA values. When \code{x} and \code{y} have zeros in the same
//' position, \code{NaNs} are produced. Please replace these zeros with
//' pseudo-zeros (i.e. 0.0001) if you wish to use this distance metric.
//' @examples distance_chi_cpp(x = runif(100), y = runif(100))
//' @param x (required, numeric vector).
//' @param y (required, numeric vector) of same length as `x`.
//' @return Chi distance between x and y.
//' @export
// [[Rcpp::export]]
double distance_chi_cpp(NumericVector x, NumericVector y) {

  int length = x.size();

  double dist = 0.0;

  double x_sum = sum(x);

  double y_sum = sum(y);

  double xy_sum = x_sum + y_sum;

  for (int i = 0; i < length; i++) {

    double x_norm = x[i] / x_sum;

    double y_norm = y[i] / y_sum;

    dist += ((x_norm - y_norm) * (x_norm - y_norm)) / ((x[i] + y[i]) / xy_sum);
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
x <- runif(10)
y <- runif(10)

#computing distances
distance_chi_cpp(x, y)
distance_manhattan_cpp(x, y)
distance_euclidean_cpp(x, y)
distance_hellinger_cpp(x, y)
*/
