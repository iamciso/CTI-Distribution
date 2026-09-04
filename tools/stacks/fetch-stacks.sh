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
clone spiderfoot       https://github.com/smicallef/spiderfoot.git
# Gobernanza, gestión de casos, líneas de tiempo, concienciación y vigilancia
clone ciso-assistant   https://github.com/intuitem/ciso-assistant-community.git
clone iris-web         https://github.com/dfir-iris/iris-web.git
clone timesketch       https://github.com/google/timesketch.git
clone gophish          https://github.com/gophish/gophish.git

cat <<MSG

Stacks descargados en $DEST. Siguientes pasos:
  OpenCTI : cd $DEST/opencti && cp .env.sample .env && edita .env && docker compose up -d
  MISP    : cd $DEST/misp && cp template.env .env && edita .env && docker compose up -d
  Navigator: cd $DEST/attack-navigator && docker build -t attack-navigator . && docker run -p 4200:4200 attack-navigator
  SpiderFoot: cd $DEST/spiderfoot && docker build -t spiderfoot . && docker run -p 127.0.0.1:5001:5001 spiderfoot
  CISO Assistant (GRC): cd $DEST/ciso-assistant && ./docker-compose.sh   (https://localhost:8443)
  DFIR-IRIS (casos): cd $DEST/iris-web && cp .env.model .env && docker compose up -d   (https://localhost:8444, ver docs)
  Timesketch: cd $DEST/timesketch/contrib && ./deploy_timesketch.sh   (http://localhost:8445 según el despliegue)
  GoPhish: cd $DEST/gophish && docker build -t gophish . && docker run -p 127.0.0.1:3333:3333 -p 127.0.0.1:8080:80 gophish
  Miniflux (RSS): docker run -d -p 127.0.0.1:8446:8080 -e DATABASE_URL=... miniflux/miniflux   (ver docs de Miniflux)
MSG
