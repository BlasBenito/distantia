test_that("`zoo_to_tsl()` works", {
  x <- zoo_simulate()
  expect_equal(class(x), )
  tsl <- zoo_to_tsl(x = x)
  expect_equal(class(tsl), )
  expect_equal(class(tsl[[1]]), )
  expect_equal(names(tsl), )
  expect_equal(attributes(tsl[[1]])$name, )
})
