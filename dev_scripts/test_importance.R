library(distantia)

# library(Rcpp)
# sourceCpp("src/importance.cpp")

data(sequenceA)
data(sequenceB)

sequences <- prepareSequences(
  sequence.A = sequenceA,
  sequence.B = sequenceB,
  merge.mode = "overlap",
  if.empty.cases = "omit",
  transformation = "hellinger"
)

a <- sequences |>
  dplyr::filter(
    id == "A"
  ) |>
  dplyr::select(-id) |>
  as.matrix()

b <- sequences |>
  dplyr::filter(
    id == "B"
  ) |>
  dplyr::select(-id) |>
  as.matrix()

df <- importance(
  a = a,
  b = b,
  method = c("euclidean", "manhattan"),
  diagonal = c(TRUE, FALSE),
  weighted = c(TRUE, FALSE),
  ignore_blocks = c(TRUE, FALSE),
  paired_samples = FALSE,
  robust = TRUE
)

dplyr::glimpse(df)

# *** caught segfault ***
#   address 0x55f6c4000000, cause 'memory not mapped'
df <- importance_robust_cpp(
  a = a,
  b = b,
  method = "euclidean",
  diagonal = TRUE,
  weighted = FALSE,
  ignore_blocks = TRUE
)

df <- importance_robust_cpp(
  a = a,
  b = b,
  method = "manhattan",
  diagonal = TRUE,
  weighted = FALSE,
  ignore_blocks = TRUE
)

# free(): invalid size
# Aborted (core dumped)
df <- importance(
  a = a,
  b = b,
  method = c("euclidean", "manhattan"),
  diagonal = c(TRUE, FALSE),
  weighted = TRUE,
  ignore_blocks = c(TRUE, FALSE),
  paired_samples = FALSE,
  robust = TRUE
)

dplyr::glimpse(df)


#step by step


psi <- psi_cpp(
  a = a,
  b = b,
  method = "manhattan",
  diagonal = TRUE,
  weighted = FALSE,
  ignore_blocks = TRUE
)

path <- psi_cost_path_cpp(
  a = a,
  b = b,
  method = "manhattan",
  diagonal = TRUE,
  weighted = FALSE,
  ignore_blocks = TRUE
)

ab_sum = psi_auto_sum_cpp(
  a = a,
  b = b,
  path = path,
  method = "manhattan",
  ignore_blocks = TRUE
)

psi_all_variables = psi_formula_cpp(
  path = path,
  auto_sum = ab_sum,
  diagonal = TRUE
)

#THIS ONE DOES NOT BREAK THE SESSION
importance.i <- importance_cpp(
  a = a,
  b = b,
  method = "manhattan",
  diagonal = TRUE,
  weighted = FALSE,
  ignore_blocks = TRUE
)

#SOLVED
importance.i <- importance_robust_cpp(
  a = a,
  b = b,
  method = "manhattan",
  diagonal = TRUE,
  weighted = FALSE,
  ignore_blocks = TRUE
)

#CHECKING WHAT BREAKS INSIDE


i <- 1

a_only_with = select_column_cpp(a, i)
b_only_with = select_column_cpp(b, i)

path_only_with = update_path_dist_cpp(
  a_only_with,
  b_only_with,
  path = path,
  method = "manhattan"
)

ab_sum_only_with = psi_auto_sum_cpp(
  a_only_with,
  b_only_with,
  path = path,
  method = "manhattan",
  ignore_blocks = TRUE
)

psi_only_with = psi_formula_cpp(
  path_only_with,
  ab_sum_only_with,
  diagonal = TRUE
)

a_without = delete_column_cpp(a, i)
b_without = delete_column_cpp(b, i)

#THIS BREAKS THE SESSION
# malloc(): invalid size (unsorted)
# Aborted (core dumped)
path_without = update_path_dist_cpp(
  a_without,
  b_without,
  path = path,
  method = "manhattan"
)

ab_sum_without = psi_auto_sum_cpp(
  a_without,
  b_without,
  path = path,
  method = "manhattan",
  ignore_blocks = TRUE
)

psi_without = psi_formula_cpp(
  path_without,
  ab_sum_without,
  diagonal = TRUE
)

psi_difference = psi_only_with - psi_without

(psi_difference * 100) / psi_all_variables

((psi_all_variables - psi_without) * 100) / psi_all_variables
