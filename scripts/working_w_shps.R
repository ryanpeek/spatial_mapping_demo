# reading in and writing shapes
library(sf)
library(sharpshootR)  # CDEC.snow.courses, CDECquery, CDECsnowQuery
library(dplyr)
library(viridis)

# GET DATA
data(CDEC.snow.courses)

# Make into a dataframe
snw<-CDEC.snow.courses
snw$course_number <- as.factor(snw$course_number)
snw$longitude<-as.numeric(snw$longitude)*-1 # fix longitude, must be negative for northern hemisphere

# rename col:
snw <- snw %>% rename(apr1avg_in=april.1.Avg.inches)

# summary of data:
summary(snw)
dim(snw)

snw_sf <- st_as_sf(snw, 
                   coords = c(6, 5), # can use numbers here too
                   remove = F, # don't remove these lat/lon cols from df
                   crs = 4326) # add projection

# plain sf map
plot(st_coordinates(snw_sf), pch=21, bg=snw_sf$elev_feet)

# write shapefile
st_write(snw_sf, "data/shps/cdec_snow_stations.shp")


# get sf from url:
download.file("https://github.com/ryanpeek/spatial_mapping_demo/blob/master/data/shps/cdec_snow_stations.zip?raw=true", destfile = "data/cdec_snow_stations.zip")


library(USAboundaries)

counties_spec <- us_counties(resolution = "low", states="CA") %>% 
  filter(name=="Tulare")

snw_crop <- st_intersection(snw_sf, counties_spec) 

mapview::mapview(snw_crop)

# plot ggmap version:
library(ggmap) # need this package

# get range of points
mapRange1 <- c(range(st_coordinates(snw_sf)[,1]),
               range(st_coordinates(snw_sf)[,2]))

# set the background map: black and white terrain
map1 <- get_map(location=c(-120.5, 39), crop = F,
                color="bw",
                maptype="terrain",
                source="google",
                zoom=6)

ggmap(map1) + geom_sf(data=snw_crop, aes(color=apr1avg_in), alpha=0.8, size=3, inherit.aes = FALSE)+
  scale_color_viridis(option="A", direction = -1)+
  geom_sf(data=counties_spec, fill = NA, show.legend = F, color="gray50", lwd=0.4, inherit.aes = FALSE) +
  coord_sf(crs = 4326, xlim = mapRange1[c(1:2)], ylim = mapRange1[c(3:4)]) +
  labs(x="Longitude (WGS84)", y="Latitude",
       title="Snow Stations of CA") + 
  theme_bw(base_family = "Roboto Condensed")





#lake_pts <- st_read("data/shps/hydrolakes_ca.shp")

#lakes <- st_read("data/shps/lakes_CA_OR_hydroshed.shp")

#mapview::mapview(lakes) + mapview::mapview(lakes_crop_ca)

# WORKING WITH INCOME-DIVERSITY DATA --------------------------------------

inc_div <- st_read("data/shps/Income_diversity.shp")

# crop to CA

library(USAboundaries)

ca <- us_states(resolution = "low", states="CA")
ca_counties <- us_counties(resolution = "low", states="CA")

plot(st_geometry(ca_counties), col="gray80")
plot(st_geometry(ca), border="purple3", lwd=2, add=T)

# ok now crop
inc_ca <- st_intersection(inc_div, ca)

plot(st_geometry(inc_ca), col=inc_ca$le_racea_1)


