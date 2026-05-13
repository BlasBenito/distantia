## R CMD check results

0 errors | 0 warnings | 0 notes

## Test environments

- Local: Ubuntu 24.04, R 4.5.0
- GitHub Actions: ubuntu-latest (R release, R devel), windows-latest (R release), macos-latest (R release)
- R-hub: Debian Linux (GCC), Fedora Linux (Clang), Windows Server 2022

## Submission notes

This is a patch release (2.0.3) that fixes multiple bugs reported since 2.0.2:
- Corrected invalid `aggregate.data.frame` calls in `momentum_stats()`,
  `distantia_aggregate()`, and `distantia_stats()` (formula passed as `by`
  argument instead of using the formula interface).
- Fixed partial-matching via `attributes(x)$name` in `zoo_name_get()`,
  `zoo_aggregate()`, and `zoo_vector_to_matrix()`; replaced with
  `attr(x, "name", exact = TRUE)`.
- Fixed `psi_null_dtw_cpp()` omitting the `bandwidth` argument from the
  observed psi computation in the null distribution.
- Fixed divide-by-zero in `utils_rescale_vector()`, `NA` breaks in
  `utils_color_breaks()`, and a crash in `utils_cluster_silhouette()` for
  single-cluster input.
- Several other defensive fixes and informative error messages.

No reverse dependencies on CRAN.
