#' FHIR Resource types recognized in package
#' @examples
#' FHIR_Resource_types() # Oct 2022
#' @export
FHIR_ResourceTypes = function() {
 c("AllergyIntolerance", "CarePlan", "CareTeam", 
  "Claim", "Condition", "DiagnosticReport", 
  "Encounter", "ExplanationOfBenefit", "Immunization", 
  "MedicationRequest", "Observation", "Organization", 
  "Patient", "Practitioner", "Procedure")
}

#' collection of FHIR Resource components to be retained
#' @examples
#' FHIR_retention_schemas() # Oct 2022
#' @export
FHIR_retention_schemas = function() {
list(
  Condition = c("id", "onsetDateTime", "code", "subject"),
  AllergyIntolerance = c("id", "onsetDateTime", "code", "patient", "category"),
  CarePlan = c("id", "activity", "subject", "category"),
  Claim = c("id", "provider", "patient", "billablePeriod", "insurance", "created"),
  Encounter = c("id", "type", "subject", "period", "serviceProvider", "class"),
  MedicationRequest = c("id", "subject", "status", "requester", "medicationCodeableConcept"),
  Observation = c("id", "subject", "code", "valueQuantity", "category",
    "effectiveDateTime", "issued"),
  Procedure = c("id", "subject", "status", "performedPeriod", "code"),
  Patient = c("id", "identifier", "name", 
    "telecom", "gender", "birthDate", "address",   # dropped deceasedDateTime oct 2 2022
    "maritalStatus", "multipleBirthBoolean", "communication", "active"),
  Immunization = c("id", "patient", "vaccineCode", "occurrenceDateTime")
 )
}

