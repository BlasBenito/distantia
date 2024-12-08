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
  "hamming",
  "bray_curtis",
  "sorensen"
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
  "ham",
  "bra",
  "sor"
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
  "distance_hamming_cpp",
  "distance_bray_curtis_cpp",
  "distance_sorensen_cpp"
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
  "sum(x == y)",
  "1 - (2 * sum(pmin(x, y)) / (sum(x) + sum(y)))",
  "1 - (2 * sum(x & y) / (2 * sum(x & y) + sum(x & !y) + sum(!x & y)))"
)

distances <- data.frame(
  name,
  abbreviation,
  function_name,
  expression,
  requires_pseudozeros
)

usethis::use_data(distances, overwrite = TRUE)
