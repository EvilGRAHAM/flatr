#' Calculate the Chi^2 and G^2 Statistics
#'
#' Calculates the goodness of fit test statistics for contingency tables
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
#' lung_logit <-
#'   lung_cancer %>%
#'   flatten_ct() %>%
#'   glm(
#'     Lung ~ City + Smoking
#'     ,family = binomial
#'     ,data = .
#'   )
#'
#' goodness_of_fit(model = lung_logit, type = "Chisq")
#' lung_logit %>%
#'   goodness_of_fit(type = "Gsq")
#' lung_cancer %>%
#'   flatten_ct() %>%
#'   glm(
#'     Lung ~ City + Smoking
#'     ,family = binomial
#'     ,data = .
#'   ) %>%
#'   goodness_of_fit()
#'
#' @importFrom stats coef pchisq predict formula
#' @importFrom magrittr %>%
#' @importFrom tibble tibble
#' @import dplyr
#'
#' @export

goodness_of_fit <- function(model, type = "Chisq", ...){

  # Definitions for variables used below to satisfy devtools::check()
  Response <- as.character(NULL)
  Response_Num <- as.numeric(NULL)
  Response_0 <- as.numeric(NULL)
  Response_1 <- as.numeric(NULL)
  phat <- as.numeric(NULL)
  Total <- as.numeric(NULL)
  Expected_0 <- as.numeric(NULL)
  Expected_1 <- as.numeric(NULL)
  ChiSq_0 <- as.numeric(NULL)
  ChiSq_1 <- as.numeric(NULL)
  GSq_0 <- as.numeric(NULL)
  GSq_1 <- as.numeric(NULL)

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

    data_summary <-
      data %>%
      mutate(
        Response_Num = Response %>% unclass()
        ,Response_Num = Response_Num - 1
      ) %>%
      ungroup() %>%
      # Groups by not the response column
      group_by_at(
        vars(
          all.vars(formula(model))[all.vars(formula(model)) != model$terms[[2]]]
        )
      ) %>%
      # Summarizes by the 2 explanatory variables, and then finds the number of entries for each level of the Response
      summarize(
        Response_0 = sum(Response_Num)
        ,Response_1 = length(Response_Num) - Response_0
        ,Total = Response_1 + Response_0
      ) %>%
      ungroup()

    data_out <-
      data_summary %>%
      cbind(
        phat =
          predict(
            object = model
            ,newdata = data_summary
            ,type = "response"
          )
      ) %>%
      as_tibble() %>%
      mutate(
        Expected_0 = phat * Total
        ,Expected_1 = (1 - phat) * Total
      )

    if(type == "Chisq"){
      test_stat <-
        data_out %>%
        mutate(
          ChiSq_0 = (Response_0 - Expected_0)^2 / Expected_0
          ,ChiSq_1 = (Response_1 - Expected_1)^2 / Expected_1
        ) %>%
        select(
          ChiSq_0
          ,ChiSq_1
        ) %>%
        sum()

      test_name <- "Chi-squared"

    } else if(type == "Gsq"){
      test_stat <-
        data_out %>%
        mutate(
          GSq_0 = 2 * Response_0 * log(Response_0 / Expected_0)
          ,GSq_1 = 2 * Response_1 * log(Response_1 / Expected_1)
        ) %>%
        select(
          GSq_0
          ,GSq_1
        ) %>%
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
