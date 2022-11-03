
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tuberculosis <img src='man/figures/logo.png' align="right" height="138" />

<!-- badges: start -->

[![code
quality](https://img.shields.io/codefactor/grade/github/schifferl/tuberculosis)](https://www.codefactor.io/repository/github/schifferl/tuberculosis)
<!-- badges: end -->

The
*[tuberculosis](https://bioconductor.org/packages/3.16/tuberculosis)*
R/Bioconductor package features tuberculosis gene expression data for
machine learning. All human samples from
[GEO](https://www.ncbi.nlm.nih.gov/geo/) that did not come from cell
lines, were not taken postmortem, and did not feature recombination have
been included. The package has more than 10,000 samples from both
microarray and sequencing studies that have been processed from raw data
through a hyper-standardized, reproducible pipeline.

## The Pipeline

To fully understand the provenance of data in the
*[tuberculosis](https://bioconductor.org/packages/3.16/tuberculosis)*
R/Bioconductor package, please see the
[tuberculosis.pipeline](https://github.com/schifferl/tuberculosis.pipeline)
GitHub repository; however, all users beyond the extremely curious can
ignore these details without consequence. Yet, a brief summary of data
processing is appropriate here. Microarray data were processed from raw
files (e.g. `CEL` files) and background corrected using the
normal-exponential method and the saddle-point approximation to maximum
likelihood as implemented in the
*[limma](https://bioconductor.org/packages/3.16/limma)* R/Bioconductor
package; no normalization of expression values was done; where platforms
necessitated it, the RMA (robust multichip average) algorithm without
background correction or normalization was used to generate an
expression matrix. Sequencing data were processed from raw files
(i.e. `fastq` files) using the
[nf-core/rnaseq](https://nf-co.re/rnaseq/1.4.2) pipeline inside a
Singularity container; the GRCh38 genome build was used for alignment.
Gene names for both microarray and sequencing data are HGNC-approved
GRCh38 gene names from the [genenames.org](https://www.genenames.org/)
REST API.

## Installation

To install
*[tuberculosis](https://bioconductor.org/packages/3.16/tuberculosis)*
from Bioconductor, use
*[BiocManager](https://CRAN.R-project.org/package=BiocManager)* as
follows.

``` r
BiocManager::install("tuberculosis")
```

To install
*[tuberculosis](https://bioconductor.org/packages/3.16/tuberculosis)*
from GitHub, use
*[BiocManager](https://CRAN.R-project.org/package=BiocManager)* as
follows.

``` r
BiocManager::install("schifferl/tuberculosis", dependencies = TRUE, build_vignettes = TRUE)
```

Most users should simply install
*[tuberculosis](https://bioconductor.org/packages/3.16/tuberculosis)*
from Bioconductor.

## Load Package

To use the package without double colon syntax, it should be loaded as
follows.

``` r
library(tuberculosis)
```

The package is lightweight, with few dependencies, and contains no data
itself.

## Finding Data

To find data, users will use the `tuberculosis` function with a regular
expression pattern to list available resources. The resources are
organized by [GEO](https://www.ncbi.nlm.nih.gov/geo/) series accession
numbers. If multiple platforms were used in a single study, the platform
accession number follows the series accession number and is separated by
a dash. The date before the series accession number denotes the date the
resource was created.

``` r
tuberculosis("GSE103147")
```

    ## 2021-09-15.GSE103147

The function will print the names of matching resources as a message and
return them invisibly as a character vector. To see all available
resources use `"."` for the `pattern` argument.

## Getting Data

To get data, users will also use the `tuberculosis` function, but with
an additional argument, `dryrun = FALSE`. This will either download
resources from
*[ExperimentHub](https://bioconductor.org/packages/3.16/ExperimentHub)*
or load them from the user’s local cache. If a resource has multiple
creation dates, the most recent is selected by default; add a date to
override this behavior.

``` r
tuberculosis("GSE103147", dryrun = FALSE)
```

    ## snapshotDate(): 2021-11-24

    ## $`2021-09-15.GSE103147`
    ## class: SummarizedExperiment 
    ## dim: 24353 1649 
    ## metadata(0):
    ## assays(1): exprs
    ## rownames: NULL
    ## rowData names(0):
    ## colnames: NULL
    ## colData names(0):

The function returns a `list` of `SummarizedExperiment` objects, each
with a single assay, `exprs`, where the rows are features (genes) and
the columns are observations (samples). If multiple resources are
requested, multiple resources will be returned, each as a `list`
element.

``` r
tuberculosis("GSE10799.", dryrun = FALSE)
```

    ## snapshotDate(): 2021-11-24

    ## $`2021-09-15.GSE107991`
    ## class: SummarizedExperiment 
    ## dim: 24353 54 
    ## metadata(0):
    ## assays(1): exprs
    ## rownames: NULL
    ## rowData names(0):
    ## colnames: NULL
    ## colData names(0):
    ## 
    ## $`2021-09-15.GSE107992`
    ## class: SummarizedExperiment 
    ## dim: 24353 47 
    ## metadata(0):
    ## assays(1): exprs
    ## rownames: NULL
    ## rowData names(0):
    ## colnames: NULL
    ## colData names(0):
    ## 
    ## $`2021-09-15.GSE107993`
    ## class: SummarizedExperiment 
    ## dim: 24353 138 
    ## metadata(0):
    ## assays(1): exprs
    ## rownames: NULL
    ## rowData names(0):
    ## colnames: NULL
    ## colData names(0):
    ## 
    ## $`2021-09-15.GSE107994`
    ## class: SummarizedExperiment 
    ## dim: 24353 175 
    ## metadata(0):
    ## assays(1): exprs
    ## rownames: NULL
    ## rowData names(0):
    ## colnames: NULL
    ## colData names(0):
    ## 
    ## $`2021-09-15.GSE107995`
    ## class: SummarizedExperiment 
    ## dim: 24353 414 
    ## metadata(0):
    ## assays(1): exprs
    ## rownames: NULL
    ## rowData names(0):
    ## colnames: NULL
    ## colData names(0):

The `assay` of each `SummarizedExperiment` object is named `exprs`
rather than `counts` because it can come from either a microarray or a
sequencing platform. If `colnames` begin with `GSE`, data comes from a
microarray platform; if `colnames` begin with `SRR`, data comes from a
sequencing platform.

## No Metadata?

The `SummarizedExperiment` objects do not have sample metadata as
`colData`, and this limits their use to unsupervised analyses for the
time being. Sample metadata are currently undergoing manual curation,
with the same level of diligence that was applied in data processing,
and will be included in the package when they are ready.

## Contributing

To contribute to the
*[tuberculosis](https://bioconductor.org/packages/3.16/tuberculosis)*
R/Bioconductor package, first read the [contributing
guidelines](CONTRIBUTING.md) and then open an issue. Also note that in
contributing you agree to abide by the [code of
conduct](CODE_OF_CONDUCT.md).
