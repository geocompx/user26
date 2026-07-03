# Solutions — 05 tmap
# Geocomputation with R, useR! 2026

library(sf)
library(tmap)
library(spData)
# 1
tm_shape(nz) + tm_polygons()
# 2
tm_shape(nz) +
	tm_polygons(fill = "Median_income",
				fill.scale = tm_scale(values = "viridis"),
				fill.legend = tm_legend(title = "Median income",
									position = tm_pos_out("left", "center")),
				lwd = 2)
# 3
tm_shape(nz) +
	tm_polygons(fill = "Median_income",
				fill.scale = tm_scale(values = "rainbow"),
				fill.legend = tm_legend(title = "Median income",
									position = tm_pos_out("left", "center")),
				lwd = 2)
# 4
tm4 = tm_shape(nz) +
	tm_polygons(fill = "Median_income",
				fill.scale = tm_scale(values = "viridis"),
				fill.legend = tm_legend(title = "Median income",
									position = tm_pos_out("left", "center")),
				lwd = 2) +
	tm_title("New Zealand") +
	tm_scalebar() +
	tm_compass(position = tm_pos_in("right", "top")) +
	tm_credits("Authors, 2025")
tm4
# 5
tmap_mode("view")
tm4
tmap_mode("plot")
tmap_save(tm4, "tm4.png")
tmap_save(tm4, "tm4.svg")
tmap_mode("view")
tmap_save(tm4, "tm4.html")