#ifndef PERMUTE_H
#define PERMUTE_H

#include <Rcpp.h>


Rcpp::NumericMatrix permute_restricted_by_row_cpp(
    Rcpp::NumericMatrix x,
    int block_size,
    int seed
);

Rcpp::NumericMatrix permute_free_by_row_cpp(
    Rcpp::NumericMatrix x,
    int block_size,
    int seed
);

Rcpp::NumericMatrix permute_restricted_cpp(
    Rcpp::NumericMatrix x,
    int block_size,
    int seed
);

Rcpp::NumericMatrix permute_free_cpp(
    Rcpp::NumericMatrix x,
    int block_size,
    int seed
);

// Define the type for the distance function
typedef Rcpp::NumericMatrix (*PermutationFunction)(Rcpp::NumericMatrix, int, int);

// Internal function to select the distance method
PermutationFunction select_permutation_function_cpp(
    const std::string& permutation = "restricted_by_row"
);

#endif // RESTRICTED_PERMUTATION_H
