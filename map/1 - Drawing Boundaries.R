# Load libraries -------------------------------
library(dplyr)
library(tidyr)
library(ggplot2)
library(rnaturalearth)
library(sf)

# Boundaries -------------------------------------

world <- ne_countries(returnclass = "sf")

# get sense of the data 
plot(world, max.plot = 2)
plot(select(world, admin))

# map boundaries with ggplot2
map <- ggplot(world) +
  geom_sf() + 
  theme_minimal()
# plot a single country 
map %+% filter(world, admin == "United States of America")
map %+% filter(world, admin == "Belize")

# what if you want more detailed data to show small countries 
# option 1 - Load the high resolution (1:10 million scale) boundary data 
# from Natural Earth with the ne_download() function from the rnaturalearth package
world.hires <- ne_download(scale = 10, type = "countries", category = "cultural", returnclass = "sf")
# option 2 - Download the data and then load it from your hard drive 
# world.hires <- read_sf('map/data/natural_earth/ne_10m_admin_0_countries/ne_10m_admin_0_countries.shp')

belize.hires <- filter(world.hires, ADMIN == "Belize")
map %+% belize.hires

# plot subnational level boundaries 
world.admin1 <- ne_download(scale = 10, type = "states", category = "cultural", returnclass = "sf")
united.states <- filter(world.admin1, admin == "United States of America")
map %+% united.states


# Projection -------------------------------------

# Get the coordinate reference system of a sf object with st_crs()
st_crs(world)

## Set the projection of a ggplot2 map with coord_sf()
# Robinson
map %+% world +
  coord_sf(crs = 'ESRI:54030')

# Filter out European countries
europe <- filter(world, continent == "Europe")
map %+% europe + 
  coord_sf(default_crs = NULL)


# Set the map extent with xlim and ylim
map %+% europe +
  coord_sf(xlim = c(-10,40), ylim = c(30,80))
# Europe in the ETRS89 Lambert Azimuthal Equal-Area projection crs
map %+% europe +
  coord_sf(xlim = c(2500000, 6000000), ylim =c(1150000, 5500000), 
           crs = 3035)
# Conterminous USA in the USA Contiguous Albers Equal Area Conic CRS (EPSG 102003)
map %+% united.states + coord_sf(crs = 102003)













