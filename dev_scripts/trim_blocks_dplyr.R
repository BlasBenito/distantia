path_1 <- path |>
  dplyr::group_by(A) |>
  dplyr::mutate(
    group_size = dplyr::n(),
    keep = dplyr::case_when(
      group_size %in% c(1, 2) ~ TRUE,
      group_size > 2 & cost == max(cost) ~ TRUE,
      group_size > 2 & cost == min(cost) ~ TRUE,
      .default = FALSE
    )
  ) |>
  dplyr::filter(
    keep == TRUE
  ) |>
  dplyr::group_by(B) |>
  dplyr::mutate(
    group_size = dplyr::n(),
    keep = dplyr::case_when(
      group_size %in% c(1, 2) ~ TRUE,
      group_size > 2 & cost == max(cost) ~ TRUE,
      group_size > 2 & cost == min(cost) ~ TRUE,
      .default = FALSE
    )
  ) |>
  dplyr::filter(
    keep == TRUE
  ) |>
  dplyr::select(
    -keep,
    -group_size
  ) |>
  dplyr::arrange(A, B) |>
  as.data.frame()
