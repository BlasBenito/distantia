#include <Rcpp.h>
using namespace Rcpp;

//' Chebyshev Distance Between Two Vectors
//' @description Computed as: \code{max(abs(x - y))}. Cannot handle NA values.
//' @param x (required, numeric vector).
//' @param y (required, numeric vector) of same length as `x`.
//' @return Chebyshev distance between x and y.
//' @examples distance_chebyshev_cpp(x = runif(100), y = runif(100))
//' @export
// [[Rcpp::export]]
double distance_chebyshev_cpp(NumericVector x, NumericVector y) {

  int length = x.size();

  double dist = 0.0;

  for (int i = 0; i < length; i++) {

    double abs_diff = std::fabs(x[i] - y[i]);
    if (abs_diff > dist) {
      dist = abs_diff; // Update distance if a larger difference is found
    }

  }

  return dist;

}

//' Jaccard Distance Between Two Binary Vectors
//' @description Computes the Jaccard distance between two binary vectors.
//' @param x (required, numeric vector).
//' @param y (required, numeric vector) of same length as `x`.
//' @return Jaccard distance between x and y.
//' @examples distance_jaccard_cpp(c(0, 1, 0, 1), c(1, 1, 0, 0))
//' @export
// [[Rcpp::export]]
double distance_jaccard_cpp(NumericVector x, NumericVector y) {

  int length = x.size();

  double intersection = 0.0;
  double union_count = 0.0;

  for (int i = 0; i < length; i++) {
    if (x[i] == 1 || y[i] == 1) {
      union_count++;
      if (x[i] == 1 && y[i] == 1) {
        intersection++;
      }
    }
  }

  if (union_count == 0) {
    return 0.0; // In case both vectors are all zeros, Jaccard distance is 0.
  }

  return 1.0 - (intersection / union_count);
}


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

//' Canberra Distance Between Two Binary Vectors
//' @description Computes the Canberra distance between two binary vectors.
//' @param x (required, numeric vector).
//' @param y (required, numeric vector) of same length as `x`.//' @return Canberra distance between x and y.
//' @examples distance_canberra_cpp(c(0, 1, 0, 1), c(1, 1, 0, 0))
//' @export
// [[Rcpp::export]]
double distance_canberra_cpp(NumericVector x, NumericVector y) {

  int length = x.size();

  double dist = 0.0;

  for (int i = 0; i < length; i++) {
    double numerator = std::fabs(x[i] - y[i]);
    double denominator = std::fabs(x[i]) + std::fabs(y[i]);
    if (denominator != 0.0) {
      dist += numerator / denominator;
    }
  }

  return dist;
}

//' Russell-Rao Distance Between Two Binary Vectors
//' @description Computes the Russell-Rao distance between two binary vectors.
//' @param x (required, numeric). Binary vector of 1s and 0s.
//' @param y (required, numeric) Binary vector of 1s and 0s of same length as `x`.
//' @return Russell-Rao distance between x and y.
//' @examples distance_russelrao_cpp(c(0, 1, 0, 1), c(1, 1, 0, 0))
//' @export
// [[Rcpp::export]]
double distance_russelrao_cpp(NumericVector x, NumericVector y) {

  int length = x.size();

  double dist = 0.0;

  for (int i = 0; i < length; i++) {
    if (x[i] == y[i]) {
      dist += 1.0; // Increase distance if elements are the same
    }
  }

  return 1.0 - (dist / length);
}


//' Cosine Dissimilarity Between Two Vectors
//' @description Computes the cosine dissimilarity between two numeric vectors.
//' @param x (required, numeric vector).
//' @param y (required, numeric vector) of same length as `x`.
//' @return Cosine dissimilarity between x and y.
//' @examples distance_cosine_cpp(c(0.2, 0.4, 0.5), c(0.1, 0.8, 0.2))
//' @export
// [[Rcpp::export]]
double distance_cosine_cpp(NumericVector x, NumericVector y) {

  int length = x.size();

  double dotProduct = 0.0;
  double magnitudeX = 0.0;
  double magnitudeY = 0.0;

  for (int i = 0; i < length; i++) {
    dotProduct += x[i] * y[i];
    magnitudeX += x[i] * x[i];
    magnitudeY += y[i] * y[i];
  }

  return 1.0 - (dotProduct / (sqrt(magnitudeX) * sqrt(magnitudeY)));

}


//' Hamming Distance Between Two Binary Vectors
//' @description Computes the Hamming distance between two binary vectors.
//' @param x (required, numeric vector).
//' @param y (required, numeric vector) of same length as `x`.
//' @return Hamming distance between x and y.
//' @examples distance_hamming_cpp(c(0, 1, 0, 1), c(1, 1, 0, 0))
//' @export
// [[Rcpp::export]]
double distance_hamming_cpp(NumericVector x, NumericVector y) {

  int length = x.size();

  double dist = 0.0;

  for (int i = 0; i < length; i++) {
    if (x[i] != y[i]) {
      dist += 1.0; // Increase distance if elements are different
    }
  }

  return dist;
}

//define the type for the distance function
typedef double (*DistanceFunction)(NumericVector, NumericVector);

// Internal function to select a distance function
DistanceFunction select_distance_function_cpp(const std::string& distance = "euclidean") {
  if (distance == "manhattan" || distance.substr(0, 3) == "man") {
    return &distance_manhattan_cpp;
  } else if (distance == "euclidean" || distance.substr(0, 3) == "euc") {
    return &distance_euclidean_cpp;
  } else if (distance == "chebyshev" || distance.substr(0, 3) == "che") {
    return &distance_chebyshev_cpp;
  } else if (distance == "canberra" || distance.substr(0, 3) == "can") {
    return &distance_canberra_cpp;
  } else if (distance == "russelrao" || distance.substr(0, 3) == "rus") {
    return &distance_russelrao_cpp;
  } else if (distance == "cosine" || distance.substr(0, 3) == "cos") {
    return &distance_cosine_cpp;
  } else if (distance == "jaccard" || distance.substr(0, 3) == "jac") {
    return &distance_jaccard_cpp;
  } else if (distance == "hellinger" || distance.substr(0, 3) == "hel") {
    return &distance_hellinger_cpp;
  } else if (distance == "hamming" || distance.substr(0, 3) == "ham") {
    return &distance_hamming_cpp;
  } else if (distance == "chi") {
    return &distance_chi_cpp;
  } else {
    Rcpp::stop("Invalid distance.");
  }
}


/*** R
#generating data
set.seed(1)
x <- runif(10)
y <- runif(10)

#computing distances
distance_chebyshev_cpp(x, y)
distance_jaccard_cpp(x, y)
distance_manhattan_cpp(x, y)
distance_euclidean_cpp(x, y)
distance_hellinger_cpp(x, y)
distance_chi_cpp(x, y)
distance_canberra_cpp(x, y)
distance_russelrao_cpp(x, y)
distance_cosine_cpp(x, y)
*/
