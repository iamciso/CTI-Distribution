#!/bin/sh
# Descarga los despliegues oficiales Docker Compose de las plataformas CTI en /opt/cti/stacks.
# Se ejecuta en el sistema ya arrancado (no en el build) para no congelar versiones de
# plataformas que evolucionan rápido y para no engordar la ISO.
set -eu

DEST=${1:-/opt/cti/stacks}
mkdir -p "$DEST"

clone() {
    name=$1; url=$2
    if [ -d "$DEST/$name/.git" ]; then
        echo ">>> actualizando $name"; git -C "$DEST/$name" pull --ff-only
    else
        echo ">>> clonando $name"; git clone --depth 1 "$url" "$DEST/$name"
    fi
}

clone opencti          https://github.com/OpenCTI-Platform/docker.git
clone misp             https://github.com/MISP/misp-docker.git
clone attack-navigator https://github.com/mitre-attack/attack-navigator.git

cat <<MSG

Stacks descargados en $DEST. Siguientes pasos:
  OpenCTI : cd $DEST/opencti && cp .env.sample .env && edita .env && docker compose up -d
  MISP    : cd $DEST/misp && cp template.env .env && edita .env && docker compose up -d
  Navigator: cd $DEST/attack-navigator && docker build -t attack-navigator . && docker run -p 4200:4200 attack-navigator
MSG
