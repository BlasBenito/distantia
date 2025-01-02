test_that("`tsl_join()` works", {

  tsl_a <- tsl_simulate(
    n = 2,
    cols = 2,
    irregular = TRUE,
    seed = 1
    )

  tsl_b <- tsl_simulate(
    n = 3,
    cols = 2,
    irregular = TRUE,
    seed = 2
  ) |>
    tsl_colnames_set(names = c("c", "d"))

  #NA interpolation message
  expect_message(
    tsl <- tsl_join(tsl_a, tsl_b)
    )

  expect_true(
    all(
      tsl_colnames_get(tsl)$a == c("a", "b", "c", "d")
    )
  )
  expect_true(
    all(
      tsl_colnames_get(tsl)$b == c("a", "b", "c", "d")
    )
  )

})
