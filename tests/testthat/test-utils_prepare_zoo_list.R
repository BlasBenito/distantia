test_that("`utils_prepare_zoo_list()` works", {
  x <- utils_prepare_zoo_list(
    x = list(
      spain = fagus_dynamics[fagus_dynamics$name == "Spain", ],
      sweden = fagus_dynamics[fagus_dynamics$name == "Sweden", ]
    ),
    time_column = "time"
  )

  expect_equal(class(x), "list")
  expect_equal(names(x), c("spain", "sweden"))
})
