
#' extract information from retained fields in Observation component of FHIR Bundle, produce simple data.frame
#' @importFrom tidyr unnest
#' @param Observation component of FHIR.bundle instance
#' @return data.frame
#' @examples
#' testf = system.file("json/Vince741_Rogahn59_6fa3d4ab-c0b6-424a-89d8-7d9105129296.json",
#'    package="BiocFHIR")
#' tbun = process_fhir_bundle(testf)
#' process_Observation(tbun$Observation)
#' @export
process_Observation = function(Observation) {
 stopifnot(inherits(Observation, "BiocFHIR.Observation"))
 coding = do.call(rbind, Observation$code$coding)
 data.frame(id=Observation$id, code.coding=coding)
}
