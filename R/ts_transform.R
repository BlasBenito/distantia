ts_transform <- function(
    x = NULL,
    f = NULL,
    verbose = TRUE,
    ...
){

  x <- check_args_x(
    x = x,
    arg_name = "x"
  )

  if(is.null(f)){

    if(verbose == TRUE){
      message(
        "Argument 'f' is NULL, no transformation applied. Valid values for 'f' are: f_proportion, f_percentage, f_hellinger, and f_scale."
      )
    }

    return(x)

  }

  x <- lapply(
    X = x,
    FUN = f,
    ... = ...
  )

}
