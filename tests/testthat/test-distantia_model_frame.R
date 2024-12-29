test_that("`distantia_model_frame()` works", {

  tsl <- tsl_initialize(
    x = covid_prevalence, name_column = "name",
    time_column = "time"
  )

  df <- distantia_ls(tsl = tsl)

  composite_predictors <- list(economy = c(
    "poverty_percentage",
    "median_income", "domestic_product"
  ))

  model_frame <- distantia_model_frame(
    response_df = df, predictors_df = covid_counties,
    composite_predictors = composite_predictors, scale = TRUE
  )

  expect_equal(class(model_frame), "data.frame")

  expect_true("economy" %in% colnames(model_frame))

  expect_true("geographic_distance" %in% colnames(model_frame))

  expect_equal(attributes(model_frame)$response, "psi")

  model <- lm(formula = attributes(model_frame)$formula, data = model_frame)

  expect_equal(class(model), "lm")

})
