test_that("`distantia_matrix()` works", {

  tsl <- tsl_aggregate(
    tsl_subset(
      tsl_initialize(
      x = covid_prevalence,
      name_column = "name",
      time_column = "time"
    ),
    names = 1:5
    ),
    new_time = "months",
    method = sum
  )


  distantia_df <- distantia(
    tsl = tsl,
    lock_step = c(TRUE, FALSE)
    )

  distantia_matrix <- distantia_matrix(
    df = distantia_df
    )

  expect_equal(length(distantia_matrix), 2)

  expect_true(all(unique(unlist(lapply(X = distantia_matrix, FUN = class))) %in% c("matrix", "array")))

})
