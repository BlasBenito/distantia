covid_counties <- load("data_full/covid_polygons.rda")

covid_counties <- covid_polygons
rownames(covid_counties) <- NULL

california$name <- utils_clean_names(x = california$name)

california <- california |>
  dplyr::filter(
    name %in% covid_counties$name
  )

california <- california |>
  dplyr::mutate(
    employed = employed / population,
    domestic_product = domestic_product / population,
    daily_miles_traveled = daily_miles_traveled / population
  )

covid_counties <- dplyr::inner_join(
  covid_counties,
  california
)

covid_counties <- covid_counties |>
  dplyr::mutate(
    employed_percentage = employed * 100
  ) |>
  dplyr::select(-employed)

covid_counties <- covid_counties |>
  dplyr::rename(
    median_income = median_household_income
  )

covid_counties <- covid_counties |>
  dplyr::mutate(
    area_hectares = as.numeric(sf::st_area(geometry))/10000
  )

covid_counties <- covid_counties |>
  dplyr::relocate(
    area_hectares,
    .after = name
  )

usethis::use_data(covid_counties, overwrite = TRUE)


#centrality

adj_matrix <- st_relate(covid_counties, covid_counties, pattern = "****1****", sparse = FALSE)  # Adjacency matrix (shared borders)
adj_matrix <- sapply(adj_matrix, as.numeric)  # Convert to binary matrix
diag(adj_matrix) <- 0  # Remove self-loops

# Step 2: Create an igraph object
graph <- graph_from_adjacency_matrix(adj_matrix, mode = "undirected", diag = FALSE)

# Step 3: Compute centrality measures
# Degree centrality
degree_centrality <- degree(graph)

# Closeness centrality
closeness_centrality <- closeness(graph)

# Betweenness centrality
betweenness_centrality <- betweenness(graph)
