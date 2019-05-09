#' Convert json BSD data for single individual to class individual
#'
#' This function takes data from a json source and saves as a an object
#' of class \linkS4class{individual}. The function automatically calculates
#' standard deviation scores and broken stick conditional means per visit.
#' @param txt a JSON string, URL or file
#' @param \dots Additional parameter passed down to
#'   \code{fromJSON(txt, ...)}, \code{new("xyz",... )} and
#'   \code{new("bse",... )}. Useful parameters are \code{models =
#'   "bsmodel"} for setting the broken stick model, or \code{call =
#'   as.call(...)} for setting proper reference standards.
#' @return An object of class \linkS4class{individual}.
#' @author Stef van Buuren 2019
#' @seealso \linkS4class{individual}, \linkS4class{bse}, \linkS4class{xyz},
#'          \code{\link[jsonlite]{fromJSON}}
#' @examples
#' fn <- file.path(path.package("james"), "testdata", "client3.json")
#' p <- bds_to_individual(fn)
#' @keywords server
#' @export
bds_to_individual <- function(txt = NULL, ...) {

  d <- fromJSON(txt, ...)
  b <- d$ClientGegevens$Elementen

  # is this child or message number?
  pid <- new("individualID",
            id = 0L,
            name = d$Referentie,
            dob = as.character(ymd(b[b$Bdsnummer == 20, 2]),
                               format = "%d-%m-%y"),
            src = as.character(d$OrganisatieCode),
            dnr = NA_character_)

  pbg <- new("individualBG",

            sex = switch(b[b$Bdsnummer == 19, 2],
                         "1" = "male",
                         "2" = "female",
                         NA_character_),

            # weken, volgens BDS in dagen
            ga = as.numeric(b[b$Bdsnummer == 82, 2]),

            # 1 = Nee, volgens BDS 1 = Ja, 2 = Nee
            smo = as.numeric(b[b$Bdsnummer == 91, 2]) - 1,

            # in grammen, conform BSD
            bw = as.numeric(b[b$Bdsnummer == 110, 2]),

            # in mm, conform BSD
            hgtm = as.numeric(b[b$Bdsnummer == 238, 2]),

            # in mm, conform BSD
            hgtf = as.numeric(b[b$Bdsnummer == 240, 2]),

            # 510, passief roken, 1 = Nee, 2 = niet als..

            # agem (63 geboortedatum moeder, 62==2)

            # etn (71?)
            # etn = as.character(b[b$Bdsnummer == 71, 2])
            etn = "NL"

            # edu (66 opleiding moeder, 62==2)

  )

  extract_field <- function(d, f = 245) {
    z <- d$Contactmomenten[[2]]
    as.numeric(unlist(lapply(z, function(x, f2 = f) x[x$Bdsnummer == f2, 2])))
  }


  time <-
    data.frame(
      age = round((ymd(d$Contactmomenten[[1]]) - dmy(pid@dob)) / 365.25, 4),
      hgt = extract_field(d, 235) / 10,
      wgt = extract_field(d, 245) / 1000,
      hdc = extract_field(d, 252) / 10,
      stringsAsFactors = FALSE)
  time$bmi <- time$wgt / (time$hgt / 100)^2

  if (is.null(time)) {
    pan <- new("individualAN")
    pbs <- new("individualBS")
  } else {
    pan <- new("individualAN",
             hgt = new("xyz", yname = "hgt",
                       x = as.numeric(time$age),
                       y = as.numeric(time$hgt),
                       sex = pbg@sex),
             wgt = new("xyz", yname = "wgt",
                       x = as.numeric(time$age),
                       y = as.numeric(time$wgt),
                       sex = pbg@sex),
             hdc = new("xyz", yname = "hdc",
                       x = as.numeric(time$age),
                       y = as.numeric(time$hdc),
                       sex = pbg@sex),
             bmi = new("xyz", yname = "bmi",
                       x = as.numeric(time$age),
                       y = as.numeric(time$bmi),
                       sex = pbg@sex),
             wfh = new("xyz", yname = "wfh",
                       xname = "hgt",
                       x = as.numeric(time$hgt),
                       y = as.numeric(time$wgt),
                       sex = pbg@sex))
    pbs <- new("individualBS",
           bs.hgt = new("bse", yname = "hgt",
                        data = pan@hgt,
                        at = "knots",
                        sex = pbg@sex,
                        ...),
           bs.wgt = new("bse", yname = "wgt",
                        data = pan@wgt,
                        at = "knots",
                        sex = pbg@sex,
                        ...),
           bs.hdc = new("bse", yname = "hdc",
                        data = pan@hdc,
                        at = "knots",
                        sex = pbg@sex,
                        ...),
           bs.bmi = new("bse", yname = "bmi",
                        data = pan@bmi,
                        at = "knots",
                        sex = pbg@sex,
                        ...),
           bs.wfh = new("bse", yname = "wfh",
                        xname = "hgt",
                        data = pan@wfh,
                        at = "knots",
                        sex = pbg@sex,
                        ...))
  }

  new("individual", pid, pbg, pan, pbs)
}

