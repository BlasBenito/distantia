# `distantia` version 2.0.2

This submission was requested by The CRAN Team with via email with the message:

"Dear maintainer,

Please see the problems shown on
<https://cran.r-project.org/web/checks/check_results_distantia.html>.

The ERRORs with r-devel are from

  r87667 | maechler | 2025-01-29 12:36:14 +0100 (Wed, 29 Jan 2025) | 1 line
  unique(<difftime>) now works, too

Typically they indicate that code assumes that unique(<difftime>)
returns a simple numeric, which got changed by the above.  One could of course use as.numeric(unique( <difftime> )) to "fix", but likely using unique( as.numeric(<difftime>) ) would be better ...

Please correct before 2025-02-22 to safely retain your package on CRAN.

Best wishes,
The CRAN Team"

The offending code was in the last line of the the test file `tests/testthat/test-utils_new_time.R`, where

```r
  expect_equal(unique(diff(new_time)), c(90, 91, 92))
```

is now

```r
  expect_equal(unique(as.numeric(diff(new_time))), c(90, 91, 92))
```


## Changelog Summary

- Fixed error (r-devel only) in test file `tests/testthat/test-utils_new_time.R`

- Function `zoo_plot()` now has the argument `guide_position` to modify the legend position.

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
── R CMD check results ─────────────────────────────────────────────────────────── distantia 2.0.2 ────
Duration: 3m 10.9s

❯ checking installed package size ... NOTE
    installed size is  7.7Mb
    sub-directories of 1Mb or more:
      libs   9.5Mb

0 errors ✔ | 0 warnings ✔ | 1 note ✖

R CMD check succeeded
```
