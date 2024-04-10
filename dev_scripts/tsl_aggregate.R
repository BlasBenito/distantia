
# Date ----
x <- tsl_simulate(
  time_range = c(
    "0100-02-08",
    "2024-12-31"
  )
)

#works
utils_time_breaks_type(
  x = x,
  breaks = "millenia"
)

#works
utils_time_breaks_type(
  x = x,
  breaks = "century"
)

#works
utils_time_breaks_type(
  x = x,
  breaks = "decade"
)

#works
utils_time_breaks_type(
  x = x,
  breaks = 10000
)


#works
utils_time_breaks_type(
  x = x,
  breaks = 50000
)

#works
utils_time_breaks_type(
  x = x,
  breaks = c(
    "0150-01-01",
    "1500-12-02",
    "1800-12-02",
    "2000-01-02"
  )
)

# POSIXct ----
x <- tsl_simulate(
  time_range = c(
    "0100-01-01 12:00:25",
    "2024-12-31 11:15:45"
  )
)

#works
utils_time_breaks_type(
  x = x,
  breaks = "millenia"
)

#works
utils_time_breaks_type(
  x = x,
  breaks = "century"
)

#works
utils_time_breaks_type(
  x = x,
  breaks = "decade"
)

#works
utils_time_breaks_type(
  x = x,
  breaks = 10000
)


#works
utils_time_breaks_type(
  x = x,
  breaks = 50000
)

#works
utils_time_breaks_type(
  x = x,
  breaks = c(
    "0150-01-01",
    "1500-12-02",
    "1800-12-02",
    "2000-01-02"
  )
)





































breaks <- "centuries"
breaks <- "decades"
breaks <- "years"
breaks <- "quarters"
breaks <- "months"
breaks <- "weeks"
breaks <- c(
  "0150-01-01",
  "1500-12-02",
  "1800-12-02",
  "2000-01-02"
)

#POSIXct
tsl <- tsl_simulate(
  time_range = c(
    "0100-01-01 12:00:25",
    "2024-12-31 11:15:45"
  )
)

breaks <- "millennia"
breaks <- "centuries"
breaks <- "decades"
breaks <- "years"
breaks <- "quarters"
breaks <- "months"
breaks <- "weeks"
breaks <- "hours"
breaks <- c(
  "0150-01-01",
  "1500-12-02",
  "1800-12-02",
  "2000-01-02"
)
breaks <- 50000


#numeric
tsl <- tsl_simulate(
  time_range = c(-123120, 1200)
)

breaks <- "1e4"
breaks <- 1000
breaks <- 100

#decimal
tsl <- tsl_simulate(
  time_range = c(0.01, 0.09)
)

breaks <- 0.001
