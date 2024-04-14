# numeric ----
tsl <- tsl_simulate(
  time_range = c(
    0.1,
    0.99
  )
)

breaks <- utils_time_breaks_type(
  tsl = tsl,
  breaks = 0.1
)
attributes(breaks)


breaks <- utils_time_breaks_type(
  tsl = tsl,
  breaks = 0.01
)
attributes(breaks)

breaks <- utils_time_breaks_type(
  tsl = tsl,
  breaks = c(
    0.25,
    0.50,
    0.75
  )
)
attributes(breaks)

breaks <- utils_time_breaks_type(
  tsl = tsl,
  breaks = c(
    0.01,
    0.50,
    0.75,
    2
  )
)
attributes(breaks)



# Date ----
tsl <- tsl_simulate(
  time_range = c(
    "0100-02-08",
    "2024-12-31"
  )
)

#works
breaks <- utils_time_breaks_type(
  tsl = tsl,
  breaks = "millenia"
)
attributes(breaks)


#works
breaks <- utils_time_breaks_type(
  tsl = tsl,
  breaks = "century"
)
attributes(breaks)

#works
breaks <- utils_time_breaks_type(
  tsl = tsl,
  breaks = "decade"
)
attributes(breaks)

#works
breaks <- utils_time_breaks_type(
  tsl = tsl,
  breaks = 10000
)
attributes(breaks)


#works
breaks <- utils_time_breaks_type(
  tsl = tsl,
  breaks = 50000
)
attributes(breaks)

#works
breaks <- utils_time_breaks_type(
  tsl = tsl,
  breaks = c(
    "0150-01-01",
    "1500-12-02",
    "1800-12-02",
    "2000-01-02"
  )
)
attributes(breaks)

breaks <- utils_time_breaks_type(
  tsl = tsl,
  breaks = c(
    "0150-01-01 12:00:25",
    "1500-12-02 11:15:45",
    "1800-12-02 11:15:45",
    "2000-01-02 12:00:25"
  )
)
attributes(breaks)

# POSItslct ----
tsl <- tsl_simulate(
  time_range = c(
    "0100-01-01 12:00:25",
    "2024-12-31 11:15:45"
  )
)


#works
breaks <- utils_time_breaks_type(
  tsl = tsl,
  breaks = "millenia"
)
attributes(breaks)

#works
breaks <- utils_time_breaks_type(
  tsl = tsl,
  breaks = "century"
)
attributes(breaks)

#works
breaks <- utils_time_breaks_type(
  tsl = tsl,
  breaks = "decade"
)
attributes(breaks)

#works
breaks <- utils_time_breaks_type(
  tsl = tsl,
  breaks = 10000
)
attributes(breaks)


#works
breaks <- utils_time_breaks_type(
  tsl = tsl,
  breaks = 50000
)
attributes(breaks)

#works
breaks <- utils_time_breaks_type(
  tsl = tsl,
  breaks = c(
    "0150-01-01",
    "1500-12-02",
    "1800-12-02",
    "2000-01-02"
  )
)
attributes(breaks)





































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

#POSItslct
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
