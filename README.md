# Geocomputation with R — useR! 2026 tutorial

Materials for the hands-on tutorial *Geocomputation with R* at useR! 2026, by
Jannes Muenchow, Robin Lovelace and Jakub Nowosad, authors of the book
[*Geocomputation with R*](https://r.geocompx.org/) (2nd edition).

The slides are built with [Quarto](https://quarto.org/) reveal.js
(the modern successor to the xaringan decks used for the EGU 2019 version).

## Structure

- `slides/` — reveal.js decks (`.qmd`):
  - `01-intro.qmd` — introduction, definitions and a brief spatial history
  - `02-vector.qmd` — vector data with the `sf` package
  - `03-raster.qmd` — raster data with the `terra` package
  - `04-viz.qmd` — visualization with `tmap` *(added later)*
- `solutions/` — R scripts with exercise solutions
- `img/` — images used in the slides
- `custom.scss` — reveal.js theme
- `references.bib` — bibliography
- `_quarto.yml` — shared project configuration

## Building the slides

The local R installation may not contain the geospatial stack, so the decks are
rendered inside Docker using the `ghcr.io/geocompx/latest` image, which bundles R,
RStudio, Quarto and all required packages (`sf`, `terra`, `tmap`, `spData`,
`leaflet`, `mapview`, ...). Other variants (incl. the full QGIS
stack, `ghcr.io/geocompx/qgis`) are documented at
<https://github.com/geocompx/docker>.

Render a single deck:

```sh
docker run --rm -v "$PWD":/work -w /work ghcr.io/geocompx/latest \
  quarto render slides/01-intro.qmd
```

Render the whole project:

```sh
docker run --rm -v "$PWD":/work -w /work ghcr.io/geocompx/latest \
  quarto render
```

On Apple Silicon add `--platform linux/amd64` (the images are amd64-only; OrbStack
runs them under Rosetta).

## VS Code Dev Container

A `.devcontainer/` config is included. In VS Code, run
`Dev Containers: Reopen in Container` to get R, RStudio, Quarto and all spatial
packages inside the `ghcr.io/geocompx/latest` image, with the R and Quarto
extensions pre-configured. Then use `quarto preview slides/01-intro.qmd` from the
integrated terminal.

## Running RStudio (for attendees)

Attendees don't render slides — they run the exercise code in the RStudio IDE the
image ships:

```sh
docker run -e PASSWORD=pw --rm -p 8787:8787 \
  ghcr.io/geocompx/latest
```

Open <http://localhost:8787> and log in with `rstudio` / `pw` (add
`--platform linux/amd64` on Apple Silicon).

## Local install

To develop locally instead, install R (≥ 4.3), Quarto and the packages listed in
`index.qmd`, then run `quarto render` or `quarto preview`.
