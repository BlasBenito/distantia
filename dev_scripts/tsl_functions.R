library(distantia)

data("abernethy_a")
data("abernethy_b")

tsl <- tsl_initialize(
  x = list(
    a = abernethy_a,
    b = abernethy_b
  )
)

tsl.hellinger <- tsl_transform(
  tsl = tsl,
  f = f_hellinger
)

tsl <- tsl_handle_NA(
  tsl = tsl,
  na_action = "impute"
)

tsl.hellinger <- tsl_transform(
  tsl = tsl,
  f = f_hellinger
)

tsl.raw <- tsl_transform(
  tsl = tsl,
  f = base::scale,
  center = TRUE,
  scale = TRUE
)

tsl.scale <- tsl_transform(
  tsl = tsl,
  f = f_scale
)

tsl.center <- tsl_transform(
  tsl = tsl,
  f = f_center
)

tsl.prop <- tsl_transform(
  tsl = tsl,
  f = f_proportion
)

tsl.rollmean <- tsl_transform(
  tsl = tsl,
  f = zoo::rollmean,
  k = 5
)

tsl_plot(tsl.rollmean)

tsl.smooth <- tsl_transform(
  tsl = tsl,
  f = f_smooth,
  w = 10
)

tsl_plot(tsl.smooth)

tsl.stat <- tsl_transform(
  tsl = tsl,
  f = f_stat,
  statistic = sd,
  w = 10
)

tsl_plot(tsl.stat)

tsl.perc <- tsl_transform(
  tsl = tsl,
  f = f_percentage
)

tsl.hellinger <- tsl_transform(
  tsl = tsl,
  f = f_hellinger
)

tsl_names(tsl)

tsl <- tsl_names_set(
  tsl = tsl,
  names = c("A", "B")
)

tsl_names(tsl)

tsl_colnames(
  tsl = tsl,
  names = "all"
  )

tsl_colnames(
  tsl = tsl,
  names = "shared"
)

tsl_colnames(
  tsl = tsl,
  names = "exclusive"
)

tsl <- tsl_colnames_set(
  tsl = tsl,
  names = list(
    artemi = "Artemisia",
    gramin = "Gramineas"
  )
)

tsl <- tsl_colnames_clean(
  tsl = tsl,
  capitalize_all = FALSE,
  length = 5
)

tsl_colnames(
  tsl = tsl,
  names = "all"
)

tsl <- tsl_remove_exclusive_cols(
  tsl = tsl
)

tsl_colnames(
  tsl = tsl,
  names = "all"
)


tsl <- tsl_subset(
  tsl = tsl,
  names = c("A", "B"),
  colnames = c("betul", "pinus")
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
