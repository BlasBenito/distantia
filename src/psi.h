#ifndef DISTANTIA_H
#define DISTANTIA_H

#include <Rcpp.h>

double psi_pairwise_cpp(
    Rcpp::NumericMatrix a,
    Rcpp::NumericMatrix b,
    Rcpp::Nullable<std::string> method
);


double psi_cpp(
    Rcpp::NumericMatrix a,
    Rcpp::NumericMatrix b,
    Rcpp::Nullable<std::string> method,
    bool diagonal = false,
    bool weighted = false,
    bool trim_blocks = false
);

#endif // DISTANTIA_FUNCTIONS_H
