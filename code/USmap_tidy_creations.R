rm(list = ls())

# Script creates tidy dfs to create the ggplot maps

library(tidyverse)
library(rgdal)

# The shapefiles

USmap_cnty <- readOGR(dsn = 'assets/3109_county',
                      layer = 'USmap_county')

USmap_st <- readOGR(dsn = 'assets/49_state',
                    layer = 'USmap_state')

USmap_AEZ18 <- readOGR(dsn = 'output/USmap_AEZ18',
                    layer = 'USmap_AEZ18')

# Creating and saving the tidy files
# Counties
USmap_cnty@data
USmap_cnty@data$id <- as.character(0:(length(USmap_cnty@data$ANSI_ST_CO) - 1))
USmap_cnty@data <- USmap_cnty@data %>%
  select(id, ANSI_ST_CO) %>%
  rename(fips = ANSI_ST_CO) %>%
  mutate(fips = as.character(as.numeric(fips)))

AEZ18_to_UScnty_fips <- readRDS(file = 'output/AEZ18_to_UScnty_fips.rds')
AEZ18_to_UScnty_fips <- AEZ18_to_UScnty_fips %>%
  select(fips, aez) %>%
  mutate(fips = as.character(fips))

USmap_cnty@data <- left_join(AEZ18_to_UScnty_fips,
                             USmap_cnty@data,
                             by = 'fips')

USmap_cnty_df <- broom::tidy(USmap_cnty)
USmap_cnty_df <- left_join(USmap_cnty_df,
                           USmap_cnty@data,
                           by = "id")
saveRDS(USmap_cnty_df, file = 'output/USmap_cnty_df.rds')

#State
USmap_st@data <- USmap_st@data %>%
  select(STUSPS) %>%
  rename(st_ini = STUSPS)

USmap_st@data$id <- as.character(0:(length(USmap_st@data$st_ini) - 1))

USmap_st_df <- broom::tidy(USmap_st)
USmap_st_df <- left_join(USmap_st_df,
                         USmap_st@data,
                         by = "id")
saveRDS(USmap_st_df, file = 'output/USmap_st_df.rds')

#AEZ18
USmap_AEZ18@data <- USmap_AEZ18@data %>%
  select(aez) 
  
USmap_AEZ18@data$id <- as.character(0:(length(USmap_AEZ18@data$aez) - 1))

USmap_AEZ18_df <- broom::tidy(USmap_AEZ18)
USmap_AEZ18_df <- left_join(USmap_AEZ18_df,
                            USmap_AEZ18@data,
                            by = "id")
saveRDS(USmap_AEZ18_df, file = 'output/USmap_AEZ18_df.rds')
#end
