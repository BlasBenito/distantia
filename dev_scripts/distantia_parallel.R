library(distantia)
library(tictoc)

load("~/Dropbox/GITHUB/R_packages/distantia/data/sequencesMIS.RData")

#data frame with grouping column
###################################
x <- prepare_sequences(
  x = sequencesMIS,
  id_column = "MIS",
  time_column = NULL,
  transformation = f_hellinger,
  paired_samples = FALSE,
  pseudo_zero =  0.001,
  na_action = "to_zero"
)

tic()
z0 <- importance(
  x = x,
  distance = "euclidean",
  diagonal = TRUE,
  weighted = TRUE,
  ignore_blocks = FALSE
)
toc()

#parallel
future::plan(
  strategy = future::multisession(),
  workers = 4
)

tic()
z1 <- importance(
  x = x,
  distance = "euclidean",
  diagonal = TRUE,
  weighted = TRUE,
  ignore_blocks = FALSE
)
toc()


y0 <- distantia(
  x = x,
  distance = "euclidean",
  diagonal = TRUE,
  weighted = TRUE,
  ignore_blocks = FALSE,
  repetitions = 0
)

progressr::handlers("cli")
progressr::handlers(global = TRUE)

#sequential no plan
tic()
y1 <- distantia(
  x = x,
  distance = "euclidean",
  diagonal = TRUE,
  weighted = TRUE,
  ignore_blocks = FALSE,
  repetitions = 100
)
toc()
# 26.515 sec elapsed

#sequential with plan
future::plan(strategy = sequential)
tic()
y2 <- distantia(
  x = x,
  distance = "euclidean",
  diagonal = TRUE,
  weighted = TRUE,
  ignore_blocks = FALSE,
  repetitions = 100
)
toc()
# 28.077 sec elapsed


#parallel
future::plan(
  strategy = future::multisession(),
  workers = 4
)

tic()
y3 <- distantia(
  x = x,
  distance = "euclidean",
  diagonal = TRUE,
  weighted = TRUE,
  ignore_blocks = FALSE,
  repetitions = 100
)
toc()
# 17.422 sec elapsed
