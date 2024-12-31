library(covr)
library(codetools)

#distantia() 94.87
covr::report(
  x = covr::file_coverage(
    source_files = c(
      "R/distantia.R",
      "R/distantia_ls.R",
      "R/distantia_dtw.R"
    ),
    test_files = "tests/testthat/test-distantia.R"
  )
)

#momentum() 85.77
covr::report(
  x = covr::file_coverage(
    source_files = c(
      "R/momentum.R",
      "R/momentum_ls.R",
      "R/momentum_dtw.R"
    ),
    test_files = "tests/testthat/test-momentum.R"
  )
)

#run all tests with coverage
covr::with_coverage(
  testthat::test_dir("path/to/test/directory"),
  covr::package_coverage()
)

# get list of functions called by a particular function
codetools::findGlobals(fun = distantia)



