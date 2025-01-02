test_that("`utils_time_keywords_dictionary()` works", {
  df <- utils_time_keywords_dictionary()
  expect_equal(class(df), "data.frame")
  expect_equal(colnames(df), c("pattern", "keyword"))
})
