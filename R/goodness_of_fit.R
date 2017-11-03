#' Calculate the Chi^2 and G^2 Statistics
#'
#' goodness_of_fit() calculates the goodness of fit test statistics for contingency tables
#'
#' @param data A data frame.
#'
#' @return A numeric value
#'
#' @author Scott D Graham, \email{scott.grah95@@gmail.com}
#'
#' @examples
#' lung_cancer_ct <-
#'   array(
#'     data =
#'       c(
#'         126, 35, 100, 61
#'         ,908, 497, 688, 807
#'         ,913, 336, 747, 598
#'         ,235, 58, 172, 121
#'         ,402, 121, 308, 215
#'         ,182, 72, 156, 98
#'         ,60, 11, 99, 43
#'        ,104, 21, 89, 36
#'       )
#'     ,dim = c(2, 2, 8)
#'     ,dimnames = list(
#'       Smoking = c("Y", "N")
#'       ,Lung = c("Y", "N")
#'       ,City =
#'         c(
#'           "Beij"
#'           ,"Shan"
#'           ,"Shen"
#'           ,"Nanj"
#'           ,"Harb"
#'           ,"Zhen"
#'           ,"Taiy"
#'           ,"Nanc"
#'         )
#'     )
#'   )
#' flatten(lung_cancer_ct)
#'
#' @importFrom magrittr %>%
#' @importFrom tibble tibble
#'
#' @export

goodness_of_fit <- function(data){
  # This function is desinged to only work with contingency tables in the form of an array.
  # If the inputed data is not an array, the function is exited, and an error message is displayed.
  if(!is.data.frame(data)){
    stop("Need data frame stupid")
  } else{
    stop("Foo")
  }
}
