#ifndef IMPORTANCE_H
#define IMPORTANCE_H

#include <Rcpp.h>

// Declarations for functions exported to other C++ files
Rcpp::NumericVector reverse_vector_cpp(Rcpp::NumericVector x);

Rcpp::DataFrame update_path_dist_cpp(
    Rcpp::NumericMatrix a,
    Rcpp::NumericMatrix b,
    Rcpp::DataFrame path,
    const std::string& distance = "euclidean"
);

Rcpp::NumericMatrix select_column_cpp(
    Rcpp::NumericMatrix x,
    int column_index
    );

Rcpp::NumericMatrix delete_column_cpp(
    Rcpp::NumericMatrix x,
    int column_index
    );

Rcpp::DataFrame importance_ls_cpp(
    Rcpp::NumericMatrix a,
    Rcpp::NumericMatrix b,
    const std::string& distance = "euclidean"
);

Rcpp::DataFrame importance_dtw_legacy_cpp(
    Rcpp::NumericMatrix a,
    Rcpp::NumericMatrix b,
    const std::string& distance = "euclidean",
    bool diagonal = false,
    bool weighted = false,
    bool ignore_blocks = false,
    double bandwidth = 1
);

Rcpp::DataFrame importance_dtw_cpp(
    Rcpp::NumericMatrix a,
    Rcpp::NumericMatrix b,
    const std::string& distance = "euclidean",
    bool diagonal = false,
    bool weighted = false,
    bool ignore_blocks = false,
    double bandwidth = 1
  );

#endif // IMPORTANCE_H
