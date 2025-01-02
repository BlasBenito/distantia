test_that("`zoo_simulate()` works", {
  x <- zoo_simulate(seed = 1)
  expect_equal(class(x), "zoo")
  expect_equal(attributes(x)$name, "A")
  expect_equal(names(x), c("a", "b", "c", "d", "e"))
})
