pubkey <- openssl::read_pubkey("data-raw/data/jwt_public.pem")
usethis::use_data(pubkey, internal = TRUE, overwrite = TRUE, compress = "gzip")
