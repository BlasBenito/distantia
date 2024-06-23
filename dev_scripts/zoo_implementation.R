# https://faculty.washington.edu/ezivot/econ424/Working%20with%20Time%20Series%20Data%20in%20R.pdf

library(dplyr)
library(distantia)
library(xts)

load("~/Dropbox/GITHUB/R_packages/distantia/data/mis.RData")

#matrix
#####################################
data(mis)

x <- prepare_sequences(
  x = mis,
  id_column = "MIS"
)

y <- x[[1]]

y.zoo <- zoo::zoo(
  x = y,
  order.by = attributes(y)$time
)

attr(y.zoo, "name") <- "MIS-3"
attr(y.zoo, "time") <- attributes(y.zoo)$index
attr(y.zoo, "validated") <- TRUE
is.zoo(y.zoo)

plot_sequence(y.zoo)
