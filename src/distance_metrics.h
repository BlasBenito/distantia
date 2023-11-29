#include <Rcpp.h>

// Chebyshev Distance
double distance_chebyshev_cpp(Rcpp::NumericVector x, Rcpp::NumericVector y);

// Jaccard Distance
double distance_jaccard_cpp(Rcpp::NumericVector x, Rcpp::NumericVector y);

// Manhattan Distance
double distance_manhattan_cpp(Rcpp::NumericVector x, Rcpp::NumericVector y);

// Euclidean Distance
double distance_euclidean_cpp(Rcpp::NumericVector x, Rcpp::NumericVector y);

// Hellinger Distance
double distance_hellinger_cpp(Rcpp::NumericVector x, Rcpp::NumericVector y);

// Chi Distance
double distance_chi_cpp(Rcpp::NumericVector x, Rcpp::NumericVector y);

// Canberra Distance
double distance_canberra_cpp(Rcpp::NumericVector x, Rcpp::NumericVector y);

// Russell-Rao Distance
double distance_russelrao_cpp(Rcpp::NumericVector x, Rcpp::NumericVector y);

// Cosine Dissimilarity
double distance_cosine_cpp(Rcpp::NumericVector x, Rcpp::NumericVector y);

// Define the type for the distance function
typedef double (*DistanceFunction)(Rcpp::NumericVector, Rcpp::NumericVector);

// Internal function to select the distance method
DistanceFunction distance_function(const std::string& method);
