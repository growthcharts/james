# create local jwt and pubkey
key <- openssl::rsa_keygen(bits = 2048)
pubkey <- as.list(key)$pubkey
claim <- jose::jwt_claim(data = list(applications = "james;srm;psycat"))
jwt <- jose::jwt_encode_sig(claim, key = key)

test_that("validates with local key", {
  expect_equal(james:::authenticate_status(), Sys.getenv("JWT_AUTH") == "y")
  expect_true(james:::authenticate(jwt, pubkey))
})
