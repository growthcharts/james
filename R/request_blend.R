#' Provides a Screen growth curves according to JGZ guidelines
#'
#' @inheritParams request_site
#' @param blend A string indicating the requested blend. The default (`"standard"`)
#' returns the results of all standard end points.
#' @return The default `blend = "standard"` return a list with the following
#' components:
#' \describe{
#'   \item{`txt`}{String, file or URL with child data}
#'   \item{`loc`}{URL of uploaded and processed child data}
#'   \item{`child`}{Processed child level data}
#'   \item{`time`}{Processed time level data}
#'   \item{`chart`}{Growth chart figure (svglite)}
#'   \item{`screeners`}{Results from application of screeners to child data}
#'   \item{`site`}{URL with personalised child data}
#' }
#' @examples
#' fn <- system.file("extdata", "bds_v2.0", "smocc", "Laura_S.json", package = "jamesdemodata")
#' results <- request_blend(txt = fn)
#' @export
request_blend <- function(txt = "", loc = "", blend = "standard", ...) {
  authenticate(...)

  if (blend == "standard") {
    return(request_blend_standard(txt = txt, loc = loc, ...))
  }

  if (blend == "allegro") {
    return(request_blend_allegro(txt = txt, loc = loc, ...))
  }

  stop("blend", blend, "not found.")
}

request_blend_standard <- function(txt = "", loc = "", ...) {
  site <- request_site(txt, loc, ...)
  loc <- strsplit(site, "?loc=", fixed = TRUE)[[1]][2]
  if (is.na(loc)) loc <- ""
  tgt <- get_tgt(loc = loc)
  chart <- draw_chart(loc = loc, ...)
  screeners <- apply_screeners(loc = loc, ...)

  result <- list(
    txt = txt,
    loc = loc,
    site = site,
    child = attr(tgt, "person", exact = TRUE),
    time = tgt,
    chart = chart,
    screeners = screeners
  )
  return(result)
}

request_blend_allegro <- function(txt = "", loc = "", format = "1.0", ...) {
  site <- request_site(txt, loc, format = format)

  tgt <- get_tgt(txt, loc, format = format)

  res <- screen_curves_ind(tgt)

  last_dscore <- NULL
  if (!is.null(tgt)) {
    idx <- tgt$yname == "dsc"
    if (any(idx)) {
      d <- tgt$y[idx][sum(idx)]
      if (length(d) && !is.na(d)) last_dscore <- d
    }
  }

  # list of two elements if nu D-score, else 3 elements
  if (is.null(last_dscore)) {
    ret <- list(
      UrlGroeicurven = unbox(site),
      Resultaten = res
    )
  } else {
    ret <- list(
      UrlGroeicurven = unbox(site),
      Resultaten = res,
      LaatsteDscore = unbox(last_dscore)
    )
  }
  ret
}
