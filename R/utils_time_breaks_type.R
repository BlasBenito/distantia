#' Type of Aggregation Time Breaks
#'
#' @description
#' Internal function to identify the type of time breaks used for time series aggregation.
#'
#'
#' @param breaks (required, numeric, numeric vector, or keyword) definition of the aggregation groups. There are several options:
#' \itemize{
#'   \item keyword: Only when time in tsl is either a date "YYYY-MM-DD" or a datetime "YYYY-MM-DD hh-mm-ss". Valid options are "year", "quarter", "month", and "week" for date, and, "day", "hour", "minute", and "second" for datetime.
#' }
#'
#' @return Character string, breaks type.
#' @export
#' @autoglobal
#' @examples
utils_time_breaks_type <- function(
    x = NULL,
    breaks = NULL
){

  # tsl
  tsl <- zoo_to_tsl(
    x = x
  )

  tsl_time <- tsl_time_summary(
    tsl = tsl
  )

  # ERROR: too many time classes ----
  if(length(tsl_time$class) > 1){
    #TODO: implement function to homogenize time class of tsl
    stop(
      "The time class of all zoo objects in 'tsl' must be the same, but they are: '",
      paste(tsl_time$class, collapse = "', '"),
      "'."
    )
  }

  # breaks length 1 ----
  if(length(breaks) == 1){


    if(
      "POSIXct" %in% class(breaks) &&
      tsl_time$class == "POSIXct"
    ){
      return("POSIXct")
    }


    if(
      "Date" %in% class(breaks) &&
      tsl_time$class == "Date"
    ){
      return("Date")
    }

    # numeric ----
    if(is.numeric(breaks)){

      if(breaks >= min(tsl_units$threshold)){
        return("numeric")
      }

    }

    # keyword ----
    if(is.character(breaks)){

      breaks <- utils_time_keywords_translate(
        keyword = breaks
      )

      valid_keywords <- utils_time_keywords(
        x = x
      )

      if(breaks %in% valid_keywords){
        return("keyword")
      }

    }

    return(NA)

  }

  # breaks vector ----
  breaks_test <- breaks[
    breaks >= tsl_begin & breaks <= tsl_end
  ]


  # numeric_vector ----
  if(is.numeric(breaks) && tsl_time$class == "numeric"){
    return("numeric_vector")
  }

  if(is.character(breaks)){
    breaks <- utils_as_time(
      x = breaks
    )
  }


  if(
    "POSIXct" %in% class(breaks) &&
    tsl_time$class == "POSIXct"
    ){
    return("POSIXct_vector")
  }


  if(
    "Date" %in% class(breaks) &&
    tsl_time$class == "Date"
    ){
    return("Date_vector")
  }

  NA

}

