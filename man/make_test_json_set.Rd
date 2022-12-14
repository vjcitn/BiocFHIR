% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/make_test_json_set.R
\name{make_test_json_set}
\alias{make_test_json_set}
\title{produce 50 json FHIR files in a folder}
\usage{
make_test_json_set(target = paste0(tempdir(), "/jsontest"), reuse = TRUE)
}
\arguments{
\item{target}{character(1) a path, defaults to `jsontest` under `tempdir()`; the
contents of synthfhir.zip, in inst/zip of BiocFHIR, will be deposted there.}

\item{reuse}{logical(1) if TRUE, just use what is there, if folder already exists}
}
\value{
a vector of paths to FHIR JSON, invisibly
}
\description{
produce 50 json FHIR files in a folder
}
\examples{
z <- make_test_json_set()
z[1:3]
}
