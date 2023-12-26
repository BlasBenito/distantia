library(dplyr)

load("~/Dropbox/GITHUB/R_packages/distantia/data/sequencesMIS.RData")

id_column <- "MIS"
time_column <- "time"

sequences_time <- sequencesMIS |>
  dplyr::group_by(MIS) |>
  dplyr::mutate(
    time = 1:dplyr::n()
  ) |>
  as.data.frame()


x <- prepare_sequences(
  sequences = sequences_time,
  id_column = "MIS",
  time_column = "time",
  transformation = f_scale,
  paired_samples = TRUE
)

dplyr::glimpse(x[[1]])



sequences <- sequencesMIS
