# Plot rivers and coastline --------------------------------
# Download rivers and coastline line data from Natural Earth
rivers <- ne_download(scale = 10, type = "rivers_lake_centerlines", category = "physical", returnclass = "sf")
coastline <- ne_download(scale = 10, type = "coastline", category = "physical", returnclass = "sf")

# Plot a map with global rivers and coastlines, in the Mollweide CRS
ggplot() +
  geom_sf(data = coastline, color = "#dddddd") +
  geom_sf(data = rivers, color = "#146bcc") +
  coord_sf(crs = 'ESRI:54009') +
  theme_minimal() +
  theme(panel.grid = element_blank())

# Plot fight routes from JFK Airport ------------------------------
# Filter out the flights from JFK from the flight data 
flights.jfk <- filter(flights, origin == "JFK")
# Count the number of flights on each origin-destination route, and give each route an id
flights.jfk.counted <- group_by(flights.jfk, origin, dest) %>%
  summarise(total = n()) %>%
  mutate(id = paste(origin, "-", dest, sep=""))
# Convert to long data
flights.jfk.long <- pivot_longer(flights.jfk.counted, 
                                 cols = 1:2, 
                                 names_to = "orgdest", 
                                 values_to = "airport")
# Join airports data
flights.jfk.long <- left_join(flights.jfk.long, airports, by = c("airport" = "faa"))
# Filter out the airports with missing data, and remove Honolulu (it is the only non-conterminous airport in the data)
flights.jfk.long <- filter(flights.jfk.long, !(id %in% c("JFK-STT", "JFK-SJU", "JFK-PSE", "JFK-BQN", "JFK-HNL")))





