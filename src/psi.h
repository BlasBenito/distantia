#ifndef PSI_H
#define PSI_H

#include <Rcpp.h>

double psi_paired_cpp(
        Rcpp::NumericMatrix a,
        Rcpp::NumericMatrix b,
        const std::string& method = "euclidean"
);

double psi_cpp(
        Rcpp::NumericMatrix a,
        Rcpp::NumericMatrix b,
        const std::string& method = "euclidean",
        bool diagonal = false,
        bool weighted = false,
        bool ignore_blocks = false
);

Rcpp::NumericVector null_psi_paired_cpp(
        Rcpp::NumericMatrix a,
        Rcpp::NumericMatrix b,
        const std::string& method = "euclidean",
        Rcpp::IntegerVector block_size = Rcpp::IntegerVector::create(2, 3, 4),
        int seed = 1,
        int repetitions = 100
);

Rcpp::NumericVector null_psi_cpp(
        Rcpp::NumericMatrix a,
        Rcpp::NumericMatrix b,
        const std::string& method = "euclidean",
        bool diagonal = false,
        bool weighted = false,
        bool ignore_blocks = false,
        Rcpp::IntegerVector block_size = Rcpp::IntegerVector::create(2, 3, 4),
        int seed = 1,
        int repetitions = 100
);

#endif // PSI_H

