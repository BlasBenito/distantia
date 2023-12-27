library(dplyr)

load("~/Dropbox/GITHUB/R_packages/distantia/data/sequencesMIS.RData")

id_column <- "MIS"

x <- lapply(
  x,
  FUN = function(x){
    as.matrix(x)
  }
)

#WITHOUT TIME
x <- prepare_sequences(
  x = sequencesMIS,
  id_column = id_column,
  time_column = NULL,
  transformation = f_hellinger,
  paired_samples = FALSE
)

#WITH TIME
time_column <- "time"

sequences_time <- sequencesMIS |>
  dplyr::group_by(MIS) |>
  dplyr::mutate(
    time = 1:dplyr::n()
  ) |>
  as.data.frame()

x <- prepare_sequences(
  x = sequences_time,
  id_column = id_column,
  time_column = time_column,
  transformation = f_hellinger,
  paired_samples = FALSE
)

a <- x[[1]]
b <- x[[2]]
