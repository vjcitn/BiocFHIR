#' extract information from retained fields in Condition component of FHIR Bundle, produce simple data.frame
#' @importFrom tidyr unnest
#' @param Condition component of FHIR.bundle instance
#' @return data.frame
#' @examples
#' testf = system.file("json/Vince741_Rogahn59_6fa3d4ab-c0b6-424a-89d8-7d9105129296.json",
#'    package="BiocFHIR")
#' tbun = process_fhir_bundle(testf)
#' process_Condition(tbun$Condition)
#' @export
process_Condition = function(Condition) {
 stopifnot(inherits(Condition, "BiocFHIR.Condition"))
 coding = do.call(rbind, tbun$Condition$code$coding)
 data.frame(id=Condition$id,subject.reference=Condition$subject$reference, code.coding=coding)
}
