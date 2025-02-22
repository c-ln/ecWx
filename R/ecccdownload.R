#' Download Environment Canada Historical Climate Data
#'
#' This function downloads climate data from Environment and Climate Change Canada for a given station ID, date range, and timeframe.
#' 
#' @param stationID A numeric or character value representing the station ID.
#' @param start_date A string representing the start date in "YYYY-MM-DD" format.
#' @param end_date A string representing the end date in "YYYY-MM-DD" format.
#' @param timeframe A numeric value (1 = daily, 2 = hourly, 3 = monthly).
#'
#' @return A data frame containing the filtered climate data for the specified date range and timeframe.
#' @export
ecccdownload <- function(stationID, start_date, end_date, timeframe) {
  
  # Extract start and end year from dates
  start_year <- format(as.Date(start_date, format="%Y-%m-%d"), "%Y")
  end_year <- format(as.Date(end_date, format="%Y-%m-%d"), "%Y")
  
  # Create a list of years between the start and end year
  listofyears <- seq(start_year, end_year, 1)
  
  # Create an empty list to store data for each year
  yearly_data <- list()
  
  # Loop to download data for each year
  for (i in 1:length(listofyears)) {
    year <- listofyears[i]
    myurl <- paste(
      "http://climate.weather.gc.ca/climate_data/bulk_data_e.html?format=csv&stationID=",
      stationID,
      "&Year=", year,
      "&Month=1&Day=1&timeframe=", timeframe,
      sep = ""
    )
    yearly_data[[i]] <- read.csv(myurl)  # Read CSV data and store it in the list
  }
  
  # Combine list of yearly data into a single data frame
  combined_data <- do.call(rbind, yearly_data)
  
  # Filter data based on timeframe
  if (timeframe == 1) {
    filtered_data <- dplyr::filter(combined_data, Date.Time..LST. >= start_date & Date.Time..LST. <= end_date)
    return(filtered_data)
    
  } else if (timeframe == 2) {
    filtered_data <- dplyr::filter(combined_data, Date.Time >= start_date & Date.Time <= end_date)
    return(filtered_data)
    
  } else if (timeframe == 3) {
    message("Monthly data download not yet programmed")
    
  } else {
    stop("Timeframe not recognized")
  }
}