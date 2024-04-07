#' Translates The User's Time Keywords Into Valid Ones
#'
#' @description
#' Internal function to translate misnamed or abbreviated keywords into valid ones. Uses [utils_time_keywords_dictionary()] as reference dictionary.
#'
#'
#' @param keyword (optional, character string) A time keyword such as "day".
#'
#' @return Time keyword.
#' @export
#' @autoglobal
#' @examples
utils_time_keywords_translate <- function(
    keyword = NULL
){

  if(is.null(keyword)){
    return(NULL)
  }

  if(!is.character(keyword) || length(keyword) > 1){
    return(keyword)
  }

  old_keyword <- keyword

  df <- utils_time_keywords_dictionary()

  if(keyword %in% df$keyword){
    return(keyword)
  }

  if(keyword %in% df$pattern){
    return(df[df$pattern == keyword, "keyword"])
  }

  keyword

}
