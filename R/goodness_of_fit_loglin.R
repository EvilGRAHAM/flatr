#' Calculate the Chi^2 and G^2 Statistics
#'
#' Calculates the goodness of fit test statistics for log linear models
#'
#' @param model a GLM regression model.
#'
#' @param type either "Chisq" or "Gsq", which determines the type of goodness of fit test that is ran. Defaults to "Chisq".
#'
#' @param ... Further arguments passed to or from other methods.
#'
#' @return A list with class "\code{ct_goodness_of_fit}" containing the following components:
#'
#' @return \code{test} the type of test used.
#'
#' @return \code{model} the name of the inputted model.
#'
#' @return \code{statistic} The value of the test statistic as determined by the type parameter
#'
#' @return \code{df} The number of degrees of freedom.
#'   This equals the number of combinations for explanatory variables less the number of parameters in the model
#'
#' @return \code{p.value} The p-value calculated under a Chi-Squared distribution.
#'
#' @examples
#' lung_loglin <-
#'   lung_cancer %>%
#'   flatten_ct() %>%
#'   group_by_all() %>%
#'   count() %>%
#'   ungroup() %>%
#'   glm(
#'     n ~ Lung + Smoking + City
#'     ,family = poisson
#'     ,data = .
#'   )
#'
#' goodness_of_fit_loglin(model = lung_loglin, type = "Chisq")
#'
#' lung_loglin %>%
#'   goodness_of_fit_loglin(type = "Gsq")
#'
#' @importFrom stats coef pchisq predict formula
#' @importFrom magrittr %>%
#' @importFrom tibble tibble
#' @import dplyr
#'
#' @export

goodness_of_fit_loglin <- function(model, type = "Chisq", ...){

  # Definitions for variables used below to satisfy devtools::check()
  Response <- as.character(NULL)
  Response_Num <- as.numeric(NULL)
  Response <- as.numeric(NULL)
  phat <- as.numeric(NULL)
  Total <- as.numeric(NULL)
  Expected <- as.numeric(NULL)
  ChiSq <- as.numeric(NULL)
  GSq <- as.numeric(NULL)

  data <- model$data
  # If the inputed data is not an array, the function is exited, and an error message is displayed.
  if(!is.data.frame(data)){
    stop("Please enter a data frame")
  } else{

    data <-
      data %>%
      rename(Response = !!as.character(model$terms[[2]]))

    # Number of combinations of the response variable - number of parameters in the model
    df <-
      (data %>%
         select(-Response) %>%
         unique() %>%
         tally() %>%
         as.numeric()) - length(coef(model))

    data_out <-
      data %>%
      cbind(
        Expected =
          predict(
            object = model
            ,newdata = data
            ,type = "response"
          )
      ) %>%
      as_tibble()

    if(type == "Chisq"){
      test_stat <-
        data_out %>%
        mutate(
          ChiSq = (Response - Expected)^2 / Expected
        ) %>%
        select(ChiSq) %>%
        sum()

      test_name <- "Chi-squared"

    } else if(type == "Gsq"){
      test_stat <-
        data_out %>%
        mutate(
          GSq = 2 * Response * log(Response / Expected)
        ) %>%
        select(GSq) %>%
        sum()

      test_name <- "G-squared"

    } else{
      stop("Please enter a valid test.")
    }

    p.value <- pchisq(q = test_stat, df = df, lower.tail = FALSE)

    results <-
      list(
        test = test_name
        ,model = deparse(substitute(model))
        ,statistic = test_stat
        ,df = df
        ,p.value = p.value
      )

    class(results) <- "ct_goodness_of_fit"

    return(results)
  }
}
