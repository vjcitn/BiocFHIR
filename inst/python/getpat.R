get_resources = function(jsonpath, maxres=50) {
 pybundle = reticulate::import("fhir.resources")$bundle
 pyjson = reticulate::import("json", convert=FALSE)
# os = reticulate::import("os", convert=FALSE)
# ro = os$O_RDONLY
# jp = os$open(jsonpath, ro)
 dat = readLines(jsonpath)
 dat = paste(dat, collapse="")
 json_obj = pyjson$loads(dat)
 bundle = pybundle$Bundle$parse_obj(json_obj)
 res = py_run_string("res = []", convert=FALSE)
 for (i in 1:min(c(maxres, length(bundle$entry)))) { # 50) { # length(bundle$entry)) { # SLOW!
   if (i %% 10 == 0) cat(".")
   py_eval("res.append")(bundle$entry[[i]]$resource)
   }
 #cat("\n")
 #py_eval("res")
 #pypatient$Patient$parse_obj(py_eval("res[0]"))
 list(resources=py_eval("res"), resources_dict=py_eval("res[0]"))
}

z = get_resources("./Vince741_Rogahn59_6fa3d4ab-c0b6-424a-89d8-7d9105129296.json", 30)

get_patient_demog = function(reslist, reduce=TRUE) {
 stopifnot(inherits(reslist[[1]][[1]], "fhir.resources.resource.Resource"))
 pypatient = reticulate::import("fhir.resources")$patient
 ans = pypatient$Patient$parse_obj(reslist[["resources_dict"]])
 if (reduce) {
   id = ans$id
   gender = ans$gender
   birthDate = ans$birthDate
   given_name = ans$name[[1]]$given
   family_name = ans$name[[1]]$family
   return(c(id=id, 
             gender=gender, 
             birthDate=birthDate,
             given_name=given_name, 
             family_name=family_name))
 }
 ans
}

get_patient_demog(z)
 
