library(spData)
library(sf)
library(tmap)
library(dplyr)

data("us_states", "us_states_df", package = "spData")
us_states = left_join(us_states, us_states_df, by = c("NAME" = "state"))

## EXAMPLE 3 ---------------------------------------------------------------
# Step 1: map facets
# https://r-tmap.github.io/tmap/articles/adv_multivariate

tm_shape(us_states) +
  tm_polygons(
    fill = c("median_income_10", "median_income_15"),
    fill.scale = tm_scale_intervals(style = "jenks", n = 6),
    fill.legend = tm_legend(title = "")
  )

# Step 2: use a shared scale

tm_shape(us_states) +
  tm_polygons(
    fill = c("median_income_10", "median_income_15"),
    fill.scale = tm_scale_intervals(style = "jenks", n = 6),
    fill.legend = tm_legend(title = ""),
    fill.free = FALSE
  ) +
  tm_facets(ncol = 2)

# Step 3: add colors, labels, and projection

tm_shape(us_states) +
  tm_polygons(
    fill = c("median_income_10", "median_income_15"),
    fill.scale = tm_scale_intervals(style = "jenks", n = 6, values = "greens"),
    fill.legend = tm_legend(title = ""),
    fill.free = FALSE
  ) +
  tm_facets(ncol = 2) +
  tm_title("Median income (USD)") +
  tm_layout(panel.labels = c("2010", "2015")) +
  tm_crs("auto")

tm_us3 = tm_shape(us_states) +
  tm_polygons(
    fill = c("median_income_10", "median_income_15"),
    fill.scale = tm_scale_intervals(style = "jenks", n = 6, values = "greens"),
    fill.legend = tm_legend(title = ""),
    fill.free = FALSE
  ) +
  tm_facets_pagewise() +
  tm_title("Median income (USD)") +
  tm_layout(panel.labels = c("2010", "2015")) +
  tm_crs("auto")

# Optional: animation (writes a file)
tmap_animation(tm_us3, filename = "us_median_income.gif", width = 2400, height = 1200)

# Step 4: bivariate visualization

us_states$median_income_10k = us_states$median_income_10 / 1000
us_states$median_income_15k = us_states$median_income_15 / 1000

tm_shape(us_states) +
  tm_polygons(
    fill = tm_vars(c("median_income_10k", "median_income_15k"), multivariate = TRUE),
    fill.scale = tm_scale_bivariate(values = "purplegold"),
    fill.legend = tm_legend_bivariate(xlab = "2010", ylab = "2015")
  ) +
  tm_title("Median income (in Thousands of USD)") +
  tm_crs("auto")
