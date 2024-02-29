library(distantia)

data("abernethy_a")
data("abernethy_b")

tsl <- tsl_initialize(
  x = list(
    a = abernethy_a,
    b = abernethy_b
  )
)

tsl <- tsl_handle_NA(
  tsl = tsl,
  na_action = "impute"
)

tsl_get_names(tsl)

tsl <- tsl_set_names(
  tsl = tsl,
  names = c("Aber_A", "Aber_B")
)

tsl_get_names(tsl)

tsl_get_colnames(
  tsl = tsl,
  get = "all"
  )

tsl <- tsl_subset(
  tsl = tsl,
  names = c("Aber_A", "Aber_B"),
  colnames = c("betula", "corylu")
)


tsl_plot(
  tsl = tsl,
  guide_columns = 2
  )





x <- tsl_transform(
  x = x,
  f = f_scale
)

x <- tsl_transform(
  x = x,
  f = scale,
  center = TRUE,
  scale = TRUE
)


data(mis)

#function to initialize a set of time series
y <- tsl_initialize(
  x = mis,
  id_column = "MIS"
)



#function to subset a set time series
y <- tsl_subset(
  x = y,
  sequences = c("MIS-1", "MIS-2", "MIS-3"),
  variables = c("Quercus", "Carpinus"),
  time = c(1, 20)
)

#function to plot a set of time-series
tsl_plot(
  x = y,
  columns = 2
)












y.distantia <- distantia(
  x = y
)

plot_sequence(
  x = y[[3]]
)

plot_sequences(
  x = y,
  columns = 2,
  guide_columns = 1
)


plot_distantia(
  x = y[[1]],
  y = y[[2]],
  line_scale = TRUE,
  line_center = TRUE
)
