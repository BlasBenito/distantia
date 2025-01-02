test_that("`tsl_time()` works", {

  tsl <- tsl_simulate(
    n = 3,
    rows = 150,
    time_range = c(Sys.Date() -
    365, Sys.Date()),
    irregular = TRUE
    )

  df <- tsl_time(tsl = tsl)

  expect_equal(class(df), "data.frame")
  expect_equal(nrow(df), length(tsl))
  expect_true(all(df$name ==  tsl_names_get(tsl)))

})
