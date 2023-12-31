FROM ubuntu:22.04 AS builder

# Install Godot & templates
ARG GODOT_VERSION
ARG GODOT_URL

# Echo the args
RUN echo "GODOT_VERSION: ${GODOT_VERSION}"
RUN echo "GODOT_URL: ${GODOT_URL}"

RUN apt update -y \
    && apt install -y wget unzip \
    && wget ${GODOT_URL} \
    && wget https://github.com/godotengine/godot/releases/download/${GODOT_VERSION}-stable/Godot_v${GODOT_VERSION}-stable_export_templates.tpz

RUN mkdir -p ~/.cache ~/.config/godot ~/.local/share/godot/export_templates/${GODOT_VERSION}.stable \
    && unzip Godot_v${GODOT_VERSION}-stable_linux*.zip \
    && mv Godot_v${GODOT_VERSION}-stable_linux*64 /usr/local/bin/godot \
    && unzip Godot_v${GODOT_VERSION}-stable_export_templates.tpz \
    && mv templates/* ~/.local/share/godot/export_templates/${GODOT_VERSION}.stable \
    && rm Godot_v${GODOT_VERSION}-stable_export_templates.tpz Godot_v${GODOT_VERSION}-stable_linux*.zip

# Build application
WORKDIR /app

ENTRYPOINT [ "godot" ]