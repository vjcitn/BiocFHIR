#' produce 50 json FHIR files in a folder
#' @param target character(1) a path, defaults to `jsontest` under `tempdir()`; the
#' contents of synthfhir.zip, in inst/zip of BiocFHIR, will be deposted there.
#' @return a vector of paths to FHIR JSON, invisibly
#' @export
make_test_json_set = function(target=paste0(tempdir(), "/jsontest")) {
  if (dir.exists(target)) stop("target folder already exists")
  dir.create(target)
  file.copy(system.file("zip/synthfhir.zip", package="BiocFHIR"), target)
  od = getwd()
  setwd(target)
  unzip("synthfhir.zip")
  ans = dir(target, full=TRUE, patt="json$")
  setwd(od)
  invisible(ans)
}
  
  
