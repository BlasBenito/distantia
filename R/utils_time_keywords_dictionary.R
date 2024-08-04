#' Dictionary of Time Keywords
#'
#' @description
#' Data frame to help translate misnamed or abbreviated time keywords, like "day", "daily", or "d", into correct ones such as "days".
#'
#' @return Data frame.
#' @export
#' @autoglobal
#' @examples
#' TODO: complete example
utils_time_keywords_dictionary <- function(){

  # millennia ----
  millennia <- c(
    "millennia",
    "milennia",
    "millenia",
    "millennium",
    "millenium",
    "milennium",
    "milenium",
    "milenio",
    "thousands",
    "thousand",
    "1000 years",
    "1000 y",
    "1000years",
    "1000y"
  )

  millennia <- c(millennia, toupper(millennia))

  # centuries ----
  centuries <- c(
    "centuries",
    "century",
    "centenio",
    "100 years",
    "100years",
    "100 y",
    "100y"
  )

  centuries <- c(centuries, toupper(centuries))

  # decades ----
  decades <- c(
    "decades",
    "decad",
    "10 years",
    "10years",
    "10 y",
    "10y"
  )

  decades <- c(decades, toupper(decades))

  # years ----
  years <- c(
    "years",
    "year",
    "ys",
    "y"
  )

  years <- c(years, toupper(years))

  # quarters ----
  quarters <- c(
    "quarters",
    "quarter",
    "quarterly",
    "q",
    "3 months",
    "3months"
  )

  quarters <- c(quarters, toupper(quarters))

  # months ----
  months <- c(
    "months",
    "month",
    "monthly",
    "m",
    "30 days",
    "30days",
    "30 d",
    "30d"
  )

  months <- c(months, toupper(months))

  # weeks ----
  weeks <- c(
    "weeks",
    "week",
    "weekly",
    "w",
    "7 days",
    "7days",
    "7 d",
    "7d"
  )

  weeks <- c(weeks, toupper(weeks))

  # days ----
  days <- c(
    "days",
    "day",
    "daily",
    "d",
    "24 hours",
    "24hours",
    "24 h",
    "24h"
  )

  days <- c(days, toupper(days))

  # hours ----
  hours <- c(
    "hours",
    "hour",
    "hourly",
    "h",
    "60 minutes",
    "60minutes",
    "60 min",
    "60min",
    "60 m",
    "60m"
  )

  hours <- c(hours, toupper(hours))

  # minutes ----
  minutes <- c(
    "minutes",
    "minute",
    "min",
    "m",
    "60 seconds",
    "60seconds",
    "60 secs",
    "60secs",
    "60 s",
    "60s"
  )

  minutes <- c(minutes, toupper(minutes))

  # seconds ----
  seconds <- c(
    "seconds",
    "second",
    "sec",
    "s"
  )

  seconds <- c(seconds, toupper(seconds))

  dictionary <- list(
    millennia = millennia,
    centuries = centuries,
    decades = decades,
    years = years,
    quarters = quarters,
    months = months,
    weeks = weeks,
    days = days,
    hours = hours,
    minutes = minutes,
    seconds = seconds
  ) |>
    utils::stack()

  dictionary$ind <- as.character(dictionary$ind)

  names(dictionary) <- c("pattern", "keyword")

  dictionary

}
