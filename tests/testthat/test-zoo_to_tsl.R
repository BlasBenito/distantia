test_that("`zoo_to_tsl()` works", {
  x <- zoo_simulate()

  tsl <- zoo_to_tsl(x = x)
  expect_equal(class(tsl), "list")
  expect_equal(class(tsl[[1]]), "zoo")
  expect_equal(names(tsl), "A")
  expect_equal(attributes(tsl[[1]])$name, "A")
})
