# Authentication request

The function `authenticate()` decrypts a JSON webtoken using a public
key. Returns `TRUE` if the request is granted to JAMES.

## Usage

``` r
authenticate(authToken = NULL, pubkey = NULL, ...)
```

## Arguments

- authToken:

  String containing the JSON Web Token (JWT)

- pubkey:

  Path or object with RSA or EC public key. When not given, JAMES will
  search internally for the public key.

- ...:

  Not used

## Value

A boolean

## Author

Arjan Huizing, Stef van Buuren 2021

## Examples

``` r
key <- openssl::rsa_keygen(bits = 2048)
pubkey <- as.list(key)$pubkey
claim <- jose::jwt_claim(data = list(applications = "james;srm;psycat"))
jwt <- jose::jwt_encode_sig(claim, key = key)
james:::authenticate(jwt, pubkey)
```
