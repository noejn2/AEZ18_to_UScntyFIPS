rm(list = ls())

# Script creates low resolution maps
library(rgdal)
library(tidyverse)

USmap_AEZ18_df <- readRDS('output/USmap_AEZ18_df.rds')
USmap_cnty_df <- readRDS('output/USmap_cnty_df.rds')
USmap_st_df <- readRDS('output/USmap_st_df.rds')

png(file = "output/low_figs/AEZ_in_states.png",
    width = 768,
    height = 458.88,
    units = "px")
ggplot() +
  geom_polygon(data = USmap_AEZ18_df,
               aes(x = long,
                   y = lat,
                   group = group),
               fill = NA,
               color = "grey",
               size = .1) +
  geom_polygon(data = USmap_st_df,
               aes(x = long,
                   y = lat,
                   group = group),
               fill = NA,
               color = "black",
               size = .05)
dev.off()

png(file = "output/low_figs/counties_in_states.png",
    width = 768,
    height = 458.88,
    units = "px")
ggplot() +
  geom_polygon(data = USmap_cnty_df,
               aes(x = long,
                   y = lat,
                   group = group),
               fill = NA,
               color = "grey",
               size = .1) +
  geom_polygon(data = USmap_st_df,
               aes(x = long,
                   y = lat,
                   group = group),
               fill = NA,
               color = "black",
               size = .05)
dev.off()

png(file = "output/low_figs/cnties_in_AEZ.png",
    width = 768,
    height = 458.88,
    units = "px")
ggplot() +
  geom_polygon(data = USmap_cnty_df,
               aes(x = long,
                   y = lat,
                   group = group),
               fill = NA,
               color = "grey",
               size = .1) +
  geom_polygon(data = USmap_AEZ18_df,
               aes(x = long,
                   y = lat,
                   group = group),
               fill = NA,
               color = "black",
               size = .05)
dev.off()

USmap_cnty_df_final <- USmap_cnty_df

png(file = "output/low_figs/cnties_in_AEZ_final.png",
    width = 768,
    height = 458.88,
    units = "px")
ggplot() +
  geom_polygon(data = USmap_cnty_df_final,
               aes(x = long,
                   y = lat,
                   group = group,
                   fill = aez),
               color = "grey",
               size = .1)
dev.off()

