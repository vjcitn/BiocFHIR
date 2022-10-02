#' extract information from retained fields in Claim component of FHIR Bundle, produce simple data.frame
#' @importFrom tidyr unnest
#' @param Claim component of FHIR.bundle instance
#' @return data.frame
#' @examples
#' testf = system.file("json/Vince741_Rogahn59_6fa3d4ab-c0b6-424a-89d8-7d9105129296.json",
#'    package="BiocFHIR")
#' tbun = process_fhir_bundle(testf)
#' process_Claim(tbun$Claim)
#' @export
process_Claim = function(Claim) {
 stopifnot(inherits(Claim, "BiocFHIR.Claim"))
 ins = Claim$insurance
 insdf = do.call(rbind, lapply(ins, tidyr::unnest, cols=c()))
 data.frame(id=cl$id,patient=cl$patient,provider=cl$provider, insurance=insdf,
     billablePeriod=cl$billablePeriod, created=cl$created)
}
