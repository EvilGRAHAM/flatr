#' Flatten i*j*k contingency tables into tidy data.
#'
#' flatten_ct() takes a i*j*k array, and turns it into a tibble
#'
#' @param data An i*j*k array.
#'
#' @return A tibble with 3 columns.
#'
#' @examples
#' flatten_ct(lung_cancer)
#'
#' @importFrom magrittr %>%
#' @importFrom tibble tibble
#'
#' @export

flatten_ct <- function(data){
  # This function is desinged to only work with contingency tables in the form of an array.
  # If the inputed data is not an array, the function is exited, and an error message is displayed.
  if(!is.array(data)){
    stop("Data is not an array!")
  } else{
    get_num_reps_i <- function(data, dim_num){
      num_reps <- c()
      for(i in 1:dim_num){
        num_reps[i] <- sum(data[i,,])
      }
      num_reps
    }

    get_num_reps_j <- function(data, dim_num){
      num_reps <- c()
      h <- 0
      for(i in 1:dim_num[1]){
        for(j in 1:dim_num[2]){
          h <- h + 1
          num_reps[h] <- sum(data[i, j,])
        }
      }
      num_reps
    }

    get_num_reps_k <- function(data, dim_num){
      num_reps <- c()
      h <- 0
      for(i in 1:dim_num[1]){
        for(j in 1:dim_num[2]){
          for(k in 1:dim_num[3]){
            h <- h + 1
            num_reps[h] <- sum(data[i, j, k])
          }
        }
      }
      num_reps
    }

    # Gets the values i,j,k for an i*j*k contingency table
    data_dim_num <- dim(data)

    # Gets the names of the dimensions, and their levels
    data_names_levels <- dimnames(data)

    # Takes just the names of the dimensions
    data_dim_names <- names(data_names_levels)

    # Gets the levels for each of dimensions i, j, and k.
    data_i_levels <- data_names_levels[[1]]
    data_j_levels <- data_names_levels[[2]]
    data_k_levels <- data_names_levels[[3]]

    # Generates a tibble with one column for each of the i, j, and k
    data_flat <-
      tibble(
        i_col =
          data_i_levels %>%
          as.factor %>%
          rep(
            times =
              data %>%
              get_num_reps_i(dim_num = data_dim_num[1])
          )
        ,j_col =
          data_j_levels %>%
          rep(
            times = data_dim_num[1]
          ) %>%
          as.factor %>%
          rep(
            times =
              data %>%
              get_num_reps_j(dim_num = data_dim_num[1:2])
          )
        ,k_col =
          data_k_levels %>%
          rep(
            times = data_dim_num[1] * data_dim_num[2]
          ) %>%
          as.factor %>%
          rep(
            times =
              data %>%
              get_num_reps_k(dim_num = data_dim_num)
          )
      )
    colnames(data_flat) <- data_dim_names
    return(data_flat)
  }
}
