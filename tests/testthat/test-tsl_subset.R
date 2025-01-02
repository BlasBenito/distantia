test_that("`tsl_subset()` works", {

  tsl <- tsl_initialize(
    x = fagus_dynamics,
    name_column = "name",
    time_column = "time"
  )

  tsl_new <- tsl_subset(
    tsl = tsl, names = c("Sweden", "Germany"),
    colnames = c("rainfall", "temperature"),
    time = c(
      "2010-01-01",
      "2015-01-01"
    )
  )

  expect_true(
    all(tsl_names_get(tsl = tsl_new) == c("Sweden", "Germany"))
    )

  expect_equal(tsl_colnames_get(tsl = tsl_new)$Sweden, c("rainfall", "temperature"))

  expect_equal(tsl_colnames_get(tsl = tsl_new)$Germany, c("rainfall", "temperature"))

  expect_equal(unique(tsl_time(tsl = tsl_new)$begin), as.Date("2010-01-01"))

  expect_equal(unique(tsl_time(tsl = tsl_new)$end), as.Date("2015-01-01"))

})
