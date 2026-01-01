# Rescale Numeric Vector to a New Data Range

Rescale Numeric Vector to a New Data Range

## Usage

``` r
utils_rescale_vector(
  x = NULL,
  new_min = 0,
  new_max = 1,
  old_min = NULL,
  old_max = NULL
)
```

## Arguments

- x:

  (required, numeric vector) Numeric vector. Default: `NULL`

- new_min:

  (optional, numeric) New minimum value. Default: `0`

- new_max:

  (optional_numeric) New maximum value. Default: `1`

- old_min:

  (optional, numeric) Old minimum value. Default: `NULL`

- old_max:

  (optional_numeric) Old maximum value. Default: `NULL`

## Value

numeric vector

## See also

Other tsl_processing_internal:
[`utils_drop_geometry()`](https://blasbenito.github.io/distantia/reference/utils_drop_geometry.md),
[`utils_global_scaling_params()`](https://blasbenito.github.io/distantia/reference/utils_global_scaling_params.md),
[`utils_optimize_loess()`](https://blasbenito.github.io/distantia/reference/utils_optimize_loess.md),
[`utils_optimize_spline()`](https://blasbenito.github.io/distantia/reference/utils_optimize_spline.md)

## Examples

``` r
 out <- utils_rescale_vector(
   x = stats::rnorm(100),
   new_min = 0,
   new_max = 100,
   )

 out
#>   [1]  46.053905  38.124573  83.455323  64.115420  63.829794  49.677915
#>   [7]  59.011361  43.992107  19.188137  36.461104  64.132506   5.208488
#>  [13]  37.005267  28.539492  82.843271  58.359925  42.135420  20.958148
#>  [19]  36.355578  60.661816  28.153725  75.659428  26.769384  31.549209
#>  [25]  65.841011  65.821919  31.669467  84.769528  43.917530  28.336479
#>  [31]  70.950725  21.699515  37.686672  77.931474  58.500671  58.049416
#>  [37]  31.348997  29.847351  67.563127 100.000000  34.434277  34.162374
#>  [43]  45.340496  35.494553  65.506788   5.397434  85.898991  93.295286
#>  [49]  27.072660  96.705313  61.578163  32.379099  73.870854  46.165319
#>  [55]   0.000000  85.770481  82.695963  20.516736  53.194912  62.067231
#>  [61]  47.311940  36.055162  69.741790  35.855792  63.055427  49.970906
#>  [67]  73.109745  34.435376  59.613592  21.539584  85.967996  29.364596
#>  [73]  22.247495  42.934942  20.343669  19.717867  30.703741  69.950723
#>  [79]  82.905947  49.088589  22.129769  69.928083  54.615439  53.291615
#>  [85]  36.945626  55.323366  62.291226  34.538713  66.436379  74.274643
#>  [91]  48.085922  70.477245  50.755309  24.783049  60.568811  43.982493
#>  [97]  81.407307  70.378300  19.248056  16.570006
```
