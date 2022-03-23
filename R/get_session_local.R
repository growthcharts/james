#' pass in the url to the RDS representation of a openCPU session object, get the object
#'
#' useful to programmatically access openCPU session object stored in character variables etc.
#'
#' @param session Character, the session
#' @param object  Character, e.g. ".val"
#' @export
#' @examples
#' \dontrun{
#' get_session_object(session = "x02a93ec661121", object = ".val")
#' }
get_session_object = function(session, object = ".val") {
  sessionenv <- new.env()
  sessionfile <- file.path("/tmp/ocpu-store", session, ".RData")
  if (!file.exists(sessionfile)) stop("sessionfile not found: ", sessionfile)
  load(sessionfile, envir = sessionenv)
  return(sessionenv[[object]])
}
