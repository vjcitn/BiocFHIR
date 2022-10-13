#' flatten information in Patient component of a bundle to a one-line data.frame
#' @param Patient element of FHIR.bundle instance
#' @return data.frame
#' @examples
#' testf <- system.file("json/Vince741_Rogahn59_6fa3d4ab-c0b6-424a-89d8-7d9105129296.json",
#'    package="BiocFHIR")
#' tbun <- process_fhir_bundle(testf)
#' tpat <- process_Patient(tbun$Patient)
#' head(names(tpat))
#' tags <- c("identifier.system3", "identifier.value3")
#' tpat[tags,,FALSE]
#' tags2 <- grep("extension.extension", rownames(tpat), value=TRUE)
#' tpat[tags2,,FALSE]
#' @export
process_Patient <- function(Patient) {
 # Motivation: Patient bundle component has 'identifier' which
 # comes as a list of length 1, which has embedded data.frame
# Example
# > str(origpat$identifier)
# List of 1
#  $ :'data.frame':	3 obs. of  3 variables:
#   ..$ system: chr [1:3] "https://github.com/synthetichealth/synthea" "http://hospital.smarthealthit.org" "http://hl7.org/fhir/sid/us-ssn"
#   ..$ value : chr [1:3] "6fa3d4ab-c0b6-424a-89d8-7d9105129296" "6fa3d4ab-c0b6-424a-89d8-7d9105129296" "999-91-5546"
#   ..$ type  :'data.frame':	3 obs. of  2 variables:
#   .. ..$ coding:List of 3
#   .. .. ..$ : NULL
#   .. .. ..$ :'data.frame':	1 obs. of  3 variables:
#   .. .. .. ..$ system : chr "http://terminology.hl7.org/CodeSystem/v2-0203"
#   .. .. .. ..$ code   : chr "MR"
#   .. .. .. ..$ display: chr "Medical Record Number"
#   .. .. ..$ :'data.frame':	1 obs. of  3 variables:
#   .. .. .. ..$ system : chr "http://terminology.hl7.org/CodeSystem/v2-0203"
#   .. .. .. ..$ code   : chr "SS"
#   .. .. .. ..$ display: chr "Social Security Number"
#   .. ..$ text  : chr [1:3] NA "Medical Record Number" "Social Security Number"
#
# we want to flatten this, but the NULL for coding for the first system is a bit
# of a problem.  Simple solution is to unlist all Patient components
#
  stopifnot(inherits(Patient, "BiocFHIR.Patient"))
  ans <- do.call(data.frame, lapply(Patient, function(x) data.frame(t(unlist(x)))))
  ans <- data.frame(t(ans))
  names(ans) <- c("value")
  ans
}
