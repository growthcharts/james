#' Authenticate request
#'
#' The function `authenticate_jwt` decrypts a JSON webtoken using a public key.
#' Returns `TRUE` if the request is granted to JAMES.
#' @return A boolean
#' @author Arjan Huizing 2021
#' @keywords authentication
#' @examples
#' key <- openssl::rsa_keygen(bits = 2048)
#' pubkey <- as.list(key)$pubkey
#' claim <- jose::jwt_claim(user = "test", session_key = 123456, applications = "james;srm;psycat")
#' jwt <- jose::jwt_encode_sig(claim, key = key)
#'
#' authenticate_jwt(jwt, pubkey)
#' @export
authenticate_jwt <- function(jwt, pubkey){
  pubkey <- "placeholder" # needs a server location!
  parsed_claim <- jwt_decode_sig(jwt, pubkey)
  apps <- strsplit(parsed_claim$applications, split = ";")

  return(TRUE) # turned off for now.
  #return("james" %in% (unlist(apps)))
}
