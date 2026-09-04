#!/bin/sh
# Crea o actualiza el entorno /opt/cti/venv con las librerías de python-libs.txt y lo registra
# como kernel de Jupyter "Python (CTI)". Uso: install-venv.sh [--upgrade]
set -e
MANIFEST=/opt/cti/manifests/python-libs.txt
FAILED=/opt/cti/manifests/python-libs-failed.txt
VENV=/opt/cti/venv
export PIP_NO_CACHE_DIR=1
mode=${1:-install}
[ "$mode" = "--upgrade" ] && rm -f "$FAILED"

[ -x "$VENV/bin/python" ] || python3 -m venv --system-site-packages "$VENV"
"$VENV/bin/pip" install --upgrade pip ipykernel

grep -vE '^\s*(#|$)' "$MANIFEST" | while read -r spec; do
    echo ">>> pip install $spec"
    if [ "$mode" = "--upgrade" ]; then
        "$VENV/bin/pip" install --upgrade "$spec" && continue
    else
        "$VENV/bin/pip" install "$spec" && continue
    fi
    echo "!!! fallo instalando $spec" >&2
    echo "$spec" >> "$FAILED"
done

"$VENV/bin/python" -m ipykernel install --name cti --display-name "Python (CTI)"
rm -rf /root/.cache/pip
