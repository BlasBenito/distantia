#three time series
#climate and ndvi in Fagus sylvatica stands in Spain, Germany, and Sweden
data("fagus_dynamics")

tsl <- tsl_initialize(
  x = fagus_dynamics,
  id_column = "site",
  time_column = "date"
)

if(interactive()){
  tsl_plot(
    tsl = tsl,
    scale = TRUE,
    guide_columns = 3
    )
}

#dynamic time warping dissimilarity analysis
#-------------------------------------------
tsl_dtw <- distantia(
  tsl = tsl,
  distance = "euclidean",
  repetitions = 30, #please, increase to 100 or more
  permutation = "restricted"
)

#focus on the important details
tsl_dtw[, c("x", "y", "psi", "p_value")]
#higher psi values indicate higher dissimilarity
#p-values indicate the chance of finding a psi smaller than the observed when the data is permuted.

#dlock-step dissimilarity analysis
#---------------------------------
tsl_lock_step <- distantia(
  tsl = tsl,
  distance = "euclidean",
  repetitions = 30, #please, increase to 100 or more
  permutation = "restricted_by_row",
  lock_step = TRUE
)

#focus on the important details
tsl_lock_step[, c("x", "y", "psi", "p_value")]
#


null_psi_cpp(
  x = tsl[[2]],
  y = tsl[[3]],
  repetitions = 100,
  permutation = "restricted_by_row",
  block_size = 21
) |>
  mean()
