#' @importFrom chartbox        list_charts
#' @importFrom chartcatalog    create_chartcode get_breakpoints
#'                             parse_chartcode
#' @importFrom chartplotter    process_chart
#' @importFrom curl            curl
#' @importFrom grid            grid.draw
#' @importFrom growthscreener  screen_curves_ind
#' @importFrom httr            add_headers build_url content GET
#'                             modify_url POST
#'                             upload_file
#' @importFrom jamesclient     get_url
#' @importFrom jsonlite        fromJSON toJSON unbox validate
#' @importFrom methods         new slot
#' @importFrom minihealth      convert_bds_individual
#'                             get_range verify
#' @importClassesFrom minihealth individual xyz bse
NULL

globalVariables(".val")
