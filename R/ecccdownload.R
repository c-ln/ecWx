#' Download Environment Canada Historical Climate Data
#'
#' This function downloads climate data from Environment and Climate Change Canada for a given station ID, date range, and timeframe.
#'
#' @param stationid A numeric or character value representing the station ID.
#' @param startdate A string representing the start date in "YYYY-MM-DD" format.
#' @param enddate A string representing the end date in "YYYY-MM-DD" format.
#' @param timeframe A numeric value (1 = daily, 2 = hourly, 3 = monthly).
#'
#' @return A data frame containing the filtered climate data for the specified date range and timeframe.
#' @export
ecccdownload <- function(stationid, startdate, enddate, timeframe) {

  # Extract start and end year from dates
  startyear <- format(as.Date(startdate, format="%Y-%m-%d"), "%Y")
  endyear <- format(as.Date(enddate, format="%Y-%m-%d"), "%Y")
  startmonth <- format(as.Date(startdate, format="%Y-%m-%d"), "%m")
  endmonth <- format(as.Date(enddate, format="%Y-%m-%d"), "%m")

  # handle data differently based on timeframe
  if (timeframe == 1) {

    # Create a list of years between the start and end year
    listofyears <- seq(startyear, endyear, 1)
    listofmonths <- seq(1, 12)

    # Create an empty list to store data for each year
    df_list <- list()
    counter <- 1  # Counter for unique indexing

    # Loop to download data for each year
    for (i in 1:length(listofyears))  {
    for (k in 1:length(listofmonths)) {
      year <- listofyears[i]
      month <- listofmonths[k]
      myurl <- paste(
        "http://climate.weather.gc.ca/climate_data/bulk_data_e.html?format=csv&stationID=",
        stationid,
        "&Year=", year,
        "&Month=", month,
        "&Day=1&timeframe=", timeframe,
        sep = ""
      )
      df_list[[counter]] <- read.csv(myurl) # Read CSV data for each month and year and store it in the list
      counter <- counter + 1  # Increment counter
    }
    }

    # Combine list of yearly data into a single data frame
    df1 <- do.call(rbind, df_list)

    # filter based on start and end date
    df2 <- dplyr::filter(df1, as.Date(Date.Time..LST.) >= startdate & as.Date(Date.Time..LST.) <= enddate)
    return(df2)

  } else if (timeframe == 2) {

    # Create a list of years between the start and end year
    listofyears <- seq(startyear, endyear, 1)

    # Create an empty list to store data for each year
    yearlydata <- list()

    # Loop to download data for each year
    for (i in 1:length(listofyears)) {
      year <- listofyears[i]
      myurl <- paste(
        "http://climate.weather.gc.ca/climate_data/bulk_data_e.html?format=csv&stationID=",
        stationid,
        "&Year=", year,
        "&Month=1&Day=1&timeframe=", timeframe,
        sep = ""
      )
      yearlydata[[i]] <- read.csv(myurl)  # Read CSV data and store it in the list
    }

    # Combine list of yearly data into a single data frame
    df1 <- do.call(rbind, yearlydata)

    # filter based on start and end date
    df2 <- dplyr::filter(df1, Date.Time >= startdate & Date.Time <= enddate)
    return(df2)

  } else if (timeframe == 3) {
    myurl <- paste(
      "http://climate.weather.gc.ca/climate_data/bulk_data_e.html?format=csv&stationID=",
      stationid,
      "&Year=1900&Month=1&Day=1&timeframe=", timeframe,
      sep = ""
    )
    df1 <- read.csv(myurl)

    # filter based on start and end year and month
    # end date filterinf doesn't work if month = 12, because there are no months greater than 12
    # start date filtering doesn't work if month = 1, because there are no months less than one
    df2 <- df1 %>%
            dplyr::filter(!(Year < startyear)) %>% # filter out years less than start year
            dplyr::filter(!(Year == startyear & Month < as.numeric(startmonth))) %>% # filter out months
            dplyr::filter(!(Year > endyear)) %>% # filter years greater than end year
            dplyr::filter(!(Year >= endyear & Month > as.numeric(endmonth))) # filter out months
    return(df2)
  } else {
    stop("Timeframe not recognized")
  }
}
