# Build maps step by step

# Step 1: base R plot of a data frame with coordinates
waterfalls = data.frame(
  name = c("Iguazu Falls", "Niagara Falls", "Victoria Falls"),
  lat = c(-25.686785, 43.092461, -17.931805),
  lon = c(-54.444981, -79.047150, 25.825558)
)

plot(
  waterfalls$lon,
  waterfalls$lat,
  xlab = "Longitude",
  ylab = "Latitude",
  asp = 1
)

# Step 2: spatial visualization with sf
library(sf)
waterfalls_sf = st_as_sf(waterfalls, coords = c("lon", "lat"), crs = "EPSG:4326")
plot(waterfalls_sf)

# Step 3: basic tmap visualization
library(tmap)
tm_shape(waterfalls_sf) +
  tm_symbols()

# Step 4: add context (world map)
library(spData)
data("world", package = "spData")

# Optional: compare base plots to tmap
plot(world)
plot(st_geometry(world))

tm_world = tm_shape(world) + tm_polygons()
tm_world

tm_world +
  tm_shape(waterfalls_sf) +
  tm_symbols()

tm_world +
  tm_shape(waterfalls_sf) +
  tm_symbols(fill = "name")

# Step 5: improve projection

tm_world +
  tm_crs("auto")

tm_world +
  tm_shape(waterfalls_sf) +
  tm_symbols(fill = "name") +
  tm_crs("auto")

# Step 6: style points and legend

tm1 = tm_world +
  tm_shape(waterfalls_sf) +
  tm_symbols(
    fill = "name",
    fill.scale = tm_scale(values = c("steelblue", "darkorchid", "forestgreen")),
    fill.legend = tm_legend(
      title = "",
      position = c("left", "bottom"),
      bg.color = "grey95"
    )
  ) +
  tm_crs("auto")

tm1

# Step 7: improve layout
tm2 = tm1 +
  tm_graticules() +
  tm_layout(
    earth_boundary = TRUE,
    frame = FALSE,
    bg.color = "lightblue",
    space.color = "white"
  )

tm2

# Optional: save output (writes a file)
tmap_save(tm2, "waterfalls.png", width = 2400, height = 1200)

## EXAMPLE 2 ---------------------------------------------------------------
# Step 1: join attributes
library(dplyr)
data("us_states", "us_states_df", package = "spData")
us_states = left_join(us_states, us_states_df, by = c("NAME" = "state"))

tm_us = tm_shape(us_states)

tm_us +
  tm_polygons(fill = "median_income_15")

# Step 2: add projection and title

tm_us +
  tm_polygons(
    fill = "median_income_15",
    fill.legend = tm_legend(title = "", position = c("left", "bottom"))
  ) +
  tm_crs("auto") +
  tm_title("Median Income in 2015 (USD)")

# Step 3: update the color scale
med_inc15 = median(us_states$median_income_15, na.rm = TRUE)

tm_us +
  tm_polygons(
    fill = "median_income_15",
    fill.scale = tm_scale_continuous(midpoint = med_inc15),
    fill.legend = tm_legend(title = "", position = c("left", "bottom"))
  ) +
  tm_crs("auto") +
  tm_title("Median Income in 2015 (USD)")

tm_us1 = tm_us +
  tm_polygons(
    fill = "median_income_15",
    fill.scale = tm_scale_continuous(midpoint = med_inc15),
    fill.legend = tm_legend(
      title = "",
      orientation = "landscape",
      frame = FALSE,
      width = 60,
      position = tm_pos_out("center", "bottom", "center")
    )
  ) +
  tm_crs("auto") +
  tm_title("Median Income in 2015 (USD)")

tm_us1

# Optional: interactive preview (remember to reset)
tmap_mode("view")
tm_us1
tmap_mode("plot")

# Step 4: add more map elements

tm_us2 = tm_us1 +
  tm_text(
    "NAME",
    size = "AREA",
    size.scale = tm_scale_continuous(values.scale = 1.3),
    size.legend = tm_legend(show = FALSE)
  ) +
  tm_scalebar(position = c("left", "bottom")) +
  # tm_compass() +
  # Optional: local logo file if available
  # tm_logo("figs/Rlogo.png", height = 2) +
  tm_credits("Source: US Census Bureau", position = c("left", "bottom"))

tm_us2
