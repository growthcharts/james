# helpers

update_version_files <- function(html_filepath, rmd_filepath, description_filepath) {
  # Read the DESCRIPTION file and extract the version number
  description_content <- readLines(description_filepath, warn = FALSE)
  version_line <- grep("^Version:", description_content, value = TRUE)
  if (length(version_line) == 0) {
    stop("Version information not found in DESCRIPTION file.")
  }
  version <- sub("Version: ", "", version_line)

  # Define the current date in the required format (YYYYMMDD) and a human-readable format
  current_date_numeric <- format(Sys.Date(), "%Y%m%d")
  current_date_text <- format(Sys.Date(), "%B %Y")

  # Pattern to match the existing version and date in HTML
  html_pattern <- "JAMES [0-9]+\\.[0-9]+\\.[0-9]+(\\.[0-9]+)? \\([0-9]{8}\\)"

  # Replacement string with new version and current date for HTML
  html_replacement <- sprintf("JAMES %s (%s)", version, current_date_numeric)

  # Read the HTML file content
  html_content <- readLines(html_filepath, warn = FALSE)

  # Replace version + date inside the HTML content line-by-line
  html_content <- gsub(
    pattern = html_pattern,
    replacement = html_replacement,
    x = html_content,
    perl = TRUE
  )

  # Write the updated content back to the HTML file
  writeLines(html_content, html_filepath)
  cat("Updated the version in HTML:", html_filepath, "to", html_replacement, "\n")

  # Pattern to match the existing version and date in Rmd
  rmd_pattern <- "subtitle: JAMES [0-9]+\\.[0-9]+\\.[0-9]+(\\.[0-9]+)? \\([A-Za-z]+ [0-9]{4}\\)"

  # Replacement string with new version and current date for Rmd
  rmd_replacement <- sprintf("subtitle: JAMES %s (%s)", version, current_date_text)

  # Read the Rmd file content
  rmd_content <- readLines(rmd_filepath, warn = FALSE)

  # Replace the version and date in the Rmd content
  rmd_content <- gsub(rmd_pattern, rmd_replacement, rmd_content, perl = TRUE)

  # Write the updated content back to the Rmd file
  writeLines(rmd_content, rmd_filepath)
  cat("Updated the version in Rmd:", rmd_filepath, "to", rmd_replacement, "\n")
}


# 'update_openapi_spec' updates the OpenAPI specification file
# james::update_openapi_spec()
update_openapi_spec <- function(
    template = "inst/spec/openapi.in.yaml",
    output = "inst/www/openapi.yaml",
    desc_path = "DESCRIPTION"
) {
  desc <- read.dcf(desc_path)
  content <- readLines(template)

  for (field in colnames(desc)) {
    pattern <- paste0("@@", field, "@@")
    replacement <- desc[1, field]
    content <- gsub(pattern, replacement, content, fixed = TRUE)
  }

  dir.create(dirname(output), recursive = TRUE, showWarnings = FALSE)
  writeLines(content, con = output)
  message("inst/spec/openapi.in.yaml updated: ", output)
}

# Install development packages
# Example, run once:
# james:::install_dev_packages()
install_dev_packages <- function(pkgs = c("roxygen2", "devtools", "desc", "evaluate", "jamesdemodata", "pkgload")) {
  missing <- pkgs[!pkgs %in% rownames(installed.packages())]
  if (length(missing) == 0) {
    message("All development packages are already installed.")
  } else {
    message("Installing missing development packages: ", paste(missing, collapse = ", "))
    install.packages(missing)
  }
}

