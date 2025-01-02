test_that("`tsl_handle_NA()` works", {

  tsl <- tsl_simulate(na_fraction = 0.25)

  tsl_nrow <- tsl_nrow(tsl = tsl) |>
    unlist() |>
    sum()

  tsl_no_na <- tsl_handle_NA(tsl = tsl, na_action = "omit")

  expect_true(
    tsl_nrow > tsl_nrow(tsl = tsl_no_na) |>
      unlist() |>
      sum()
  )

  expect_equal(sum(unlist(tsl_count_NA(tsl = tsl_no_na))), 0)

  tsl_no_na <- tsl_handle_NA(tsl = tsl, na_action = "impute")

  expect_true(
    tsl_nrow == tsl_nrow(tsl = tsl_no_na) |>
      unlist() |>
      sum()
  )

  expect_equal(sum(unlist(tsl_count_NA(tsl = tsl_no_na))), 0)

})
