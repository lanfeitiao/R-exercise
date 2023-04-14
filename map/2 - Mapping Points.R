# Load library -----------------------------
library(nycflights13)

# Mapping points ----------------------------
# Transform the airport locations to an sf object by specifying the geo coordinates in the data frame
airports.sf <- st_as_sf(airports, coords = c("lon", "lat"),
                        crs = 4326)

# Load USA states boundaries from Natural Earth
united.states <- ne_states(country = "United States of America", returnclass = "sf")
# Filter out the the conterminous USA
usa.conterm <- filter(united.states, name != "Alaska", name != "Hawaii")
# Filter out the airports that fall in the conterminous US
airports.conterm <- st_join(airports.sf, usa.conterm, join = st_within, left = FALSE)

# Plot the airports on top of the state boundary data
ggplot(data = usa.conterm) +
  geom_sf() +
  geom_sf(data = airports.conterm) +
  coord_sf(crs = 'ESRI:102003') +
  theme_minimal()


# Color by timezone, and use an alternative shape
ggplot(data = usa.conterm) +
  geom_sf() +
  geom_sf(data = airports.conterm,
          aes(size = alt,
              color = tzone),
          alpha = 0.3,
          shape = 17) +
  scale_size_area(max_size = 10) +
  coord_sf(crs = 'ESRI:102003') +
  theme_minimal()

