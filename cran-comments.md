# `distantia` version 2.0.1

Critical Hotfix!

## Changelog Summary

- Fixed bug in function `cost_matrix_diagonal_weighted_cpp()`, where diagonal movements were not correctly weighted. This change will result in slightly different `psi` values in `distantia()`, `distantia_dtw()`, and `distantia_dtw_plot()` when `diagonal = TRUE` (default).

- Fixed bug in function `cost_path_cpp`, which still produced diagonal cost matrices when `diagonal = FALSE` because `weighted = TRUE` forced `diagonal` to `TRUE`. Now `weighted` is set to `FALSE` when `diagonal = FALSE`. This resulted in negative scores for orthogonal DTW alignments.

## Checks Summary

Checks return one NOTE because the `libs` subdirectory is then above the 1MB threshold:

```r
❯ checking installed package size ... NOTE
    installed size is  7.7Mb
    sub-directories of 1Mb or more:
      libs   6.0Mb
```

### Local Check

- OS: Ubuntu 20.04.6 LTS Focal
- R version: 4.4.1

```r
── R CMD check results ─────────────────────────────────────────────────────────── distantia 2.0.1 ────
Duration: 1m 9.4s

❯ checking installed package size ... NOTE
    installed size is  7.7Mb
    sub-directories of 1Mb or more:
      libs   6.0Mb

0 errors ✔ | 0 warnings ✔ | 1 note ✖

R CMD check succeeded
```

### Rhub Checks

Results of Rhub checks for the platforms below are [here](https://github.com/BlasBenito/distantia/actions/runs/12913964438):

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

252 unit tests passed.

```r
==> devtools::test()

ℹ Testing distantia
✔ | F W  S  OK | Context
✔ |          3 | distance_matrix                                                                       
✔ |          2 | distance                                                                              
✔ |          5 | distantia_cluster_hclust                                                              
✔ |          5 | distantia_cluster_kmeans                                                              
✔ |          5 | distantia_model_frame [1.4s]                                                          
✔ |          2 | distantia_spatial                                                                     
✔ |          3 | distantia_time_shift                                                                  
✔ |         16 | distantia [1.5s]                                                                      
✔ |         13 | momentum                                                                              
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
✔ |          1 | tsl_smooth                                                                            
✔ |          4 | tsl_stats                                                                             
✔ |          5 | tsl_subset                                                                            
✔ |          3 | tsl_time                                                                              
✔ |          3 | tsl_to_df                                                                             
✔ |         49 | tsl_transform                                                                         
✔ |          5 | utils_as_time                                                                         
✔ |          2 | utils_clean_names                                                                     
✔ |          6 | utils_cluster                                                                         
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

══ Results ════════════════════════════════════════════════════════════════════════════════════════════
Duration: 9.8 s

[ FAIL 0 | WARN 0 | SKIP 0 | PASS 252 ]

🥳
```
