#!/bin/sh
# Compila las herramientas Go de /opt/cti/manifests/go-tools.txt en /usr/local/bin.
# Uso: install-go.sh [--upgrade]   (con --upgrade se recompilan todas a la última versión)
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
[ "${1:-}" = "--upgrade" ] && rm -f "$FAILED"

grep -vE '^\s*(#|$)' "$MANIFEST" | while read -r spec; do
    echo ">>> go install $spec"
    if ! go install "$spec"; then
        echo "!!! fallo compilando $spec" >&2
        echo "$spec" >> "$FAILED"
    fi
done

rm -rf "$GOPATH" "$GOCACHE"
