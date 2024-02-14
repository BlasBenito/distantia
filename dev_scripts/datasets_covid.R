covid <- covid19cases_test |>
  dplyr::select(
    date,
    area,
    area_type,
    population,
    cases
  ) |>
  dplyr::filter(
    area_type == "County",
    area != "Unknown",
    population > 100000,
  ) |>
  dplyr::select(
    -area_type
  ) |>
  dplyr::rename(
    county = area
  ) |>
  dplyr::mutate(
    prevalence = round((cases/population)*100, 2)
  ) |>
  na.omit() |>
  dplyr::select(
    date, county, prevalence
  )

y <- prepare_sequences(
  x = covid,
  id_column = "county",
  time_column = "date"
)
