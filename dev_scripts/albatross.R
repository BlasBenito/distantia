download.file(
  url = "https://datarepository.movebank.org/bitstreams/72f33630-876d-44a1-92c8-7ff15e252162/download",
  destfile = "dev_scripts/albatross.csv"
  )

df <- data.table::fread("dev_scripts/albatross.csv") |>
  janitor::clean_names()

albatross <- df |>
  dplyr::transmute(
    id = tag_local_identifier,
    time = timestamp,
    latitude = location_lat,
    longitude = location_long,
    speed = ground_speed,
    temperature = eobs_temperature,
    heading
  ) |>
  na.omit() |>
  #select individuals with ~1000 observations
  dplyr::filter(
    id %in% c(156, 136, 153, 132, 134)
  ) |>
  #filter anomalous speeds
  dplyr::filter(
    speed < quantile(x = speed, probs = 0.95)
  )

usethis::use_data(albatross, overwrite = TRUE)

#load as tsl
#scale al variables
#aggregate to daily resolution
tsl <- tsl_initialize(
  x = albatross,
  name_column = "name",
  time_column = "time"
) |>
  tsl_transform(
    f = f_scale_local
  ) |>
  tsl_aggregate(
    new_time = "days"
  )

if(interactive()){
  tsl_plot(
    tsl = tsl,
    guide_columns = 5
    )
}


distantia(tsl = tsl, lock_step = FALSE)

tsl_time(tsl)
