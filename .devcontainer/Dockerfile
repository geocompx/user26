FROM ghcr.io/geocompx/qgis

# Install system packages as root during build (not postCreateCommand)
RUN apt-get update && apt-get install -y \
    bubblewrap \
    socat \
    && rm -rf /var/lib/apt/lists/*
