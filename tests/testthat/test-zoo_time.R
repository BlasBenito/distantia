test_that("`zoo_time()` works", {
  x <- zoo_simulate(rows = 150, time_range = c(
    Sys.Date() - 365,
    Sys.Date()
  ), irregular = TRUE)

  df <- zoo_time(x = x)

  expect_equal(class(df), "data.frame")
  expect_true(all(colnames(df) %in% c("name", "rows", "class", "units", "length", "resolution", "begin", "end", "keywords")))
})
