test_that("`tsl_initialize()` works", {

  #from data frame
  tsl <- tsl_initialize(
    x = fagus_dynamics,
    name_column = "name",
    time_column = "time"
  )

  expect_equal(
    unique(sapply(X = tsl, FUN = class)), "zoo"
    )

  expect_true(
    all(tsl_names_get(tsl = tsl, zoo = TRUE) %in% c("Germany", "Spain", "Sweden")
        )
    )

  #from zoo objects
  tsl <- tsl_initialize(
    x = list(
      x = zoo_simulate(),
      y = zoo_simulate()
      )
    )

  expect_true(length(tsl) == 2)
  expect_true(all(tsl_names_get(tsl) %in% c("x", "y")))

  #from wide data frame
  df <- stats::reshape(
    data = fagus_dynamics[, c(
      "name", "time",
      "evi"
    )], timevar = "name", idvar = "time", direction = "wide",
    sep = "_"
  )

  tsl <- tsl_initialize(x = df, time_column = "time")

  expect_equal(
    unique(unlist(tsl_colnames_get(tsl))),
    "x"
    )

  #from vector list
  vector_list <- list(
    a = cumsum(stats::rnorm(n = 50)),
    b = cumsum(stats::rnorm(n = 70)),
    c = cumsum(stats::rnorm(n = 20))
  )

  tsl <- tsl_initialize(x = vector_list)

  expect_equal(
    unique(unlist(tsl_colnames_get(tsl))),
    "x"
  )

  #from matrix list
  matrix_list <- list(
    a = matrix(runif(30), nrow = 10, ncol = 3),
    b = matrix(runif(80), nrow = 20, ncol = 4)
  )

  tsl <- tsl_initialize(x = matrix_list)

  expect_equal(
    tsl_colnames_get(tsl = tsl)$a, c("x1", "x2", "x3")
    )

  expect_equal(
    tsl_colnames_get(tsl = tsl)$b, c("x1", "x2", "x3", "x4")
  )

})
