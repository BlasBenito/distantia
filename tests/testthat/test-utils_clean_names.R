test_that("`utils_clean_names()` works", {
  x <- c("GerMany", "spain", "SWEDEN")
  expect_equal(utils_clean_names(x = x, capitalize_all = TRUE, length = 4), )
  expect_equal(utils_clean_names(
    x = x, capitalize_first = TRUE, separator = "_",
    prefix = "my_prefix", suffix = "my_suffix"
  ), )
})
