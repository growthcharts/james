# Load data from a previous OpenCPU session on same host

This function loads data from a previous OpenCPU session on the same
host. The assumption is that sessions are stored in path
`/tmp/ocpu-store`. Provides a short-cut to the data eliminating the need
to make self-requests.

## Usage

``` r
get_session_object(session, object = ".val")
```

## Arguments

- session:

  Character, e.g. `session = "x077dd78bd0bbc6"`

- object:

  Character, e.g. `object = ".val"`. Refers to objects within the `/R`
  path (e.g. function returns or variables saved in scripts).

## Value

If found, object from a the session. If not found, the function
generates a warning and return `NULL`.

## Examples

``` r
if (FALSE) { # \dontrun{
get_session_object(session = "x02a93ec661121", object = ".val")
} # }
```
