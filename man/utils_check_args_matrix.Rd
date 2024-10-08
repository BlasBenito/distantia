% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils_check_args.R
\name{utils_check_args_matrix}
\alias{utils_check_args_matrix}
\title{Checks Input Matrix}
\usage{
utils_check_args_matrix(m = NULL, arg_name = "m")
}
\arguments{
\item{m}{(required, matrix) distance or cost matrix resulting from \code{\link[=psi_distance_matrix]{psi_distance_matrix()}} or \code{\link[=psi_cost_matrix]{psi_cost_matrix()}}. Default: NULL}

\item{arg_name}{(optional, character string) name of the argument being checked. Default: NULL}
}
\value{
matrix
}
\description{
Checks Input Matrix
}
\seealso{
Other internal: 
\code{\link{utils_check_args_distantia}()},
\code{\link{utils_check_args_path}()},
\code{\link{utils_check_args_zoo}()},
\code{\link{utils_check_distance_args}()},
\code{\link{utils_check_list_class}()},
\code{\link{utils_digits}()},
\code{\link{utils_distantia_df_split}()},
\code{\link{utils_distantia_df_to_matrix}()},
\code{\link{utils_prepare_df}()},
\code{\link{utils_prepare_matrix}()},
\code{\link{utils_prepare_matrix_list}()},
\code{\link{utils_prepare_time}()},
\code{\link{utils_prepare_vector_list}()},
\code{\link{utils_prepare_zoo_list}()},
\code{\link{utils_tsl_pairs}()}
}
\concept{internal}
