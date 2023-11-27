#ifndef DISTANCE_METRICS_H
#define DISTANCE_METRICS_H

#include <Rcpp.h>

double distance_manhattan_cpp(Rcpp::NumericVector x, Rcpp::NumericVector y);
double distance_euclidean_cpp(Rcpp::NumericVector x, Rcpp::NumericVector y);
double distance_hellinger_cpp(Rcpp::NumericVector x, Rcpp::NumericVector y);
double distance_chi_cpp(Rcpp::NumericVector x, Rcpp::NumericVector y);

#endif // DISTANCE_METRICS_H
