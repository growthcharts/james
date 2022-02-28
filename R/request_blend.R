#' Provides multiple outputs in one request
#'
#' Function `request_blend()` acts as a one-stop-shop to obtain multiple
#' outputs through one request.
#' @inheritParams request_site
#' @param blend A string indicating the requested blend. The default (`"standard"`)
#' returns the results of the standard end points that produces tables. Graphs
#' are currently not supported.
#' @return The default `blend = "standard"` return a list with the following
#' components:
#' \describe{
#'   \item{`txt`}{String, file or URL with child data}
#'   \item{`session`}{Session with uploaded child data}
#'   \item{`child`}{Processed child level data}
#'   \item{`time`}{Processed time level data}
# #'   \item{`chart`}{SVG of growth chart}
#'   \item{`screeners`}{Results from application of screeners to child data}
#'   \item{`site`}{URL with personalised child data}
#' }
#' @examples
#' \dontrun{
#' fn <- system.file("extdata", "bds_v2.0", "smocc", "Laura_S.json", package = "jamesdemodata")
#' results <- request_blend(txt = fn)
#' }
#' @export
request_blend <- function(txt = "",
                          host = "",
                          session = "",
                          blend = "standard",
                          loc = "",
                          ...) {
  authenticate(...)

  if (!missing(loc)) {
    warning("Argument loc is deprecated and will disappear in Sept 2022; please use session instead.",
            call. = FALSE
    )
    session <- loc2session(loc)
  }

  if (blend == "standard") {
    return(request_blend_standard(txt = txt, host = host, session = session, ...))
  }

  if (blend == "allegro") {
    return(request_blend_allegro(txt = txt, host = host, session = session, ...))
  }

  stop("blend", blend, "not found.")
}

request_blend_standard <- function(txt, host, session, ...) {
  site <- request_site(txt = txt, host = host, session = session, ...)
  session <- strsplit(site, "?session=", fixed = TRUE)[[1]][2]
  if (is.na(session)) session <- ""
  tgt <- get_tgt(host = host, session = session)

  # render chart as svg
  #chart <- draw_chart(loc = loc, draw_grob = FALSE, ...)
  #sidecode <- substr(chart$name, 4L, 4L)
  #if (sidecode %in% c("A", "B", "C", "X")) {
  #  width <- 8.27
  #  height <- 11.69
  #} else {
  #  width <- 7.09
  #  height <- 7.09
  #}
  #s <- svglite::svgstring(width = width, height = height)
  #grid.draw(chart)
  #dev.off()

  screeners <- apply_screeners(host = host, session = session, ...)

  result <- list(
    txt = txt,
    session = session,
    site = site,
    child = persondata(tgt),
    time = timedata(tgt),
#    chart = s(),
    screeners = screeners
  )
  return(result)
}

request_blend_allegro <- function(txt, host, session, format = "1.0", ...) {
  site <- request_site(txt = txt, host = host, session = session, format = format, ...)
  session <- strsplit(site, "?session=", fixed = TRUE)[[1]][2]
  if (is.na(session)) session <- ""
  tgt <- get_tgt(host = host, session = session)

  res <- growthscreener::screen_curves_ind(ind = tgt)

  last_dscore <- NULL
  if (!is.null(tgt)) {
    time <- timedata(tgt)
    idx <- time$yname == "dsc"
    if (any(idx)) {
      d <- time$y[idx][sum(idx)]
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

