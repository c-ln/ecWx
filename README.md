# ecWx: Download Historical Weather Data from Environment Canada

**ecWx** is an R package that allows users to download historical climate data from Environment Canada's climate data portal. It provides functions for accessing station metadata and downloading climate data for specified timeframes.

## Installation

You can install the `ecWx` package directly from GitHub using `devtools`:

```r
# Install devtools if you haven't already
install.packages("devtools")

# Install ecWx from GitHub
devtools::install_github("c-ln/ecWx")

## Functions

### getstations()
This function allows you to download station inventory data from Environment Canada's climate station database. The station inventory can be optionally filtered based on several criteria, such as province, station name, or climate ID. If filters are not specified, all stations are returned. This function can be used to select stations for analysis and to determine the station ID, which is required for the ecccdownload() function.

Arguments:
province: Optional. The province of interest.
name: Optional. The station name (or partial name).
climateid: Optional. The climate ID of the station.
stationid: Optional. The specific station ID.
timeframe: Optional. The desired timeframe (e.g., "hourly", "daily", "monthly").
year: Optional. Filter stations based on the availability of data for a specific year.

Example usage:

```r
# get all stations
allstations <- getstations()

# get stations in Ontario with daily data available for 2020
somestations <- getstations(province = "Ontario", timeframe = "daily", year = "2020) 

###ecccdownload()
This function allows you to download historical weather data from Environment Canada based on a station ID and date range you specify. The function currently supports downloading hourly and daily data; monthly data handling is not yet implemented.

Arguments:
stationID: The station ID for which data is being requested.
start_date: The start date of the data you wish to download (format: "YYYY-MM-DD").
end_date: The end date of the data you wish to download (format: "YYYY-MM-DD").
timeframe: The desired time frame for the data (1 = hourly, 2 = daily. 3 = monthly not yet available).

Example Usage:
```r
# get daily data for ROSEVILLE climate station for 2015
data <- ecccdownload(stationID = "4816", start_date = "2015-01-01", end_date = "2015-12-31", timeframe = 2)