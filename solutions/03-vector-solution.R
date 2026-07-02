# Solutions — 02 Vector data with sf
# Geocomputation with R, useR! 2026

library(sf)
library(spData)
library(dplyr)

# ---------------------------------------------------------------------------
# Attribute operations
# ---------------------------------------------------------------------------

## 1. Regions of nz with Population > 200,000, highlighted
big <- nz |> filter(Population > 200000)
plot(st_geometry(nz))
plot(st_geometry(big), col = "red", add = TRUE)

## 2. Categorical population class
nz <- nz |>
  mutate(pop_class = case_when(
    Population < 100000 ~ "low",
    Population <= 300000 ~ "medium",
    TRUE ~ "high"
  ))
table(nz$pop_class)
plot(nz["pop_class"])

## 3. (Optional) build an sf object from two sfg points
p1 <- st_point(c(1, 1))
p2 <- st_point(c(2, 2))
pts_sf <- st_sf(
  id = 1:2,
  geometry = st_sfc(p1, p2, crs = 4326)
)
pts_sf

# ---------------------------------------------------------------------------
# Spatial attribute operations
# ---------------------------------------------------------------------------

canterbury <- nz |> filter(Name == "Canterbury")

## 1. Summits NOT intersecting Canterbury
outside <- nz_height[canterbury, , op = st_disjoint]
nrow(outside)
plot(st_geometry(nz))
plot(st_geometry(outside), col = "red", pch = 16, add = TRUE)

## 2. Spatial join of nz_height elevation onto nz
# One row per intersecting pair, so regions with several summits are duplicated
# and regions with none get NA -> more rows than nz has regions.
nz_joined <- st_join(nz, nz_height["elevation"])
nrow(nz) # regions
nrow(nz_joined) # region-summit pairs (+ NA rows)

# ---------------------------------------------------------------------------
# Geometric operations
# ---------------------------------------------------------------------------

## 1. Intersection and union of two circles
pts <- st_sfc(st_point(c(0, 1)), st_point(c(1, 1)))
circles <- st_buffer(pts, dist = 1)
x <- circles[1]
y <- circles[2]
plot(st_union(x, y), border = "grey")
plot(st_intersection(x, y), col = "lightblue", add = TRUE)

## 2. Average population per REGION
regions <- us_states |>
  group_by(REGION) |>
  summarise(mean_pop = mean(total_pop_15, na.rm = TRUE))
plot(regions["mean_pop"])

## 3. Reproject nz to EPSG:4326 and compare
nz_wgs <- st_transform(nz, crs = 4326)
par(mfrow = c(1, 2))
plot(st_geometry(nz), main = st_crs(nz)$Name)
plot(st_geometry(nz_wgs), main = "WGS 84")
par(mfrow = c(1, 1))
