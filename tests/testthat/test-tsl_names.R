test_that("`tsl_names_clean()` works", {
  tsl <- tsl_initialize(
    x = fagus_dynamics, name_column = "name",
    time_column = "time"
  )
  expect_equal(tsl_names_get(tsl = tsl), )
  tsl_clean <- tsl_names_clean(
    tsl = tsl, capitalize_first = TRUE,
    length = 4
  )
  expect_equal(tsl_names_get(tsl = tsl_clean), )
  tsl_clean <- tsl_names_clean(
    tsl = tsl, capitalize_all = TRUE,
    separator = "_", suffix = "fagus", prefix = "country"
  )
  expect_equal(tsl_names_get(tsl = tsl_clean), )
})

test_that("`tsl_names_get()` works", {
  tsl <- tsl_initialize(
    x = fagus_dynamics, name_column = "name",
    time_column = "time"
  )
  expect_equal(tsl_names_get(tsl = tsl, zoo = TRUE), )
  expect_equal(tsl_names_get(tsl = tsl, zoo = FALSE), )
  expect_equal(names(tsl), )
})

test_that("`tsl_names_set()` works", {
  tsl <- tsl_simulate(n = 3)
  expect_equal(tsl_diagnose(tsl = tsl), )
  expect_equal(tsl_names_get(tsl = tsl), )
  expect_equal(tsl_names_get(tsl = tsl, zoo = FALSE), )
  tsl <- tsl_names_set(tsl = tsl, names = c("X", "Y", "Z"))
  expect_equal(tsl_names_get(tsl = tsl), )
  names(tsl)[2] <- "B"
  expect_equal(tsl_names_get(tsl = tsl), )
  expect_equal(tsl_diagnose(tsl = tsl), )
  tsl <- tsl_names_set(tsl = tsl)
  expect_equal(tsl_diagnose(tsl = tsl), )
  expect_equal(tsl_names_get(tsl = tsl), )
})

test_that("`tsl_names_test()` works", {
  
})
