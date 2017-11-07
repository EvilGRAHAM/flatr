#' Print method for goodness_of_fit()
#'
#' Creates a nice looking output for the goodness_of_fit() function
#'
#' @param x A list
#'
#' @author Scott D Graham, \email{scott.grah95@@gmail.com}
#'
#' @export
print.ct_goodness_of_fit <- function(x, ...){
  cat(x$test, "Goodness of Fit Test", "\n\n")
  cat("model:", x$model, "\n")
  cat(x$test, "=", round(x$statistic, 5))
  cat(",", "df =", x$df)
  cat(",", "p-value =", if_else(x$p.value <= 2.2 * 10^(-16), "< 2.2e-16", as.character(round(x$p.value, 5))))
}
