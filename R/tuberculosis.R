#' find/get tuberculosis gene expression data
#'
#' To find or get tuberculosis gene expression data, users will use the
#' `tuberculosis` function. The `dryrun` argument allows users to test a query
#' prior to returning resources. When `dryrun = TRUE`, the function will print
#' the names of matching resources as a message and return them invisibly as a
#' character vector. When `dryrun = FALSE`, the function will either download
#' resources from `ExperimentHub` or load them from the user’s local cache. If a
#' resource has multiple creation dates, the most recent is selected by default;
#' add a date to override this behavior.
#'
#' @param pattern regular expression pattern to look for in the titles of
#' resources available in tuberculosis; "." will return all resources
#'
#' @param dryrun if TRUE (the default), a character vector of resource names is
#' returned invisibly; if FALSE, a list of resources is returned
#'
#' @return if dryrun = TRUE, a character vector of resource names is returned
#' invisibly; if dryrun = FALSE, a list of resources is returned
#' @export
#'
#' @examples
#' tuberculosis("GSE103147")
#'
#' @importFrom stringr str_subset
#' @importFrom stringr str_c
#' @importFrom purrr list_along
#' @importFrom magrittr set_names
#' @importFrom ExperimentHub ExperimentHub
#' @importFrom AnnotationHub query
#' @importFrom S4Vectors mcols
#' @importFrom magrittr extract
#' @importFrom tibble as_tibble
#' @importFrom tidyr separate
#' @importFrom rlang .data
#' @importFrom dplyr group_by
#' @importFrom dplyr slice_max
#' @importFrom dplyr ungroup
#' @importFrom S4Vectors SimpleList
#' @importFrom SummarizedExperiment SummarizedExperiment
tuberculosis <- function(pattern, dryrun = TRUE) {
    if (missing(pattern)) {
        stop("the pattern argument is missing", call. = FALSE)
    }

    resources <-
        str_subset(title, pattern)

    if (length(resources) == 0) {
        stop("no resources are available", call. = FALSE)
    }

    if (dryrun) {
        str_c(resources, collapse = "\n") |>
            message()

        return(invisible(resources))
    }

    resource_list <-
        list_along(resources) |>
        set_names(resources)

    query_pattern <-
        str_c(resources, collapse = "|")

    eh_object <-
        ExperimentHub() |>
        query(query_pattern)

    to_subset <-
        mcols(eh_object)

    row_names <-
        rownames(to_subset)

    into_cols <-
        c("date_added", "study_name")

    eh_subset <-
        extract(to_subset, row_names, "title", drop = FALSE) |>
        as_tibble(rownames = "rowname") |>
        separate(.data[["title"]], into_cols, sep = "\\.") |>
        group_by(.data[["study_name"]]) |>
        slice_max(.data[["date_added"]]) |>
        ungroup()

    resource_index <-
        nrow(eh_subset) |>
        seq_len()

    resource_names <-
        names(resource_list)

    for (i in resource_index) {
        eh_identifier <-
            eh_subset[[i, "rowname"]]

        resource_list[[i]] <-
            suppressMessages(eh_object[[eh_identifier]]) |>
            SimpleList() |>
            set_names("exprs") |>
            SummarizedExperiment()
    }

    resource_list
}
