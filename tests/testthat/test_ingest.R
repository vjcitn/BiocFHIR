
library(testthat)
library(BiocFHIR)
test_that("ingest succeeds", {
 library(BiocFHIR)
 example(process_fhir_bundle)
 expect_true(length(names(tbun))>0)
})

myl = make_test_json_set()
if (!exists("bs")) bs = lapply(myl, process_fhir_bundle)


test_that("stack for CarePlan is correct",
 {
 ss = stack_fhir(bs, "CarePlan")
print(dim(ss))
print(head(ss))
 expect_true(nrow(ss)==231)
 expect_true(ncol(ss)==10)
 })

test_that("stack for Claim is correct",
 {
 ss = stack_fhir(bs, "Claim")
print(dim(ss))
 expect_true(nrow(ss)==1423)
 expect_true(ncol(ss)==9)
 })

test_that("stack for Condition is correct",
 {
 ss = stack_fhir(bs, "Condition")
print(dim(ss))
 expect_true(nrow(ss)==247)
 expect_true(ncol(ss)==5)
 })

test_that("stack for Encounter is correct",
 {
 ss = stack_fhir(bs, "Encounter")
print(dim(ss))
# print(dim(ss))
 expect_true(TRUE)
 expect_true(nrow(ss)==1032)
 expect_true(ncol(ss)==9)
 })

test_that("stack for Immunization is correct",
 {
 ss = stack_fhir(bs, "Immunization")
print(dim(ss))
 expect_true(nrow(ss)==406)
 expect_true(ncol(ss)==6)
 })

test_that("stack for MedicationRequest is correct",
 {
 ss = stack_fhir(bs, "MedicationRequest")
print(dim(ss))
 expect_true(nrow(ss)==391)
 expect_true(ncol(ss)==8)
 })


test_that("stack for Observation is correct",
 {
 ss = stack_fhir(bs, "Observation")
print(dim(ss))
 expect_true(nrow(ss)==6860)
 expect_true(ncol(ss)==11)
 })

test_that("stack for Patient is correct",
 {
 ss = stack_fhir(bs, "Patient")
 print(dim(ss))
 expect_true(TRUE)
 expect_true(nrow(ss)==30)
 expect_true(ncol(ss)==40)
 })

test_that("stack for Procedure is correct",
 {
 ss = stack_fhir(bs, "Procedure")
print(dim(ss))
 expect_true(nrow(ss)==881)
 expect_true(ncol(ss)==8)
 })

#> names(bs[[1]])
#[1] "CarePlan"          "Claim"             "Condition"        
#[4] "Encounter"         "Immunization"      "MedicationRequest"
#[7] "Observation"       "Patient"           "Procedure"        
#example(process_Claim)
#ss = stack_fhir(bs, "Claim")
#example(process_Condition)
#ss = stack_fhir(bs, "Condition")
#example(process_Encounter)
#ss = stack_fhir(bs, "Encounter")
#example(process_Immunization)
#ss = stack_fhir(bs, "Immunization")
#example(process_MedicationRequest)
#ss = stack_fhir(bs, "MedicationRequest")
#example(process_Observation)
#ss = stack_fhir(bs, "Observation")
#example(process_Patient)
#ss = stack_fhir(bs, "Patient")
#example(process_Procedure)
#ss = stack_fhir(bs, "Procedure")

