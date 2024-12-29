test_that("`tsl_subset()` works", {
  tsl <- tsl_initialize(
    x = fagus_dynamics, name_column = "name",
    time_column = "time"
  )
  expect_equal(tsl_names_get(tsl = tsl), )
  expect_equal(tsl_colnames_get(tsl = tsl), )
  expect_equal(tsl_time(tsl = tsl)[, c("name", "begin", "end")], )
  tsl_new <- tsl_subset(
    tsl = tsl, names = c("Sweden", "Germany"),
    colnames = c("rainfall", "temperature"), time = c(
      "2010-01-01",
      "2015-01-01"
    )
  )
  expect_equal(tsl_names_get(tsl = tsl_new), )
  expect_equal(tsl_colnames_get(tsl = tsl_new), )
  expect_equal(tsl_time(tsl = tsl_new)[, c("name", "begin", "end")], )
})
