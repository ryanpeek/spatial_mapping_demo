# libraries we want to use for spatial mapping


suppressPackageStartupMessages({
  library(sf);
  library(USAboundaries);
  library(maps);
  library(rgdal);
  library(maptools);
  library(mapview);
  library(leaflet);
  library(tmap)
})
  



# Potential Data:
# https://geodacenter.github.io/data-and-lab/

# Suisun: http://solano-doitgis.opendata.arcgis.com/datasets?q=*&sort_by=updated_at

# Suisun Flood Zones (shp)
# http://solano-doitgis.opendata.arcgis.com/datasets/325e54dd69de4225a4ae310d071786ef_0.zip