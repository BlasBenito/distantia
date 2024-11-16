#' #parallelization setup (not worth it for this data size)
future::plan(
  future::multisession,
  workers = 2 #set to parallelly::availableWorkers() - 1
)

#progress bar (does not work in examples)
# progressr::handlers(global = TRUE)

# yearly aggregation
#----------------------------------
#long-term monthly temperature of 20 cities
tsl <- tsl_initialize(
  x = cities_temperature,
  name_column = "name",
  time_column = "time"
)

#plot time series
if(interactive()){
  tsl_plot(
    tsl = tsl[1:4],
    guide_columns = 4
    )
}

#check time features
tsl_time(tsl)[, c("name", "resolution", "units")]

#many observations per year
#different starting and ending dates

#aggregation: mean daily values
tsl_year <- tsl_aggregate(
  tsl = tsl,
  new_time = "year",
  method = mean
)

#' #check time features
tsl_time(tsl_year)[, c("name", "resolution", "units")]

if(interactive()){
  tsl_plot(
    tsl = tsl_year[1:4],
    guide_columns = 4
  )
}


# other supported keywords
#----------------------------------

#simulate full range of calendar dates
tsl <- tsl_simulate(
  n = 2,
  rows = 1000,
  time_range = c(
    "0000-01-01",
    as.character(Sys.Date())
    )
)

#mean value by millennia (extreme case!!!)
tsl_millennia <- tsl_aggregate(
  tsl = tsl,
  new_time = "millennia",
  method = mean
)

if(interactive()){
  tsl_plot(tsl_millennia)
}

#max value by centuries
tsl_century <- tsl_aggregate(
  tsl = tsl,
  new_time = "century",
  method = max
)

if(interactive()){
  tsl_plot(tsl_century)
}

#quantile 0.75 value by centuries
tsl_centuries <- tsl_aggregate(
  tsl = tsl,
  new_time = "centuries",
  method = stats::quantile,
  probs = 0.75 #argument of stats::quantile()
)

#disable parallelization
future::plan(
  future::sequential
)
