#ifndef PERMUTE_H
#define PERMUTE_H

#include <Rcpp.h>

 Rcpp::NumericMatrix permute_cpp(
     Rcpp::NumericMatrix x,
     int block_size,
     int seed
 );

 Rcpp::NumericMatrix permute_independent_cpp(
     Rcpp::NumericMatrix x,
    int block_size,
    int seed
 );

#endif // RESTRICTED_PERMUTATION_H
