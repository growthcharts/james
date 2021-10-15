#' Authentication request
#'
#' The function `authenticate()` decrypts a JSON webtoken using a public key.
#' Returns `TRUE` if the request is granted to JAMES.
#'
#' @rdname authenticate
#' @inheritParams jose::jwt_encode_sig
#' @param \dots Not used
#' @return A boolean
#' @author Arjan Huizing, Stef van Buuren 2021
#' @keywords authentication
#' @examples
#' key <- openssl::rsa_keygen(bits = 2048)
#' pubkey <- as.list(key)$pubkey
#' claim <- jose::jwt_claim(user = "test", session_key = 123, applications = "james;srm;psycat")
#' jwt <- jose::jwt_encode_sig(claim, key = key)
#' james:::authenticate(jwt, pubkey)
authenticate <- function(jwt = NULL, pubkey = NULL, ...) {
  if (!authenticate_jwt(jwt = jwt, pubkey = pubkey)) {
    stop("JAMES: No authorisation.")
  }
  return(invisible(TRUE))
}

authenticate_jwt <- function(jwt = NULL, pubkey = NULL) {
  if (!authenticate_status()) {
    return(TRUE)
  }
  if (is.null(jwt)) stop("JAMES: No token found.")
  if (is.null(pubkey)) stop("JAMES: No public key found.")
  parsed_claim <- jwt_decode_sig(jwt, pubkey)
  apps <- unlist(strsplit(parsed_claim$applications, split = ";"))
  return("james" %in% apps)
}

authenticate_status <- function(x = NA) {
  if (is.na(x)) {
    return(invisible(ifelse(Sys.getenv("JWT_AUTH") == "n", FALSE, TRUE)))
  }
  Sys.setenv("JWT_AUTH" = ifelse(x, "y", "n"))
  authenticate_status()
}
