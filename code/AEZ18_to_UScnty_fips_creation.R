rm(list = ls())

# Script identifies U.S. counties that belong to each of the 11 AEZ within the U.S.
# by using countries' centroid location 

library(tidyverse)
library(rgdal)
library(rgeos)

USmap_cnty <- readOGR(dsn = 'assets/3109_county',
                      layer = 'USmap_county')

USmap_AEZ18 <- readOGR(dsn = 'output/USmap_AEZ18',
                       layer = 'USmap_AEZ18')

# Creating output data frame
USdf_cnty <- USmap_cnty@data 
USdf_cnty <- USdf_cnty %>%
  transmute(fips = as.character(as.numeric(ANSI_ST_CO)))
USdf_cnty$id <- as.character(0:(length(USdf_cnty$fips)-1))

# Creating and identifying points
USpnts_cnty <- gCentroid(USmap_cnty, byid = TRUE)
#plot(USpnts_cnty)
USpnts_cnty <- sp::over(USpnts_cnty, USmap_AEZ18)
USpnts_cnty$id <- as.character(0:(length(USpnts_cnty$fid)-1))

# Merging
USdf_cnty <- left_join(USdf_cnty, USpnts_cnty, by = "id")

#Saving
write_csv(USdf_cnty, file = 'output/AEZ18_to_UScnty_fips.csv')
saveRDS(USdf_cnty, file = 'output/AEZ18_to_UScnty_fips.rds')
