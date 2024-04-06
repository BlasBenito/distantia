utils_time_breaks_test <- function(
    x = NULL,
    breaks = NULL
){

  tsl <- zoo_to_tsl(
    x = x
  )

  tsl <- tsl_is_valid(
    tsl = tsl
  )

  # different classes of time ----
  time_df <- tsl_time(
    tsl = tsl,
    keywords = TRUE
  )

  time_class <- unique(time_df$class)

  if(length(time_class) > 1){
    stop(
      "The time class of all zoo objects in 'tsl' must be the same, but they are: '",
      paste(time_class, collapse = "', '"),
      "'."
    )
  }

  # time class vs breaks types ----
  time_keywords <- utils_time_keywords(
    tsl = tsl
  )

  breaks_type <- utils_time_breaks_type(
    breaks = breaks,
    keywords = time_keywords
  )

  time_units <- utils_time_units(
    all_columns = TRUE,
    class = time_class
  )

  time_units <- time_units[
    time_units$units %in% time_keywords,
  ]


}
