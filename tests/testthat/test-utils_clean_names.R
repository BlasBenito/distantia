test_that("`utils_clean_names()` works", {

  x <- c("GerMany", "spain", "SWEDEN")

  expect_true(
    all(
      utils_clean_names(x = x, capitalize_all = TRUE, length = 4) == c("GRMN", "SPAN", "SWED")
      )
    )

  expect_true(
    all(
      utils_clean_names(
        x = x, capitalize_first = TRUE, separator = "_",
        prefix = "my_prefix", suffix = "my_suffix"
      ) == c("My_prefix_GerMany_my_suffix", "My_prefix_spain_my_suffix", "My_prefix_SWEDEN_my_suffix")
    )
  )

})
