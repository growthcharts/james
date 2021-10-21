library(testthat)
library(james)

skip_if_auth <- function() {
  if (identical(Sys.getenv("JWT_AUTH"), "n")) {
    return(invisible(TRUE))
  }
  skip("Not run when authentication is on")
}

test_check("james")
