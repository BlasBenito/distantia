test_that("`utils_time_keywords_translate()` works", {

  expect_equal(utils_time_keywords_translate(keyword = "1000 years"), "millennia")
  expect_equal(utils_time_keywords_translate(keyword = "1000 y"), "millennia")
  expect_equal(utils_time_keywords_translate(keyword = "thousands"), "millennia")
  expect_equal(utils_time_keywords_translate(keyword = "year"), "years")
  expect_equal(utils_time_keywords_translate(keyword = "y"), "years")
  expect_equal(utils_time_keywords_translate(keyword = "d"), "days")
  expect_equal(utils_time_keywords_translate(keyword = "day"), "days")
  expect_equal(utils_time_keywords_translate(keyword = "s"), "seconds")
  expect_equal(utils_time_keywords_translate(keyword = "sec"), "seconds")

})
