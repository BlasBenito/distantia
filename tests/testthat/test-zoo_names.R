test_that("`zoo_name_clean()` works", {
  x <- zoo_simulate()
  expect_equal(zoo_name_get(x = x), )
  x <- zoo_name_set(x = x, name = "My.New.name")
  expect_equal(zoo_name_get(x = x), )
  x <- zoo_name_clean(x = x, lowercase = TRUE)
  expect_equal(zoo_name_get(x = x), )
})

test_that("`zoo_name_get()` works", {
  x <- zoo_simulate()
  expect_equal(zoo_name_get(x = x), )
  x <- zoo_name_set(x = x, name = "My.New.name")
  expect_equal(zoo_name_get(x = x), )
  x <- zoo_name_clean(x = x, lowercase = TRUE)
  expect_equal(zoo_name_get(x = x), )
})

test_that("`zoo_name_set()` works", {
  x <- zoo_simulate()
  expect_equal(zoo_name_get(x = x), )
  x <- zoo_name_set(x = x, name = "My.New.name")
  expect_equal(zoo_name_get(x = x), )
  x <- zoo_name_clean(x = x, lowercase = TRUE)
  expect_equal(zoo_name_get(x = x), )
})
