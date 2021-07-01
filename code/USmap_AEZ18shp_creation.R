rm(list = ls())

# Script creates continental U.S. with the AEZ18 boundaries

library(tidyverse)
library(rgdal)

# Shapefile with all of the AEZ regions in the world
AEZ_map <- readOGR(dsn = 'assets/GTAPAEZ_v10',
                   layer = 'GTAPv10_aez')

# Dissolving all of the state boundaries from US states shapefile
USmap_st <- readOGR(dsn = 'assets/49_state',
                    layer = 'USmap_state')
USmap_st <- aggregate(USmap_st, dissolve = TRUE)

# Intersecting USmap_st with AEZ_regions (countries) to create
# a shapefile that keeps lakes within the continental U.S.
AEZ_map_reg <- readOGR(dsn = 'assets/GTAPAEZ_v10',
                       layer = 'GTAPv10_reg')
AEZ_map_reg <- AEZ_map_reg[AEZ_map_reg$GTAP == "USA",]

USmap_lakes <- raster::intersect(USmap_st, AEZ_map_reg)
#tmap::qtm(USmap_lakes)

out_dir_lakes <-'output/USmap_lakes'
dir.create(path = out_dir_lakes,
           showWarnings = TRUE)
if(!file.exists('output/USmap_lakes/USmap_lakes.shp')) {
  writeOGR(USmap_lakes, 
           dsn = out_dir_lakes,
           layer = 'USmap_lakes',
           driver = 'ESRI Shapefile')
}

# Intersecting USmap_st with AEZ18 to create
# a shapefile that keeps lakes within the continental U.S.
# but also shows the AEZ18 within the U.S.
USmap_AEZ18 <- raster::intersect(USmap_st, AEZ_map)
tmap::qtm(USmap_AEZ18)

out_dir <-'output/USmap_AEZ18'
dir.create(path = out_dir,
           showWarnings = TRUE)
if(!file.exists('output/USmap_AEZ18/USmap_AEZ18.shp')) {
  writeOGR(USmap_AEZ18, 
           dsn = out_dir,
           layer = 'USmap_AEZ18',
           driver = 'ESRI Shapefile')
}
# end