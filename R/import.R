#' @import     clopus
#' @importFrom chartbox        list_charts
#' @importFrom chartcatalog    create_chartcode get_breakpoints
#'                             parse_chartcode
#' @importFrom chartplotter    process_chart
#' @importFrom curl            curl
#' @importFrom grid            grid.draw
#' @importFrom growthscreener  screen_curves_ind
#' @importFrom httr            add_headers build_url content GET
#'                             headers message_for_status modify_url POST
#'                             status_code upload_file
#' @importFrom jamesclient     get_url upload_txt
#' @importFrom jsonlite        fromJSON minify toJSON unbox validate
#' @importFrom methods         new slot
#' @importFrom minihealth      convert_bds_individual is.individual
#'                             get_range verify
#' @importClassesFrom minihealth individual xyz bse
NULL

globalVariables(".val")
