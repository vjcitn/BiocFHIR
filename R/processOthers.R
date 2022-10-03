#  Encounter = c("id", "type", "subject", "period", "serviceProvider"),
#  MedicationRequest = c("id", "subject", "status", "requester", "medicationCodeableConcept"),
#  Procedure = c("id", "subject", "status", "performedPeriod", "code"),
#  Immunization = c("id", "patient", "vaccineCode", "occurrenceDateTime")

#Browse[2]> spl$Encounter[1,]
#  resourceType                                   id text.status text.div
#4    Encounter a2dbf45f-4d45-4d15-9519-eea32b9b1d44        <NA>     <NA>
#  extension identifier name telecom gender birthDate deceasedDateTime address
#4      NULL       NULL NULL    NULL   <NA>      <NA>             <NA>    NULL
#  maritalStatus.coding maritalStatus.text multipleBirthBoolean communication
#4                 NULL               <NA>                   NA          NULL
#  active
#4     NA
#                                                                             type
#4 http://snomed.info/sct, 185347001, Encounter for problem, Encounter for problem
#    status                                     class.system class.code
#4 finished http://terminology.hl7.org/CodeSystem/v3-ActCode        AMB
#                              subject.reference   subject.display
#4 urn:uuid:eedf9986-9cf8-4e90-bf68-12a6dd9a31c2 Vince741 Rogahn59
#                                                              participant
#4 urn:uuid:0000016d-3a85-4cca-0000-00000000010e, Dr. Renato359 Jenkins714
#               period.start                period.end
#4 1972-06-17T07:25:09-04:00 1972-06-17T07:40:09-04:00
#                      serviceProvider.reference serviceProvider.display
#4 urn:uuid:d692e283-0833-3201-8e55-4f868a9c0736  HALLMARK HEALTH SYSTEM
#  reference managingOrganization intent category careTeam activity  use
#4      <NA>                 NULL   <NA>     NULL     NULL     NULL <NA>
#  patient.reference patient.display billablePeriod.start billablePeriod.end
#4              <NA>            <NA>                 <NA>               <NA>
#  created provider.reference provider.display coding insurance item total
#4    <NA>               <NA>             <NA>   NULL      NULL NULL  NULL
#  contained display reference reference outcome payment.amount.value
#4      NULL    <NA>      <NA>      <NA>    <NA>                   NA
#  payment.amount.currency coding coding criticality code.coding code.text
#4                    <NA>   NULL   NULL        <NA>        NULL      <NA>
#4                                      <NA>


#' extract information from retained fields in Encounter component of FHIR Bundle, produce simple data.frame
#' @importFrom tidyr unnest
#' @param Encounter component of FHIR.bundle instance
#' @return data.frame
#' @examples
#' testf = system.file("json/Vince741_Rogahn59_6fa3d4ab-c0b6-424a-89d8-7d9105129296.json",
#'    package="BiocFHIR")
#' tbun = process_fhir_bundle(testf)
#' process_Encounter(tbun$Encounter)
#' @export
process_Encounter = function(Encounter) {
  stopifnot(inherits(Encounter, "BiocFHIR.Encounter"))
  type = do.call(rbind, lapply(Encounter$type, function(x)(x$coding[[1]])))
  subj = Encounter$subject$reference
  prov = Encounter$serviceProvider
  per = Encounter$period
  data.frame(id=Encounter$id, type=type, subject=subj, serviceProvider=prov,
    period=per)
}

#' extract information from retained fields in Observation component of FHIR Bundle, produce simple data.frame
#' @importFrom tidyr unnest
#' @param AllergyIntolerance component of FHIR.bundle instance
#' @return data.frame
#' @examples
#' testf = system.file("json/Vince741_Rogahn59_6fa3d4ab-c0b6-424a-89d8-7d9105129296.json",
#'    package="BiocFHIR")
#' tbun = process_fhir_bundle(testf)
#' process_AllergyIntolerance(tbun$AllergyIntolerance)
#' @export
process_AllergyIntolerance = function(AllergyIntolerance) {
 stopifnot(inherits(AllergyIntolerance, "BiocFHIR.AllergyIntolerance"))
 coding = do.call(rbind, AllergyIntolerance$code$coding)
 data.frame(id=AllergyIntolerance$id, onsetDateTime=AllergyIntolerance$onsetDateTime,
   patient.reference=AllergyIntolerance$patient$reference,
   category=unlist(AllergyIntolerance$category))
}

# extract information from retained fields in Observation component of FHIR Bundle, produce simple data.frame
# @importFrom tidyr unnest
# @param Observation component of FHIR.bundle instance
# @return data.frame
# @examples
# testf = system.file("json/Vince741_Rogahn59_6fa3d4ab-c0b6-424a-89d8-7d9105129296.json",
#    package="BiocFHIR")
# tbun = process_fhir_bundle(testf)
# process_Observation(tbun$Observation)
# @export
#process_Observation = function(Observation) {
# stopifnot(inherits(Observation, "BiocFHIR.Observation"))
# coding = do.call(rbind, Observation$code$coding)
# data.frame(id=Observation$id, subject.reference=Observation$subject$reference, code.coding=coding, valueQuantity=Observation$valueQuantity, effectiveDateTime=Observation$effectiveDateTime, issued=Observation$issued)
#}
