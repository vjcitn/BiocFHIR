  
#' extract information from retained fields in CarePlan component of FHIR Bundle, produce simple data.frame
#' @param CarePlan component of FHIR.bundle instance
#' @return data.frame
#' @examples
#' testf <- system.file("json/Vince741_Rogahn59_6fa3d4ab-c0b6-424a-89d8-7d9105129296.json",
#'    package="BiocFHIR")
#' tbun <- process_fhir_bundle(testf)
#' process_CarePlan(tbun$CarePlan)
#' @note Nov 13 2022, added code to refine the 'category' data processing.
#' @export
process_CarePlan = function (CarePlan) 
{
    stopifnot(inherits(CarePlan, "BiocFHIR.CarePlan"))
    ac <- CarePlan$activity
    recc <- vapply(ac, nrow, numeric(1))
    idvec <- rep(CarePlan$id, recc)
    getdc <- function(x) do.call(rbind, x$detail$code$coding)
    ac_coding <- do.call(rbind, lapply(ac, getdc))
    ac_status <- do.call(c, lapply(ac, function(x) x$detail$status))
    ac_loc <- unname(unlist(lapply(ac, function(x) x$detail$location)))
#
# in synthea data, categories can be more complex; if there are two rows per entry,
# the second will have useful textual information, first will have a 'care plan' code
#
#    cattext = lapply(CarePlan$category, function(x) as.character(na.omit(x$text)))
    last = function(x) x[nrow(x),]
    cattext = lapply(CarePlan$category, last)
#    ml <- lapply(CarePlan$category, function(x) x$coding)
    ml = lapply(cattext, function(x) x$coding)
    uu <- unlist(ml, recursive = FALSE)
    catd <- do.call(rbind, rep(uu, recc))
    subref <- CarePlan$subject$reference
    subid <- rep(subref, recc)
    data.frame(id = idvec, ac_coding, status = ac_status, location = ac_loc, 
        category = catd, subject.reference = subid)
}


process_CarePlan_OLD <- function(CarePlan) {
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
