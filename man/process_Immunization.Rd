% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/processOthers.R
\name{process_Immunization}
\alias{process_Immunization}
\title{extract information from retained fields in Immunization component of FHIR Bundle, produce simple data.frame}
\usage{
process_Immunization(Immunization)
}
\arguments{
\item{Immunization}{component of FHIR.bundle instance}
}
\value{
data.frame
}
\description{
extract information from retained fields in Immunization component of FHIR Bundle, produce simple data.frame
}
\examples{
testf <- system.file("json/Vince741_Rogahn59_6fa3d4ab-c0b6-424a-89d8-7d9105129296.json",
   package="BiocFHIR")
tbun <- process_fhir_bundle(testf)
process_Immunization(tbun$Immunization)
}
