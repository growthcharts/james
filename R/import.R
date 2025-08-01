#' @import     svglite
#' @importFrom bdsreader       read_bds persondata timedata
#' @importFrom chartbox        list_charts
#' @importFrom chartcatalog    create_chartcode get_breakpoints
#'                             parse_chartcode
#' @importFrom chartplotter    process_chart
#' @importFrom curl            curl
#' @importFrom dplyr           %>% all_of filter mutate pull select
#' @importFrom grDevices       dev.off
#' @importFrom grid            grid.draw
#' @importFrom growthscreener  list_screeners screen_curves_ind
#' @importFrom httr            add_headers build_url content GET
#'                             headers message_for_status modify_url
#'                             parse_url POST status_code upload_file
#' @importFrom jamesclient     get_url james_post
#' @importFrom jsonlite        fromJSON minify toJSON unbox validate
#' @importFrom jose            jwt_decode_sig
#' @importFrom rlang           .data
#' @importFrom svglite         svgstring
#' @importFrom utils           hasName install.packages installed.packages
#'                             packageDate packageVersion
NULL

globalVariables(".val")
