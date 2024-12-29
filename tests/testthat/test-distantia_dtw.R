test_that("`distantia_dtw()` works", {

  tsl <- tsl_transform(
    tsl_initialize(
    x = fagus_dynamics,
    name_column = "name",
    time_column = "time"
  ),
  f = f_scale_global
  )


  df_dtw <- distantia_dtw(
    tsl = tsl,
    distance = "euclidean"
    )

  expect_true(is.data.frame(df_dtw))

  expect_equal(colnames(df_dtw), c("x", "y", "distance", "psi"))

})
