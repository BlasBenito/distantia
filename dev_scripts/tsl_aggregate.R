tsl <- tsl_simulate(
  time_range = c(
    "0100-01-01 12:00:25",
    "2024-12-31 11:15:45"
  )
)


#DOES NOT WORK, FIX THIS!
x <- tsl_aggregate(
  tsl = tsl,
  breaks = 50000
)
tsl_plot(x)






# numeric ----
tsl <- tsl_simulate(
  time_range = c(
    0.1,
    0.99
  )
)

tsl_plot(tsl)

x <- tsl_aggregate(
  tsl = tsl,
  breaks = 0.1
)

tsl_plot(x)

x <- tsl_aggregate(
  tsl = tsl,
  breaks = c(
    0.25,
    0.50,
    0.75
  )
)

tsl_plot(x)

x <- tsl_aggregate(
  tsl = tsl,
  breaks = "1e-1"
)

tsl_plot(x)





# Date ----
tsl <- tsl_simulate(
  time_range = c(
    "0100-02-08",
    "2024-12-31"
  )
)

tsl_plot(tsl, guide = FALSE)

tsl_aggregated <- tsl_aggregate(
  tsl = tsl,
  breaks = "century"
)
tsl_plot(x, guide = FALSE)

#works
x <- tsl_aggregate(
  tsl = tsl,
  breaks = "millenia"
)
tsl_plot(x)




#works
x <- tsl_aggregate(
  tsl = tsl,
  breaks = "century"
)
tsl_plot(x)

#works
x <- tsl_aggregate(
  tsl = tsl,
  breaks = "decade"
)
tsl_plot(x)

#works
x <- tsl_aggregate(
  tsl = tsl,
  breaks = 10000
)
tsl_plot(x)


#works
x <- tsl_aggregate(
  tsl = tsl,
  breaks = 50000
)
tsl_plot(x)

#works
x <- tsl_aggregate(
  tsl = tsl,
  breaks = c(
    "0150-01-01",
    "1500-12-02",
    "1800-12-02",
    "2000-01-02"
  )
)
tsl_plot(x)

x <- tsl_aggregate(
  tsl = tsl,
  breaks = c(
    "0150-01-01 12:00:25",
    "1500-12-02 11:15:45",
    "1800-12-02 11:15:45",
    "2000-01-02 12:00:25"
  )
)
tsl_plot(x)

# POSItslct ----
tsl <- tsl_simulate(
  time_range = c(
    "0100-01-01 12:00:25",
    "2024-12-31 11:15:45"
  )
)


#works
x <- tsl_aggregate(
  tsl = tsl,
  breaks = "millenia"
)
tsl_plot(x)

#works
x <- tsl_aggregate(
  tsl = tsl,
  breaks = "century"
)
tsl_plot(x)

#works
x <- tsl_aggregate(
  tsl = tsl,
  breaks = "decade"
)
tsl_plot(x)

#works
x <- tsl_aggregate(
  tsl = tsl,
  breaks = 10000
)
tsl_plot(x)




#works
x <- tsl_aggregate(
  tsl = tsl,
  breaks = c(
    "0150-01-01",
    "1500-12-02",
    "1800-12-02",
    "2000-01-02"
  )
)
tsl_plot(x)





































x <- "centuries"
x <- "decades"
x <- "years"
x <- "quarters"
x <- "months"
x <- "weeks"
x <- c(
  "0150-01-01",
  "1500-12-02",
  "1800-12-02",
  "2000-01-02"
)

#POSItslct
tsl <- tsl_simulate(
  time_range = c(
    "0100-01-01 12:00:25",
    "2024-12-31 11:15:45"
  )
)

x <- "millennia"
x <- "centuries"
x <- "decades"
x <- "years"
x <- "quarters"
x <- "months"
x <- "weeks"
x <- "hours"
x <- c(
  "0150-01-01",
  "1500-12-02",
  "1800-12-02",
  "2000-01-02"
)
x <- 50000


#numeric
tsl <- tsl_simulate(
  time_range = c(-123120, 1200)
)

x <- "1e4"
x <- 1000
x <- 100

#decimal
tsl <- tsl_simulate(
  time_range = c(0.01, 0.09)
)

x <- 0.001
