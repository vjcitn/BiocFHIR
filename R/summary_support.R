#' vector of fields to be selected for summarization
#' @return named vector of strings
#' @export
summary_selections = function() c(AllergyIntolerance = "code.display", CarePlan = "category.display", 
Claim = "insurance", Condition = "code.coding.display", Encounter = "type.display", 
Immunization = "vaccineCode.display", MedicationRequest = "medicationCodeableConcept.display", 
Observation = "code.coding.display", Patient = "id", Procedure="code.display"
)

#' produce tables summarizing FHIR data
#' @import dplyr
#' @param blist list of ingested bundles
#' @param resource character(1) FHIR resource name
#' @param selection_map character() named vector of single strings selected for summarisation
#' @return data.frame
#' @export
summarise_bundles = function(blist, resource="Condition", selection_map = summary_selections()) {
 st = stack_fhir(blist, resource)
 vbl = as.character(selection_map[resource])
 #st |> select(code.coding.display) |> group_by(code.coding.display) |> summarise(n=n())
 st |> select(!!sym(vbl)) |> group_by(!!sym(vbl)) |> summarise(n=n()) |> arrange(desc(n))
}
