#' @import     donordata
#' @importFrom chartbox        list_charts
#' @importFrom chartcatalog    create_chartcode parse_chartcode
#' @importFrom chartplotter    process_chart
#' @importFrom curl            curl
#' @importFrom jsonlite        fromJSON
#' @importFrom lubridate       ymd dmy
#' @importFrom methods         new slot
#' @importFrom minihealth      get_range
#' @importClassesFrom minihealth individual xyz bse
NULL

globalVariables(".val")
