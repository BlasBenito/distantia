library(microbenchmark)

x <- runif(100000)
y <- runif(100000)

#manhattan distance
microbenchmark::microbenchmark(
  manhattan(x, y),
  distance_manhattan(x, y)
)

#euclidean distance
microbenchmark::microbenchmark(
  euclidean(x, y),
  distance_euclidean(x, y)
)

#hellinger distance
microbenchmark::microbenchmark(
  hellinger(x, y),
  distance_hellinger(x, y)
)

#chi distance
microbenchmark::microbenchmark(
  chi(x, y),
  distance_chi(x, y)
)
