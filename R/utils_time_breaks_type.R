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
#' @param keywords (optional, character) Aggregation keywords as returned by [utils_time_breaks_keywords()].
#'
#' @return Character string, breaks type.
#' @export
#' @autoglobal
#' @examples
utils_time_breaks_type <- function(
    breaks = NULL,
    keywords = NULL
    ){

  if(length(breaks) == 1){


    if(is.numeric(breaks)){
      return("numeric")
    }

    if(is.character(keywords)){

      keyword <- utils_time_keywords_dictionary(
        keyword = breaks
      )

    }

    if(!is.null(keyword)){
      return("keyword")
    }

    stop("Breaks of length one must either be numeric or a valid keyword as returned by 'utils_time_breaks_keywords()'.")

  }

  if(is.numeric(breaks)){
    return("numeric_vector")
  }

  if(is.character(breaks)){
    breaks <- utils_as_time(
      x = breaks
    )
  }

  if("POSIXct" %in% class(breaks)){
    return("POSIXct_vector")
  }

  if("Date" %in% class(breaks)){
    return("Date_vector")
  }

  "invalid"

}

