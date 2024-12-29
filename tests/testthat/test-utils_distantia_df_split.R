test_that("`utils_distantia_df_split()` works", {
  tsl <- tsl_initialize(
    x = fagus_dynamics, name_column = "name",
    time_column = "time"
  )
  df <- distantia(
    tsl = tsl, distance = c("euclidean", "manhattan"),
    lock_step = c(TRUE, FALSE)
  )
  df_split <- utils_distantia_df_split(df = df)
  expect_equal(df_split, )
  expect_equal(class(df_split), )
  expect_equal(length(df_split), )
})
