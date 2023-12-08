#ifndef PSI_H
#define PSI_H

#include <Rcpp.h>

double psi_paired_cpp(
        Rcpp::NumericMatrix a,
        Rcpp::NumericMatrix b,
        Rcpp::Nullable<std::string> method
);

double psi_full_cpp(
        Rcpp::NumericMatrix a,
        Rcpp::NumericMatrix b,
        Rcpp::Nullable<std::string> method,
        bool diagonal = false,
        bool weighted = false,
        bool trim_blocks = false
);

Rcpp::NumericVector null_psi_paired_cpp(
        Rcpp::NumericMatrix a,
        Rcpp::NumericMatrix b,
        Rcpp::Nullable<std::string> method,
        Rcpp::IntegerVector block_size = Rcpp::IntegerVector::create(2, 3, 4),
        int seed = 1,
        int repetitions = 100
);

Rcpp::NumericVector null_psi_full_cpp(
        Rcpp::NumericMatrix a,
        Rcpp::NumericMatrix b,
        Rcpp::Nullable<std::string> method,
        bool diagonal = false,
        bool weighted = false,
        bool trim_blocks = false,
        Rcpp::IntegerVector block_size = Rcpp::IntegerVector::create(2, 3, 4),
        int seed = 1,
        int repetitions = 100
);

#endif // PSI_H

