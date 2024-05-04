utils_coerce_time_class <- function(
    x = NULL,
    to = "POSIXct"
){

  classes <- c("POSIXct", "Date")

  if(is.character(x)){
    x <- x |>
      utils_as_time() |>
      suppressWarnings()
  }

  if(!(class(x) %in% classes)){
    return(x)
  }

  if(to == "POSIXct"){

    if("Date" %in% class(x)){

      x <- as.POSIXct(x)

    }

  }

  if(to == "Date"){

    if("POSIXct" %in% class(x)){

      x <- format(
        x = x,
        format = "%Y-%m-%d"
      )

      x <- as.Date(x)

    }

  }

  if(to == "numeric"){

    x <- as.numeric(x)

  }

  x

}
