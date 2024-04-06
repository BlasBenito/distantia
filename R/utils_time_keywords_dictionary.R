#' Dictionary of Time Keywords and Accepted Patterns for Date and POSIXct Time Classes
#'
#' @description
#' Dictionary of accepted time keywords for time aggregation for the classes Date and POSIXct.
#'
#'
#' @param keyword (optional, keyword) If provided, it is compared with the "pattern" column of the dictionary, and the matching keyword is returned. If NULL, the complete dictionary is returned. Default: NULL
#'
#' @return Corrected keyword, or data frame with dictionary.
#' @export
#' @autoglobal
#' @examples
utils_time_keywords_dictionary <- function(
  keyword = NULL
){

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
    stack()

  names(dictionary) <- c("pattern", "keyword")


  if(!is.null(keyword)){
    if(keyword %in% dictionary$pattern){
      return(
        dictionary[
          dictionary$pattern == keyword,
          "keyword"]
      )
    } else {
      return(NULL)
    }
  }


  dictionary

}
