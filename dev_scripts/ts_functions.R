library(distantia)

data("abernethy_a")
data("abernethy_b")

x <- ts_initialize(
  x = list(
    a = abernethy_a,
    b = abernethy_b
  )
)

ts_plot(x, guide_columns = 2)

x <- ts_handle_NA(
  x = x,
  na_action = "impute"
  )

x <- ts_transform(
  x = x,
  f = f_scale
)

x <- ts_transform(
  x = x,
  f = scale,
  center = TRUE,
  scale = TRUE
)


data(mis)

#function to initialize a set of time series
y <- ts_initialize(
  x = mis,
  id_column = "MIS"
)



#function to subset a set time series
y <- ts_subset(
  x = y,
  sequences = c("MIS-1", "MIS-2", "MIS-3"),
  variables = c("Quercus", "Carpinus"),
  time = c(1, 20)
)

#function to plot a set of time-series
ts_plot(
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
