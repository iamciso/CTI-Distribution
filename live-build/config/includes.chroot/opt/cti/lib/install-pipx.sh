#!/bin/sh
# Instala (o reinstala con --upgrade) las herramientas Python de /opt/cti/manifests/pipx-tools.txt
# en entornos aislados con pipx. Binarios en /usr/local/bin, venvs en /opt/pipx.
# Uso: install-pipx.sh [--upgrade]
set -e
MANIFEST=/opt/cti/manifests/pipx-tools.txt
FAILED=/opt/cti/manifests/pipx-failed.txt
export PIPX_HOME=/opt/pipx
export PIPX_BIN_DIR=/usr/local/bin
export PIP_NO_CACHE_DIR=1
mode=${1:-install}
[ "$mode" = "--upgrade" ] && rm -f "$FAILED"

grep -vE '^\s*(#|$)' "$MANIFEST" | while read -r spec; do
    echo ">>> pipx install $spec"
    if [ "$mode" = "--upgrade" ]; then
        pipx install --force "$spec" && continue
    else
        pipx install "$spec" && continue
    fi
    echo "!!! fallo instalando $spec" >&2
    echo "$spec" >> "$FAILED"
done

if [ -s "$FAILED" ]; then
    echo "Herramientas pipx que fallaron:" >&2
    cat "$FAILED" >&2
    # No abortamos por una herramienta de terceros rota; queda registrado.
fi
rm -rf /root/.cache/pip
