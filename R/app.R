#process_CarePlan.R:process_CarePlan = function(CarePlan) {
#process_Claim.R:process_Claim = function(Claim) {
#process_Condition.R:process_Condition = function(Condition) {
#process_Observation.R:process_Observation = function(Observation) {
#processOthers.R:process_Encounter = function(Encounter) {
#processOthers.R:process_AllergyIntolerance = function(AllergyIntolerance) {
#processOthers.R:#process_Observation = function(Observation) {
#processOthers.R:process_MedicationRequest = function(MedicationRequest) {
#processOthers.R:process_Procedure = function(Procedure) {
#processOthers.R:process_Immunization = function(Immunization) {
#process_Patient.R:process_Patient = function(Patient) {
#use_json.R:process_fhir_bundle = function(json_file) {


#' table app
#' @import shiny
#' @export
FHIRtabs = function() {
  fns = make_test_json_set()
  zn = gsub(".*jsontest/", "", fns)
  zns = strsplit(zn, "_")
  fn = sapply(zns, "[", 1)
  ln = sapply(zns, "[", 2)
  folks = paste(fn, ln, sep="_")

  names(fns) = folks
  ui = fluidPage(
   sidebarLayout(
    sidebarPanel(
     helpText("FHIR viewer for synthea data subset"),
     selectInput("indiv", "Person", choices=fns), width=2
     ),
    mainPanel(
     tabsetPanel(
      tabPanel("patient",
       DT::dataTableOutput("patient")
       ),
      tabPanel("condition",
       DT::dataTableOutput("condition")
       ),
      tabPanel("encounter",
       DT::dataTableOutput("encounter")
       ),
      tabPanel("observation",
       DT::dataTableOutput("observation")
       ),
      tabPanel("claims",
       DT::dataTableOutput("claims")
       )
      )
     )
    )
   ) # fluidPage

   server = function(input, output) {
     fdat = reactive({
      process_fhir_bundle(input$indiv)
      })
     output$patient = DT::renderDataTable({
         process_Patient(fdat()$Patient)
         })
     output$observation = DT::renderDataTable({
         process_Observation(fdat()$Observation)
         })
     output$claims = DT::renderDataTable({
         process_Claim(fdat()$Claim)
         })
     output$condition = DT::renderDataTable({
         process_Condition(fdat()$Condition)
         })
     output$encounter = DT::renderDataTable({
         process_Encounter(fdat()$Encounter)
         })
     }
    runApp(list(ui=ui, server=server))
   }

