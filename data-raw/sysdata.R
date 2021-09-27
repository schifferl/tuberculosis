col_types <-
    readr::cols(
        Title = readr::col_character(),
        .default = readr::col_skip()
    )

into_one <-
    base::c("date_created", "study_name")

into_two <-
    base::c("series_accession", "platform_accession")

title <-
    readr::read_csv("inst/extdata/metadata.csv", col_types = col_types) |>
    tidyr::separate(Title, into_one, sep = "\\.GSE", remove = FALSE) |>
    tidyr::separate(study_name, into_two, sep = "\\-GPL", fill = "right") |>
    dplyr::mutate(series_accession = base::as.integer(series_accession)) |>
    dplyr::mutate(platform_accession = base::as.integer(platform_accession)) |>
    dplyr::arrange(series_accession, platform_accession, date_created) |>
    dplyr::pull(.data[["Title"]])

usethis::use_data(title, internal = TRUE, overwrite = TRUE)
