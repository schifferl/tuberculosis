#' find/get tuberculosis gene expression data
#'
#' To find or get tuberculosis gene expression data, users will use the
#' `tuberculosis` function. The `dryrun` argument allows users to test a query
#' prior to returning resources. When `dryrun = TRUE`, the function will print
#' the names of matching resources as a message and return them invisibly as a
#' character vector. When `dryrun = FALSE`, the function will either download
#' resources from `ExperimentHub` or load them from the user’s local cache. If a
#' resource has multiple creation dates, the most recent is selected by default.
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
tuberculosis <- function(pattern, dryrun = TRUE) {
    if (base::missing(pattern)) {
        stop("the pattern argument is missing", call. = FALSE)
    }

    resources <-
        stringr::str_subset(title, pattern)

    if (base::length(resources) == 0) {
        stop("no resources available in tuberculosis", call. = FALSE)
    }

    if (dryrun) {
        stringr::str_c(resources, collapse = "\n") |>
            base::message()

        return(base::invisible(resources))
    }

    # waiting for ExperimentHub record insertion
}
