test_that("`distantia_aggregate()` works", {

  tsl <- tsl_transform(
    tsl_initialize(
    x = fagus_dynamics,
    name_column = "name",
    time_column = "time"
  ),
  f = f_scale_global
  )


  df <- distantia(
    tsl = tsl,
    distance = c("euclidean", "manhattan"),
    lock_step = TRUE
  )


  df <- distantia_aggregate(
    df = df,
    f = mean
    )

  expect_true(all(colnames(df) %in% c("x", "y", "psi")))

})
