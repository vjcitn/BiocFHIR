

#' extract information from retained fields in Encounter component of FHIR Bundle, produce simple data.frame
#' @importFrom tidyr unnest
#' @param Encounter component of FHIR.bundle instance
#' @return data.frame
#' @examples
#' testf <- system.file("json/Vince741_Rogahn59_6fa3d4ab-c0b6-424a-89d8-7d9105129296.json",
#'    package="BiocFHIR")
#' tbun <- process_fhir_bundle(testf)
#' process_Encounter(tbun$Encounter)
#' @export
process_Encounter <- function(Encounter) {
  stopifnot(inherits(Encounter, "BiocFHIR.Encounter"))
  type <- do.call(rbind, lapply(Encounter$type, function(x)(x$coding[[1]])))
  subj <- Encounter$subject$reference
  prov <- Encounter$serviceProvider
  per <- Encounter$period
  data.frame(id=Encounter$id, type=type, subject=subj, serviceProvider=prov,
    period=per)
}

#' extract information from retained fields in AllergyIntolerance component of FHIR Bundle, produce simple data.frame
#' @importFrom tidyr unnest
#' @param AllergyIntolerance component of FHIR.bundle instance
#' @return data.frame
#' @examples
#' testf <- system.file("json/Vince741_Rogahn59_6fa3d4ab-c0b6-424a-89d8-7d9105129296.json",
#'    package="BiocFHIR")
#' tbun <- process_fhir_bundle(testf)
#' process_AllergyIntolerance(tbun$AllergyIntolerance)
#' @export
process_AllergyIntolerance <- function(AllergyIntolerance) {
 stopifnot(inherits(AllergyIntolerance, "BiocFHIR.AllergyIntolerance"))
 coding <- do.call(rbind, AllergyIntolerance$code$coding)
 data.frame(id=AllergyIntolerance$id, onsetDateTime=AllergyIntolerance$onsetDateTime,
   patient.reference=AllergyIntolerance$patient$reference,
   category=unlist(AllergyIntolerance$category), code=coding)
}

# extract information from retained fields in Observation component of FHIR Bundle, produce simple data.frame
# @importFrom tidyr unnest
# @param Observation component of FHIR.bundle instance
# @return data.frame
# @examples
# testf <- system.file("json/Vince741_Rogahn59_6fa3d4ab-c0b6-424a-89d8-7d9105129296.json",
#    package="BiocFHIR")
# tbun <- process_fhir_bundle(testf)
# process_Observation(tbun$Observation)
# @export
#process_Observation <- function(Observation) {
# stopifnot(inherits(Observation, "BiocFHIR.Observation"))
# coding <- do.call(rbind, Observation$code$coding)
# data.frame(id=Observation$id, subject.reference=Observation$subject$reference, code.coding=coding, valueQuantity=Observation$valueQuantity, effectiveDateTime=Observation$effectiveDateTime, issued=Observation$issued)
#}

#' extract information from retained fields in MedicationRequest component of FHIR Bundle, produce simple data.frame
#' @importFrom tidyr unnest
#' @param MedicationRequest component of FHIR.bundle instance
#' @return data.frame
#' @examples
#' testf <- system.file("json/Vince741_Rogahn59_6fa3d4ab-c0b6-424a-89d8-7d9105129296.json",
#'    package="BiocFHIR")
#' tbun <- process_fhir_bundle(testf)
#' process_MedicationRequest(tbun$MedicationRequest)
#' @export
process_MedicationRequest <- function(MedicationRequest) {
  stopifnot(inherits(MedicationRequest, "BiocFHIR.MedicationRequest"))
  mr <- MedicationRequest
  mrco <- do.call(rbind, mr$medicationCodeableConcept$coding)
  data.frame(id=MedicationRequest$id, subject=mr$subject$reference, status=mr$status, requester=mr$requester, medicationCodeableConcept=mrco)
}

#' extract information from retained fields in Procedure component of FHIR Bundle, produce simple data.frame
#' @importFrom tidyr unnest
#' @param Procedure component of FHIR.bundle instance
#' @return data.frame
#' @examples
#' testf <- system.file("json/Vince741_Rogahn59_6fa3d4ab-c0b6-424a-89d8-7d9105129296.json",
#'    package="BiocFHIR")
#' tbun <- process_fhir_bundle(testf)
#' process_Procedure(tbun$Procedure)
#' @export
process_Procedure <- function(Procedure) {
  stopifnot(inherits(Procedure, "BiocFHIR.Procedure"))
  pro <- Procedure
  coding <- do.call(rbind, Procedure$code$coding)
  data.frame(id=pro$id,subject=pro$subject$reference, status=pro$status, performedPeriod=pro$performedPeriod, 
     code=coding)
}

#' extract information from retained fields in Immunization component of FHIR Bundle, produce simple data.frame
#' @importFrom tidyr unnest
#' @param Immunization component of FHIR.bundle instance
#' @return data.frame
#' @examples
#' testf <- system.file("json/Vince741_Rogahn59_6fa3d4ab-c0b6-424a-89d8-7d9105129296.json",
#'    package="BiocFHIR")
#' tbun <- process_fhir_bundle(testf)
#' process_Immunization(tbun$Immunization)
#' @export
process_Immunization <- function(Immunization) {
  stopifnot(inherits(Immunization, "BiocFHIR.Immunization"))
  pro <- Immunization
  coding <- do.call(rbind, Immunization$vaccineCode$coding)
  data.frame(id=pro$id, patient=pro$patient$reference, vaccineCode=coding, occurrenceDateTime=pro$occurrenceDateTime)
}
