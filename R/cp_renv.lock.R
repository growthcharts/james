#' Copy renv.lock to jamesdocker package
#'
cp_renv.lock <- function() {
  file.copy(from = "renv.lock",
            to = "~/Package/jamesdocker/jamesdocker/files/opencpu_config/renv.lock",
            overwrite = TRUE)
  cat("File renv.lock copied into jamesdocker.\n")
}

