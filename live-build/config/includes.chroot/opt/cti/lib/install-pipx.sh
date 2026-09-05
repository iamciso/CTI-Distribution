#!/bin/sh
# Instala (o reinstala con --upgrade) las herramientas Python de /opt/cti/manifests/pipx-tools.txt
# en entornos aislados con pipx. Binarios en /usr/local/bin, venvs en /opt/pipx.
# Uso: install-pipx.sh [--upgrade] [--latest]
#   --upgrade  reinstala todas las herramientas (sistemas instalados, vía cti-update)
#   --latest   ignora las versiones fijadas (nombre==versión) y toma la última de PyPI
set -e
MANIFEST=/opt/cti/manifests/pipx-tools.txt
FAILED=/opt/cti/manifests/pipx-failed.txt
export PIPX_HOME=/opt/pipx
export PIPX_BIN_DIR=/usr/local/bin
export PIP_NO_CACHE_DIR=1
upgrade=0; latest=0
for arg in "$@"; do
    case "$arg" in
        --upgrade) upgrade=1 ;;
        --latest) latest=1 ;;
        *) echo "Uso: install-pipx.sh [--upgrade] [--latest]" >&2; exit 1 ;;
    esac
done
[ "$upgrade" -eq 1 ] && rm -f "$FAILED"

grep -vE '^\s*(#|$)' "$MANIFEST" | while read -r spec; do
    # Con --latest se quita la versión fijada (las referencias git+...@etiqueta se mantienen).
    if [ "$latest" -eq 1 ]; then
        case "$spec" in git+*) ;; *) spec=${spec%%==*} ;; esac
    fi
    echo ">>> pipx install $spec"
    if [ "$upgrade" -eq 1 ]; then
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
