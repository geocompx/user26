library(sf)
library(spData)

data("nz", package = "spData")

st_crs(nz)
st_is_longlat(nz)

nz_4326 <- st_transform(nz, 4326)

par(mfrow = c(1, 2), mar = c(0, 0, 2, 0))
plot(st_geometry(nz), main = "Original CRS")
plot(st_geometry(nz_4326), main = "EPSG:4326")
