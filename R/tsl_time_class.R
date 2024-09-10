#' Coerce Elements of Time Series List to same Time Class
#'
#' @param tsl (required, list) Time series list. Default: NULL
#' @param to (required, class name) class to coerce `x` to. Either "Date", "POSIXct", "integer" or "numeric". If NULL, coerces to the majority time class. Default: NULL
#'
#' @return time series list
#' @export
#' @autoglobal
#' @examples
#' #TODO missing example
#' @family data_preparation
tsl_time_class_set <- function(
    tsl = NULL,
    to = NULL
){

  #TODO: write this function and review utils_coerce_time_class()
  #TODO: write function time_class_get() in this same file

  utils_check_args_tsl(
    tsl = tsl,
    min_length = 1
  )

  if(is.null(to)){

    time_class_table <- tsl_time(
      tsl = tsl
    )$class |>
      table() |>
      sort(decreasing = TRUE)

    #return tsl with no changes
    if(length(time_class_table) == 1){
      return(tsl)
    }

    #define preference rules here
    #if mixed POSIXct and Date, use POSIXct
    #if mixed numeric and integer, use numeric
    #etc

    #if Date and POSIXct, set POSIXct majority class
    # if(all(c("Date", "POSIXct") %in% time_class_table)){
    #   to <- "POSIXct"
    # }
    #
    # if(all(c("numeric", "integer") %in% time_class_table)){
    #   to <- "numeric"
    # }


    #use majority class
    to <- names(time_class_table)[1]

  }





}
