
test_that("ingest succeeds", {
 library(BiocFHIR)
 example(process_fhir_bundle)
 expect_true(length(names(tbun))>0)
})
