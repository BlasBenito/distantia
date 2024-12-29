test_that("`tsl_colnames_clean()` works", {
  tsl <- tsl_simulate(cols = 3)
  expect_equal(tsl_colnames_get(tsl = tsl), )
  tsl <- tsl_colnames_set(tsl = tsl, names = c(
    "New name 1", "new Name 2",
    "NEW NAME 3"
  ))
  expect_equal(tsl_colnames_get(tsl = tsl, names = "all"), )
  tsl <- tsl_colnames_clean(tsl = tsl)
  expect_equal(tsl_colnames_get(tsl = tsl), )
  tsl <- tsl_colnames_clean(
    tsl = tsl, capitalize_first = TRUE,
    length = 6, suffix = "clean"
  )
  expect_equal(tsl_colnames_get(tsl = tsl), )
})

test_that("`tsl_colnames_get()` works", {
  tsl <- tsl_simulate()
  expect_equal(tsl_colnames_get(tsl = tsl, names = "all"), )
  names(tsl[[1]])[1] <- "new_column"
  expect_equal(tsl_colnames_get(tsl = tsl, names = "all"), )
  expect_equal(tsl_colnames_get(tsl = tsl, names = "shared"), )
  expect_equal(tsl_colnames_get(tsl = tsl, names = "exclusive"), )
})

test_that("`tsl_colnames_prefix()` works", {
  tsl <- tsl_simulate()
  expect_equal(tsl_colnames_get(tsl = tsl), )
  tsl <- tsl_colnames_prefix(tsl = tsl, prefix = "my_prefix_")
  expect_equal(tsl_colnames_get(tsl = tsl), )
})

test_that("`tsl_colnames_set()` works", {
  tsl <- tsl_simulate(cols = 3)
  expect_equal(tsl_colnames_get(tsl = tsl), )
  tsl <- tsl_colnames_set(tsl = tsl, names = c("x", "y", "z", "zz"))
  expect_equal(tsl_colnames_get(tsl = tsl), )
  tsl <- tsl_colnames_set(tsl = tsl, names = list(A = c(
    "A", "B",
    "C"
  ), B = c("X", "Y", "Z", "ZZ")))
  expect_equal(tsl_colnames_get(tsl = tsl), )
})

test_that("`tsl_colnames_suffix()` works", {
  tsl <- tsl_simulate()
  expect_equal(tsl_colnames_get(tsl = tsl), )
  tsl <- tsl_colnames_suffix(tsl = tsl, suffix = "_my_suffix")
  expect_equal(tsl_colnames_get(tsl = tsl), )
})
