test_that("`utils_new_time()` works", {

  tsl <- tsl_initialize(
    x = fagus_dynamics, name_column = "name",
    time_column = "time"
  )

  expect_equal(tsl_time_summary(tsl = tsl, keywords = "aggregate")$keywords, c("decades", "years", "quarters"))

  expect_message(
    new_time <- utils_new_time(tsl = tsl, new_time = NULL, keywords = "aggregate")
  )

  expect_equal(
    unique(
      as.numeric(
        diff(new_time)
        )
      ),
    c(90, 91, 92)
    )

})
