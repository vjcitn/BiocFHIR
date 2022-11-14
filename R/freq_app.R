#> summary_selections
#function() c(AllergyIntolerance = "code.display", CarePlan = "category.display", 
#Claim = "insurance", Condition = "code.coding.display", Encounter = "type.display", 
#Immunization = "vaccineCode.display", MedicationRequest = "medicationCodeableConcept.display", 
#Observation = "code.coding.display", Patient = "id", Procedure="code.display"
#)
#<bytecode: 0x56243b038e18>
#> names(summary_selections())
# [1] "AllergyIntolerance" "CarePlan"           "Claim"             
# [4] "Condition"          "Encounter"          "Immunization"      
# [7] "MedicationRequest"  "Observation"        "Patient"           
#[10] "Procedure"  


#' produce interactive tables with FHIR resources from a list of ingested bundles
#' @import shiny
#' @param blist list of ingested bundles
#' @return side-effects of shiny app invocation
#' @export
freq_app = function(blist) {
 ui = fluidPage(
  sidebarLayout(
   sidebarPanel(
    helpText("BiocFHIR bundle tabulator"),
    radioButtons("type", "type", choices=c("event", "patient"), selected="event"),
   width=2),
   mainPanel(
    tabsetPanel(
     tabPanel("Condition",
      DT::dataTableOutput("cond")),
     tabPanel("Med",
      DT::dataTableOutput("medreq")),
     tabPanel("Procedure",
      DT::dataTableOutput("proc")),
     tabPanel("Allergy",
      DT::dataTableOutput("allint")),
     tabPanel("Immunization",
      DT::dataTableOutput("immuz")),
     tabPanel("About",
      helpText("Derived from synthea -p 10000")
      )
     )
    )
   )
  )

server = function(input, output, session) {
 output$cond = DT::renderDataTable(
  summarise_bundles(blist, "Condition")
  )
 output$medreq = DT::renderDataTable(
  summarise_bundles(blist, "MedicationRequest")
  )
 output$proc = DT::renderDataTable(
  summarise_bundles(blist, "Procedure")
  )
 output$allint = DT::renderDataTable(
  summarise_bundles(blist, "AllergyIntolerance")
  )
 output$immuz = DT::renderDataTable(
  summarise_bundles(blist, "Immunization")
  )
 }
 
 runApp(list(ui=ui, server=server))
}
  
   
