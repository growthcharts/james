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
  html_pattern <- "JAMES [0-9]+\\.[0-9]+\\.[0-9]+ \\([0-9]+\\)"

  # Replacement string with new version and current date for HTML
  html_replacement <- sprintf("JAMES %s (%s)", version, current_date_numeric)

  # Read the HTML file content
  html_content <- readLines(html_filepath, warn = FALSE)

  # Replace the version and date in the HTML content
  html_content <- gsub(html_pattern, html_replacement, html_content, perl = TRUE)

  # Write the updated content back to the HTML file
  writeLines(html_content, html_filepath)
  cat("Updated the version in HTML:", html_filepath, "to", html_replacement, "\n")

  # Pattern to match the existing version and date in Rmd
  rmd_pattern <- "subtitle: JAMES [0-9]+\\.[0-9]+\\.[0-9]+ \\([A-Za-z]+ [0-9]{4}\\)"

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

