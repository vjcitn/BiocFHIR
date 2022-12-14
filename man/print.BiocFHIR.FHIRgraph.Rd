% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/graphit.R
\name{print.BiocFHIR.FHIRgraph}
\alias{print.BiocFHIR.FHIRgraph}
\title{show a combination of graph and patient attributes}
\usage{
\method{print}{BiocFHIR.FHIRgraph}(x, ...)
}
\arguments{
\item{x}{instance of BiocFHIR.FHIRgraph}

\item{\dots}{not used}
}
\value{
print method
}
\description{
show a combination of graph and patient attributes
}
\examples{
data("allin")
make_condition_graph(allin)
}
