# `distantia` version 2.0.0

## Changelog Summary

- Most computationally demanding functions were rewritten in C++ via Rcpp.

- New comprehensive toolset to manage time series data for dissimilarity analysis.

- New example datasets from different disciplines.

## Checks Summary

Checks return one NOTE because the `libs` subdirectory is then above the 1MB threshold:

```r
❯ checking installed package size ... NOTE
    installed size is 11.2Mb
    sub-directories of 1Mb or more:
      libs   9.5Mb
```

My understanding is that this inflation of the libs subdirectory is due to the use of Rcpp. Indeed, some functions of the `distantia` package have been written in C++ using Rcpp. They are needed to perform dynamic time warping and other critical operations efficiently. 

### Local Check

- OS: Ubuntu 20.04.6 LTS Focal
- R version: 4.4.1

```r
── R CMD check results ───────────── distantia 2.0.0 ────
Duration: 4m 23.6s

❯ checking installed package size ... NOTE
    installed size is 11.2Mb
    sub-directories of 1Mb or more:
      libs   9.5Mb

0 errors ✔ | 0 warnings ✔ | 1 note ✖

R CMD check succeeded
```

### Rhub Checks

Results of Rhub checks for the platforms below are [here](https://github.com/BlasBenito/distantia/actions/runs/12594523370):

```r
rhub::rhub_check(
  platforms = c(
    "linux",
    "macos",
    "macos-arm64",
    "windows",
    "atlas",
    "c23",
    "clang-asan",
    "clang16",
    "clang17",
    "clang18",
    "clang19",
    "gcc13",
    "gcc14",
    "intel",
    "mkl",
    "nold",
    "ubuntu-clang",
    "ubuntu-gcc12",
    "ubuntu-next",
    "ubuntu-release"
  )
)
```

## Unit Testing

251 unit tests passed.

```r
==> Rcpp::compileAttributes()

* Updated R/RcppExports.R

==> devtools::test()

ℹ Testing distantia
✔ | F W  S  OK | Context
✔ |          3 | distance_matrix                   
✔ |          2 | distance                          
✔ |          5 | distantia_cluster_hclust [1.6s]   
✔ |          5 | distantia_cluster_kmeans [1.3s]   
✔ |          5 | distantia_model_frame [4.8s]      
✔ |          2 | distantia_spatial [3.9s]          
✔ |          3 | distantia_time_shift [1.2s]       
✔ |         14 | distantia [4.8s]                  
✔ |         13 | momentum [2.0s]                   
✔ |         15 | psi_equation                      
✔ |          2 | tsl_aggregate                     
✔ |          2 | tsl_burst                         
✔ |         11 | tsl_colnames                      
✔ |          3 | tsl_count_NA                      
✔ |          1 | tsl_diagnose                      
✔ |          4 | tsl_handle_NA                     
✔ |          8 | tsl_initialize                    
✔ |          3 | tsl_join                          
✔ |          2 | tsl_names                         
✔ |          4 | tsl_ncol                          
✔ |          2 | tsl_repair                        
✔ |          3 | tsl_resample                      
✔ |          1 | tsl_smooth [1.5s]                 
✔ |          4 | tsl_stats                         
✔ |          5 | tsl_subset                        
✔ |          3 | tsl_time                          
✔ |          3 | tsl_to_df                         
✔ |         50 | tsl_transform [2.8s]              
✔ |          5 | utils_as_time                     
✔ |          2 | utils_clean_names                 
✔ |          6 | utils_cluster [1.5s]              
✔ |          3 | utils_coerce_time_class           
✔ |          4 | utils_digits                      
✔ |          1 | utils_distantia_df_split          
✔ |          2 | utils_is_time                     
✔ |          3 | utils_new_time                    
✔ |          1 | utils_optimize_loess              
✔ |          1 | utils_optimize_spline             
✔ |          2 | utils_prepare_zoo_list            
✔ |          1 | utils_rescale_vector              
✔ |          2 | utils_time_keywords_dictionary    
✔ |          9 | utils_time_keywords_translate     
✔ |          5 | utils_time_keywords               
✔ |          2 | utils_time_units                  
✔ |          2 | zoo_aggregate                     
✔ |          3 | zoo_names                         
✔ |          2 | zoo_permute                       
✔ |          4 | zoo_resample                      
✔ |          3 | zoo_simulate                      
✔ |          2 | zoo_smooth                        
✔ |          2 | zoo_time                          
✔ |          4 | zoo_to_tsl                        
✔ |          2 | zoo_vector_to_matrix              

══ Results ════════════════════════════════════════
Duration: 35.1 s

[ FAIL 0 | WARN 0 | SKIP 0 | PASS 251 ]

🥳
```
