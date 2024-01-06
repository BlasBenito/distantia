library(dplyr)
library(distantia)
library(tictoc)
library(progressr)

load("~/Dropbox/GITHUB/R_packages/distantia/data/sequencesMIS.RData")

#data frame with grouping column
###################################
x <- sequencesMIS

id_column <- "MIS"
time_column <- NULL
transformation = f_hellinger
paired_samples = FALSE
pseudo_zero = 0.001
na_action = NULL

x <- prepare_sequences(
  x = x,
  id_column = id_column,
  time_column = time_column,
  transformation = transformation,
  paired_samples = paired_samples,
  pseudo_zero = pseudo_zero,
  na_action = na_action
)



#parallel
progressr::handlers("progress")
progressr::handlers(global = TRUE)
future::plan(
  strategy = future::multisession(),
  workers = 4
)

tic()
y1 <- distantia_parallel(
  x = x,
  distance = c("euclidean", "manhattan"),
  diagonal = TRUE,
  weighted = TRUE,
  ignore_blocks = FALSE,
  repetitions = 1000,
  workers = 4
)
toc()
# 80.829 sec elapsed

#sequential 1
future::plan(
  strategy = future::sequential()
)
tic()
y2 <- distantia_parallel(
  x = x,
  distance = c("euclidean", "manhattan"),
  diagonal = TRUE,
  weighted = TRUE,
  ignore_blocks = FALSE,
  repetitions = 1000,
  workers = 1
)
toc()
# 132.05 sec elapsed

#sequential 2
tic()
y3 <- distantia(
  x = x,
  distance = c("euclidean", "manhattan"),
  diagonal = TRUE,
  weighted = TRUE,
  ignore_blocks = FALSE,
  repetitions = 1000
)
toc()
# 135.99 sec elapsed
