#ifndef PERMUTE_H
#define PERMUTE_H

#include <Rcpp.h>

 Rcpp::NumericMatrix permute(
     Rcpp::NumericMatrix x,
     int block_size,
     int seed
 );

#endif // RESTRICTED_PERMUTATION_H
