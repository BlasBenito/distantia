test_that("`tsl_names` works", {

  tsl <- tsl_initialize(
    x = fagus_dynamics,
    name_column = "name",
    time_column = "time"
  )

  tsl_clean <- tsl_names_clean(
    tsl = tsl,
    capitalize_first = TRUE,
    length = 4
  )

  expect_true(
    all(tsl_names_get(tsl = tsl_clean) == c("Grmn", "Span", "Swdn")
        )
    )

  tsl <- tsl_names_set(tsl = tsl, names = c("X", "Y", "Z"))

  expect_true(all(tsl_names_get(tsl = tsl) %in% c("X", "Y", "Z")))

})
