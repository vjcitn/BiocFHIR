
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
 ans = data.frame(id=Observation$id, subject.reference=Observation$subject$reference, 
     code.coding=coding, valueQuantity=Observation$valueQuantity, 
     effectiveDateTime=Observation$effectiveDateTime, issued=Observation$issued)
# bloodpressure records are nested in component
  fixbp = function(component.element) {
    al = as.list(component.element)
    data.frame(bp.text=al$code$text, bp.vals=al$valueQuantity)
  }
# get bp records
 isbp = which(ans$code.coding.display == "Blood Pressure")
 if (length(isbp)>0) {
   bprecs = ans[isbp,,drop=FALSE]
   ans = ans[-isbp,,drop=FALSE]
   }
# get associated 'component' records, which have nested data.frame each with 2 rows
 allcomp = Observation$component[isbp]

 fixedbp = do.call(rbind, lapply(allcomp, fixbp))

# use new data.frames from fixbp and doubling of "Blood Pressure" record metadata
# to produce a conformant data.frame
 newid = rep(bprecs$id, each=2)
 newsubjref = rep(bprecs$subject.reference, each=2)
 newcodesys = rep(bprecs$code.coding.system, each=2)
 newcodecod = rep(bprecs$code.coding.code, each=2)
 newdatetime = rep(bprecs$effectiveDateTime, each=2)
 newissued = rep(bprecs$issued, each=2)
 newcodedisp = fixedbp$bp.text
 newvqv = fixedbp$bp.vals.value
 newvqu = fixedbp$bp.vals.unit
 newvqs = fixedbp$bp.vals.system

 revdf = data.frame(id=newid, subject.reference=newsubjref,
   code.coding.system=newcodesys,
   code.coding.code=newcodecod,
   code.coding.display=newcodedisp,
   valueQuantity.value = newvqv,
   valueQuantity.unit = newvqu,
   valueQuantity.system = newvqs,
   valueQuantity.code = NA,
   effectiveDateTime = newdatetime,
   issued = newissued)

 ans = rbind(ans, revdf) 
 ans
}
