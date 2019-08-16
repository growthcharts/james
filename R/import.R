#' @importFrom chartbox        list_charts
#' @importFrom chartcatalog    create_chartcode get_breakpoints
#'                             parse_chartcode
#' @importFrom chartplotter    process_chart
#' @importFrom curl            curl
#' @importFrom growthscreener  screen_curves_ind
#' @importFrom jamesclient     upload_bds get_url
#' @importFrom jsonlite        toJSON unbox
#' @importFrom methods         new slot
#' @importFrom minihealth      convert_bds_individual
#'                             get_range
#' @importClassesFrom minihealth individual xyz bse
NULL

globalVariables(".val")
