convert_str_age <- function(s) {
  # converts s to decimal age
  # s is formatted as "number|unit", where unit
  # is 'd' (days), 'w' (weeks), 'm' (months), 'y' or 'j' (years)
  # s <- c("2m", "7.5m", "1y", "12", "", NULL, "xd")
  units <- substr(s, nchar(s), nchar(s))
  numbers <- as.numeric(gsub("[^\\d\\.]+", "", s, perl=TRUE))
  z <- numbers
  z[units == "d"] <- z[units == "d"] / 365.25
  z[units == "w"] <- z[units == "w"] * 7 / 365.25
  z[units == "m"] <- z[units == "m"] / 12
  z
}


