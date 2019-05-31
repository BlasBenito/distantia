#' Handles emtpy and NA data in a multivariate time series.
#'
#' @description This function is used internally by \code{\link{prepareSequences}}. Handles empty and NA data in a multivariate time-series in two possible ways: 1) deleting rows with NA or empty cases; 2) replacing NA data with zeros.
#'
#' @usage handleNA(
#'   sequence = NULL,
#'   if.empty.cases = "zero"
#'   )
#'
#' @param sequence Dataframe, a multivariate time-series.
#' @param if.empty.cases character, one of: "omit" (default), "zero". When "omit", the function removes every row with at least one empty/NA record. When "zero", empty/NA data is replaced with zeros.
#'
#' @return A dataframe with the same columns as \code{sequence}.
#'
#' @author Blas Benito <blasbenito@gmail.com>
#'
#' @examples
#' data(sequenceB)
#' B.sequence <- handleNA(
#'   sequence = sequenceB,
#'   if.empty.cases = "zero"
#'   )
#'
#' @export
handleNA <- function(sequence = NULL,
                     if.empty.cases = "zero"){


  #checking if.empty.cases
  if (!(if.empty.cases) %in% c("zero", "ZERO", "Zero", "omit", "Omit", "OMIT")){
    stop("if.empty.cases' must be one of: 'zero', 'omit'.")
  } else {
    if(if.empty.cases %in% c("zero", "ZERO", "Zero")){if.empty.cases <- "zero"}
    if(if.empty.cases %in% c("omit", "Omit", "OMIT")){if.empty.cases <- "omit"}
  }

  #identifying empty cases
  empty.cases <- is.na(sequence == "")

  #replacing by NA if there are empty cases
  if (sum(empty.cases, na.rm = TRUE) > 0){
    sequence[empty.cases] <- NA
  }

  #sum empty and NA cases
  sum.na.cases=sum(is.na(sequence))

  #STOP IF NO NA CASES
  if (sum.na.cases==0){
    return(sequence)
  }

  #HANDLING EMPTY CASES
  if(sum.na.cases > 0){

    #IF if.empty.cases="omit"
    if (if.empty.cases == "omit"){

      #remove rows with NA
      sequence=sequence[stats::complete.cases(sequence), ]

      return(sequence)

    }#end of IF if.empty.cases="omit"


    #IF if.empty.cases="zero"
    if (if.empty.cases == "zero"){

      #replace NA by 0
      sequence[is.na(sequence)] <- 0

      return(sequence)

    }#end of IF if.empty.cases="omit"


  }#end of HANDLING EMPTY CASES

}
