df <- data.table::fread("data_full/birds/observations_coarse.csv")

birds_names <- colnames(df)[17:ncol(df)]

df <- df |>
  dplyr::group_by(
    Year,
    y_coarse,
    x_coarse
  ) |>
  dplyr::summarise(
    dplyr::across(dplyr::all_of(birds_names), sum, na.rm = TRUE),
    .groups = "drop"
  )

df <- df |>
  dplyr::group_by(
    y_coarse,
    x_coarse
  ) |>
  dplyr::mutate(
    id = dplyr::cur_group_id()
  ) |>
  dplyr::relocate(
    id
  )

#subset places with longer time series
ids <- df |>
  dplyr::group_by(
    id
  ) |>
  dplyr::summarise(
    years = diff(range(Year))
  ) |>
  dplyr::filter(
    years >= 30
  ) |>
  dplyr::pull(id)

df <- df |>
  dplyr::filter(
    id %in% ids
  )

#subset bird names to more than 500 observations
birds_names_sum <- rev(sort(colSums(df[, birds_names])))
birds_names <- names(birds_names_sum[1:100])

df <- df |>
  dplyr::select(
    id,
    Year,
    x_coarse,
    y_coarse,
    dplyr::all_of(birds_names)
  )

df <- df |>
  dplyr::rename(
    year = Year
  ) |>
  dplyr::group_by(
    x_coarse,
    y_coarse
  ) |>
  dplyr::mutate(
    id = dplyr::cur_group_id()
  )

df$x_coarse <- NULL
df$y_coarse <- NULL

birds <- df

#TODO: subset sites, get just 5 or so

usethis::use_data(birds)

tsl <- tsl_init(
  birds,
  "id",
  "year"
)

