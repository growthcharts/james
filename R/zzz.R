.onLoad <- function(libname, pkgname) {
  op <- options()
  op.james <- list(
    max.print = 100000
  )
  toset <- names(op)
  options(op.james[toset])

  invisible()
}
