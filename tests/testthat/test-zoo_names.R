test_that("`zoo_name_clean()` works", {

  x <- zoo_simulate()
  expect_equal(zoo_name_get(x = x), "A")

  x <- zoo_name_set(x = x, name = "My.New.name")
  expect_equal(zoo_name_get(x = x), "My.New.name")

  x <- zoo_name_clean(x = x, lowercase = TRUE)
  expect_equal(zoo_name_get(x = x), "my_new_name")

})
