  
#' extract information from retained fields in CarePlan component of FHIR Bundle, produce simple data.frame
#' @param CarePlan component of FHIR.bundle instance
#' @return data.frame
#' @examples
#' testf <- system.file("json/Vince741_Rogahn59_6fa3d4ab-c0b6-424a-89d8-7d9105129296.json",
#'    package="BiocFHIR")
#' tbun <- process_fhir_bundle(testf)
#' process_CarePlan(tbun$CarePlan)
#' @export
process_CarePlan <- function(CarePlan) {
# record count
 stopifnot(inherits(CarePlan, "BiocFHIR.CarePlan"))
 ac <- CarePlan$activity
 recc <- vapply(ac, nrow, numeric(1))
 idvec <- rep(CarePlan$id, recc)  # event ids
 getdc <- function(x) do.call(rbind, x$detail$code$coding)
 ac_coding <- do.call(rbind, lapply(ac, getdc))
 ac_status <- do.call(c, lapply(ac, function(x) x$detail$status))
 ac_loc <- unname(unlist(lapply(ac, function(x) x$detail$location)))
#
# process category
#
 ml <- lapply(CarePlan$category, function(x)x$coding)
 uu <- unlist(ml, recursive=FALSE) 
 catd <- do.call(rbind, rep(uu, recc))
#
 subref <- CarePlan$subject$reference
 subid <- rep(subref, recc)
 data.frame(id=idvec, ac_coding, status=ac_status, location=ac_loc, category=catd, subject.reference=subid)
}
