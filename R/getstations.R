#' Get Environment Canada Historical Climate Station Inventory
#'
#' This function retrieves and filters the station inventory from Environment and Climate Change Canada based on the provided parameters.
#' 
#' @param province A string representing the province. Default is NULL.
#' @param name A string to search for in the station names. Default is NULL.
#' @param climateid A numeric value representing the Climate ID. Default is NULL.
#' @param stationid A numeric value representing the Station ID. Default is NULL.
#' @param timeframe A string specifying the timeframe: "hourly", "daily", or "monthly". Default is NULL.
#' @param year A numeric value representing the year to filter by. Default is NULL.
#'
#' @return A data frame containing the filtered station inventory.
#' @export
getstations <- function(province = NULL, name = NULL, climateid = NULL, stationid = NULL, 
                        timeframe = NULL, year = NULL) {
  
  # Download data
  stationinventory <- read.csv("https://collaboration.cmc.ec.gc.ca/cmc/climate/Get_More_Data_Plus_de_donnees/Station%20Inventory%20EN.csv", 
                               skip = 3)
  
  # Apply filters if parameters are provided
  if (!is.null(province)) {
    stationinventory <- dplyr::filter(stationinventory, Province == province)
  }
  
  if (!is.null(name)) {
    stationinventory <- dplyr::filter(stationinventory, grepl(name, Name, ignore.case = TRUE))
  }
  
  if (!is.null(climateid)) {
    stationinventory <- dplyr::filter(stationinventory, Climate.ID == climateid)
  }
  
  if (!is.null(stationid)) {
    stationinventory <- dplyr::filter(stationinventory, Station.ID == stationid)
  }
  
  # Filter by timeframe
  if (!is.null(timeframe)) {
    if (timeframe == "hourly") {
      stationinventory <- dplyr::filter(stationinventory, !is.na(HLY.First.Year))
    } else if (timeframe == "daily") {
      stationinventory <- dplyr::filter(stationinventory, !is.na(DLY.First.Year))
    } else if (timeframe == "monthly") {
      stationinventory <- dplyr::filter(stationinventory, !is.na(MLY.First.Year))
    }
  }
  
  # Filter by year availability
  if (!is.null(year)) {
    stationinventory <- dplyr::filter(stationinventory, year >= First.Year & year <= Last.Year)
  }
  
  return(stationinventory)
}