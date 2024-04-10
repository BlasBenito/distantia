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

  tsl <- tsl_is_valid(
    tsl = tsl
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

  # numeric ----
  if("numeric" %in% class(breaks)){

    # length 1 ----
    if(length(breaks) == 1){

      if(
        tsl_time$class == "numeric")

      if(breaks >= min(tsl_time$units_df$threshold)){

        attr(
          x = breaks,
          which = "type"
        ) <- "numeric"

        return(breaks)

    }

  }


  # breaks length 1 ----
  if(length(breaks) == 1){

    # numeric ----
    if("numeric" %in% class(breaks)){

      if(breaks >= min(tsl_time$units_df$threshold)){

        attr(
          x = breaks,
          which = "type"
        ) <- "numeric"

        return(breaks)

      }

    }


    # Date or POSIXct
    breaks <- utils_coerce_time_class(
      x = breaks,
      to = tsl_time$class
    )

    # POSIXct ----
      if("POSIXct" %in% class(breaks)){

        attr(
          x = breaks,
          which = "type"
        ) <- "POSIXct"

        return(breaks)

    }

    # Date ----
      if("Date" %in% class(breaks)){

        attr(
          x = breaks,
          which = "type"
        ) <- "Date"

        return(breaks)

    }



    # keyword ----
    if(is.character(breaks)){

      breaks <- utils_time_keywords_translate(
        keyword = breaks
      )

      if(breaks %in% tsl_time$keywords){

        attr(
          x = breaks,
          which = "type"
        ) <- "keyword"

        return(breaks)

      }

    }

    return(NA)

  }

  # numeric_vector ----
  if(is.numeric(breaks) && tsl_time$class == "numeric"){

    attr(
      x = breaks,
      which = "type"
    ) <- "numeric_vector"

    return(breaks)

  }

  if(
    "POSIXct" %in% class(breaks) &&
    tsl_time$class == "POSIXct"
  ){

    attr(
      x = breaks,
      which = "type"
    ) <- "POSIXct_vector"

    return(breaks)

  }


  if(
    "Date" %in% class(breaks) &&
    tsl_time$class == "Date"
  ){

    attr(
      x = breaks,
      which = "type"
    ) <- "Date_vector"

    return(breaks)

  }

  NA

}

