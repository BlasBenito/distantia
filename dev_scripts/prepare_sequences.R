library(dplyr)

load("~/Dropbox/GITHUB/R_packages/distantia/data/sequencesMIS.RData")

id_column <- "MIS"
time_column <- "time"

sequences <- sequencesMIS |>
  dplyr::group_by(MIS) |>
  dplyr::mutate(
    time = 1:dplyr::n()
  ) |>
  as.data.frame()
