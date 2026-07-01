# Solutions — 03 Raster data with terra
# Geocomputation with R, useR! 2026

library(terra)
library(spData)

# a small elevation raster of Luxembourg (shipped with terra)
dem = rast(system.file("ex/elev.tif", package = "terra"))

# ---------------------------------------------------------------------------
# Raster attribute operations
# ---------------------------------------------------------------------------

## 1. Elevation values of the 10th row
row10 = dem[10, ]
head(row10)

## 2. Extract dem values at 10 random coordinates
set.seed(1)
samp = spatSample(dem, size = 10, xy = TRUE)
samp

## 3. Global summary statistics
global(dem, fun = "mean")
global(dem, fun = "min")
global(dem, fun = "max")

# ---------------------------------------------------------------------------
# Geometric operations
# ---------------------------------------------------------------------------

## 1. Decrease resolution by a factor of 5
dem_agg = aggregate(dem, fact = 5, fun = "mean")
plot(dem_agg)

## 2. Reproject dem to LAEA Europe and compare
dem_laea = project(dem, "EPSG:3035")
par(mfrow = c(1, 2))
plot(dem, main = "WGS 84")
plot(dem_laea, main = "LAEA Europe")
par(mfrow = c(1, 1))

## 3. Crop vs mask
elev_lux = rast(system.file("ex/elev.tif", package = "terra"))
lux = vect(system.file("ex/lux.shp", package = "terra"))
grev = lux[lux$NAME_1 == "Grevenmacher", ]

elev_crop = crop(elev_lux, grev)          # cuts to the bounding box (extent)
elev_mask = mask(elev_crop, grev)         # sets cells outside the polygon to NA

par(mfrow = c(1, 2))
plot(elev_crop, main = "crop (extent)"); plot(grev, add = TRUE)
plot(elev_mask, main = "mask (polygon)"); plot(grev, add = TRUE)
par(mfrow = c(1, 1))

# crop() reduces a raster to the rectangular extent of another object;
# mask() keeps the extent but sets cells outside the mask geometry to NA.
