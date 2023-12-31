library(dplyr)
library(distantia)

load("~/Dropbox/GITHUB/R_packages/distantia/data/sequencesMIS.RData")

#matrix
#####################################
x <- sequencesMIS |>
  as.matrix()

id_column <- NULL
time_column <- NULL
transformation = NULL
paired_samples = FALSE
pseudo_zero = NULL
na_action = NULL

x <- prepare_sequences(
  x = x,
  id_column = id_column,
  time_column = time_column,
  transformation = transformation,
  paired_samples = paired_samples,
  pseudo_zero = pseudo_zero,
  na_action = na_action
)

str(x)
x[[1]]

#data frame without grouping column
####################################
x <- sequencesMIS |>
  dplyr::select(-MIS)

id_column <- NULL
time_column <- NULL
transformation = NULL
paired_samples = FALSE
pseudo_zero = NULL
na_action = NULL

x <- prepare_sequences(
  x = x,
  id_column = id_column,
  time_column = time_column,
  transformation = transformation,
  paired_samples = paired_samples,
  pseudo_zero = pseudo_zero,
  na_action = na_action
)

str(x)
x[[1]]

#data frame with grouping column
###################################
x <- sequencesMIS

id_column <- "MIS"
time_column <- NULL
transformation = f_hellinger
paired_samples = FALSE
pseudo_zero = NULL
na_action = NULL

x <- prepare_sequences(
  x = x,
  id_column = id_column,
  time_column = time_column,
  transformation = transformation,
  paired_samples = paired_samples,
  pseudo_zero = pseudo_zero,
  na_action = na_action
)

str(x)
x[[1]]

#data frame with time column
###################################
x <- sequencesMIS |>
  dplyr::group_by(MIS) |>
  dplyr::mutate(
    time = 1:dplyr::n()
  ) |>
  as.data.frame()

id_column <- "MIS"
time_column <- "time"
transformation = f_hellinger
paired_samples = FALSE
pseudo_zero = 0.001
na_action = "omit"

x <- prepare_sequences(
  x = x,
  id_column = id_column,
  time_column = time_column,
  transformation = transformation,
  paired_samples = paired_samples,
  pseudo_zero = pseudo_zero,
  na_action = na_action
)

str(x)
x[[1]]

#data frame with time column without group column
###################################
x <- sequencesMIS |>
  dplyr::group_by(MIS) |>
  dplyr::mutate(
    time = 1:dplyr::n()
  ) |>
  dplyr::ungroup() |>
  dplyr::select(-MIS) |>
  as.data.frame()

id_column <- NULL
time_column <- "time"
transformation = f_hellinger
paired_samples = FALSE
pseudo_zero = NULL
na_action = NULL

x <- prepare_sequences(
  x = x,
  id_column = id_column,
  time_column = time_column,
  transformation = transformation,
  paired_samples = paired_samples,
  pseudo_zero = pseudo_zero,
  na_action = na_action
)

str(x)
x[[1]]

#list of vectors
###################################
x <- split(
  x = sequencesMIS,
  f = sequencesMIS$MIS
) |>
  lapply(
    FUN = function(x){
      return(x[[2]])
    }
  )

id_column <- NULL
time_column <- NULL
transformation = f_hellinger
paired_samples = FALSE
pseudo_zero = NULL
na_action = NULL

x <- prepare_sequences(
  x = x,
  id_column = id_column,
  time_column = time_column,
  transformation = transformation,
  paired_samples = paired_samples,
  pseudo_zero = pseudo_zero,
  na_action = na_action
)

str(x)
x[[1]]

#list of matrices with named and same columns
#############################################
x <- split(
  x = sequencesMIS,
  f = sequencesMIS$MIS
) |>
  lapply(
    FUN = function(x){
      x$MIS <- NULL
      as.matrix(x)
    }
  )

id_column <- NULL
time_column <- NULL
transformation = f_hellinger
paired_samples = FALSE
pseudo_zero = NULL
na_action = NULL

x <- prepare_sequences(
  x = x,
  id_column = id_column,
  time_column = time_column,
  transformation = transformation,
  paired_samples = paired_samples,
  pseudo_zero = pseudo_zero,
  na_action = na_action
)

str(x)
x[[1]]

#list of matrices with named but different columns
#############################################
x <- split(
  x = sequencesMIS,
  f = sequencesMIS$MIS
) |>
  lapply(
    FUN = function(x){
      x$MIS <- NULL
      x[, sample(
        x = 1:ncol(x),
        size = sample(
          x = 1:ncol(x),
          size = 1
          )
        )]
    }
  )

id_column <- NULL
time_column <- NULL
transformation = f_hellinger
paired_samples = FALSE
pseudo_zero = NULL
na_action = NULL

x <- prepare_sequences(
  x = x,
  id_column = id_column,
  time_column = time_column,
  transformation = transformation,
  paired_samples = paired_samples,
  pseudo_zero = pseudo_zero,
  na_action = na_action
)

str(x)
x[[1]]


#unnamed list of data frames without time_column
#########################################
x <- split(
  x = sequencesMIS,
  f = sequencesMIS$MIS
) |>
  lapply(
    FUN = function(x){
      x$MIS <- NULL
      return(x)
    }
  )

names(x) <- NULL
id_column <- NULL
time_column <- NULL
transformation = f_hellinger
paired_samples = FALSE
pseudo_zero = NULL
na_action = NULL

x <- prepare_sequences(
  x = x,
  id_column = id_column,
  time_column = time_column,
  transformation = transformation,
  paired_samples = paired_samples,
  pseudo_zero = pseudo_zero,
  na_action = na_action
)

str(x)
x[[1]]

#named list of data frames without time_column
########################################
x <- split(
  x = sequencesMIS,
  f = sequencesMIS$MIS
) |>
  lapply(
    FUN = function(x){
      x$MIS <- NULL
      return(x)
    }
  )

id_column <- NULL
time_column <- NULL
transformation = f_hellinger
paired_samples = FALSE
pseudo_zero = NULL
na_action = NULL

x <- prepare_sequences(
  x = x,
  id_column = id_column,
  time_column = time_column,
  transformation = transformation,
  paired_samples = paired_samples,
  pseudo_zero = pseudo_zero,
  na_action = na_action
)

str(x)
x[[1]]


#named list of data frames with time_column
########################################
x <- sequencesMIS |>
  dplyr::group_by(MIS) |>
  dplyr::mutate(
    time = 1:dplyr::n()
  ) |>
  as.data.frame()

x <-  split(
  x = x,
    f = x$MIS
  ) |>
  lapply(
    FUN = function(x){
      x$MIS <- NULL
      return(x)
    }
  )

attributes(x[[1]])

id_column <- NULL
time_column <- "time"
transformation = f_hellinger
paired_samples = FALSE
pseudo_zero = NULL
na_action = NULL

x <- prepare_sequences(
  x = x,
  id_column = id_column,
  time_column = time_column,
  transformation = transformation,
  paired_samples = paired_samples,
  pseudo_zero = pseudo_zero,
  na_action = na_action
)

str(x)
x[[1]]



