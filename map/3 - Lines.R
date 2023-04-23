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
# Convert to sf
destinations.jfk.sf <- st_as_sf(flights.jfk.long, coords = c("lon", "lat"))
# Group and summarise to combine the points of each origin-destination pair. Keep the total number of flights on each route by taking the mean (the origin and destination of each route have the same number for this)
destinations.jfk.sf.grouped <- group_by(destinations.jfk.sf, id) %>%
  summarise(total = mean(total))
# Convert the MULTIPOINT to LINESTRING
destinations.sf.lines <- st_cast(destinations.jfk.sf.grouped, "LINESTRING")
# Set the CRS
st_crs(destinations.sf.lines) <- 4326
# Load state boundaries
united.states <- ne_states(country = "United States of America", returnclass = "sf")
# Filter out the the conterminous USA
usa.conterm <- filter(united.states, name != "Alaska", name != "Hawaii")

# Plot the routes map
ggplot(data = usa.conterm) +
  geom_sf(color = "#ffffff") +
  geom_sf(data = destinations.sf.lines, color = alpha("#D81E90",0.3), aes(linewidth = total)) +
  coord_sf(crs = 'ESRI:102003') +
  theme_minimal()
