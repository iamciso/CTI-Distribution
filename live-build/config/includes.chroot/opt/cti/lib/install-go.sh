#!/bin/sh
# Compila las herramientas Go de /opt/cti/manifests/go-tools.txt en /usr/local/bin.
# Uso: install-go.sh [--upgrade] [--latest]
#   --upgrade  recompila todas (sistemas instalados, vía cti-update)
#   --latest   ignora las versiones fijadas (@vX.Y.Z) y compila @latest
set -e
MANIFEST=/opt/cti/manifests/go-tools.txt
FAILED=/opt/cti/manifests/go-failed.txt
export GOPATH=/tmp/gopath
export GOCACHE=/tmp/gocache
export GOBIN=/usr/local/bin
export GOFLAGS=-trimpath
export CGO_ENABLED=0
# Debian fija GOTOOLCHAIN=local y trixie trae Go 1.24, pero varias herramientas exigen Go 1.25/1.26:
# dejamos que "go" descargue la cadena de herramientas que pida cada módulo (se borra al final).
export GOTOOLCHAIN=auto
upgrade=0; latest=0
for arg in "$@"; do
    case "$arg" in
        --upgrade) upgrade=1 ;;
        --latest) latest=1 ;;
        *) echo "Uso: install-go.sh [--upgrade] [--latest]" >&2; exit 1 ;;
    esac
done
[ "$upgrade" -eq 1 ] && rm -f "$FAILED"
# El compilador se purga de la imagen tras el build (los binarios son estáticos); en un sistema
# instalado se vuelve a instalar a demanda para actualizar.
command -v go >/dev/null 2>&1 || { apt-get update && apt-get install -y --no-install-recommends golang-go; }

grep -vE '^\s*(#|$)' "$MANIFEST" | while read -r spec; do
    [ "$latest" -eq 1 ] && spec="${spec%%@*}@latest"
    echo ">>> go install $spec"
    if ! go install "$spec"; then
        echo "!!! fallo compilando $spec" >&2
        echo "$spec" >> "$FAILED"
    fi
done

rm -rf "$GOPATH" "$GOCACHE"
