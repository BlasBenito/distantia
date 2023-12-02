#generates the dataset distance_methods

name <- c(
  "euclidean",
  "manhattan",
  "chi",
  "hellinger",
  "canberra",
  "russelrao",
  "cosine",
  "jaccard",
  "chebyshev",
  "hamming"
)

abbreviation <- c(
  "euc",
  "man",
  "chi",
  "hel",
  "can",
  "rus",
  "cos",
  "jac",
  "che",
  "ham"
)

requires_pseudozeros <- c(
  FALSE,
  FALSE,
  TRUE,
  FALSE,
  FALSE,
  FALSE,
  TRUE,
  FALSE,
  FALSE,
  FALSE
)

function_name <- c(
  "distance_euclidean_cpp",
  "distance_manhattan_cpp",
  "distance_chi_cpp",
  "distance_hellinger_cpp",
  "distance_canberra_cpp",
  "distance_russelrao_cpp",
  "distance_cosine_cpp",
  "distance_jaccard_cpp",
  "distance_chebyshev_cpp",
  "distance_hamming_cpp"
)

expression <- c(
  "sqrt(sum((x - y)^2))",
  "sum(abs(x - y))",
  "xy <- x + y; y. <- y / sum(y); x. <- x / sum(x); sqrt(sum(((x. - y.)^2) / (xy / sum(xy))))`",
  "sqrt(1/2 * sum((sqrt(x) - sqrt(y))^2))",
  "sum(abs(x - y) / (abs(x) + abs(y)))",
  "1 - sum(x == y) / length(x)",
  "1 - sum(x * y) / (sqrt(sum(x^2)) * sqrt(sum(y^2)))",
  "1 - (sum(x & y) / sum(x | y))",
  "max(abs(x - y))",
  "sum(x == y)"
)

methods <- data.frame(
  name,
  abbreviation,
  function_name,
  expression,
  requires_pseudozeros
)

usethis::use_data(methods)
