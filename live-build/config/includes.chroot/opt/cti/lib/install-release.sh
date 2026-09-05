#!/bin/sh
# Descarga binarios oficiales desde GitHub Releases (herramientas que no admiten "go install"),
# según /opt/cti/manifests/release-tools.txt (nombre, repo, expresión del asset, [etiqueta]).
# Uso: install-release.sh [--upgrade] [--latest]
#   --upgrade  vuelve a descargar todas (sistemas instalados, vía cti-update)
#   --latest   ignora la etiqueta fijada y usa la última release publicada
set -e
MANIFEST=/opt/cti/manifests/release-tools.txt
FAILED=/opt/cti/manifests/release-failed.txt
WORK=$(mktemp -d)
upgrade=0; latest=0
for arg in "$@"; do
    case "$arg" in
        --upgrade) upgrade=1 ;;
        --latest) latest=1 ;;
        *) echo "Uso: install-release.sh [--upgrade] [--latest]" >&2; exit 1 ;;
    esac
done
[ "$upgrade" -eq 1 ] && rm -f "$FAILED"

fetch() {
    name=$1; repo=$2; pattern=$3; tag=${4:-}
    if [ -n "$tag" ] && [ "$latest" -eq 0 ]; then
        api="https://api.github.com/repos/$repo/releases/tags/$tag"
    else
        api="https://api.github.com/repos/$repo/releases/latest"
    fi
    url=$(curl -fsSL "$api" \
        | jq -r --arg re "$pattern" '.assets[] | select(.name | test($re)) | .browser_download_url' | head -n 1)
    [ -n "$url" ] || { echo "sin asset que case con '$pattern' en $repo ($api)" >&2; return 1; }
    echo "    $url"
    asset="$WORK/$(basename "$url")"
    curl -fsSL -o "$asset" "$url"
    rm -rf "$WORK/x" && mkdir -p "$WORK/x"
    case "$asset" in
        *.tar.gz|*.tgz) tar -xzf "$asset" -C "$WORK/x" ;;
        *.zip) unzip -q "$asset" -d "$WORK/x" ;;
        *) cp "$asset" "$WORK/x/$name" ;;
    esac
    bin=$(find "$WORK/x" -type f -name "$name" | head -n 1)
    [ -n "$bin" ] || { echo "el asset no contiene un fichero llamado $name" >&2; return 1; }
    install -m 0755 "$bin" "/usr/local/bin/$name"
}

grep -vE '^\s*(#|$)' "$MANIFEST" | while IFS="$(printf '\t')" read -r name repo pattern tag; do
    echo ">>> release $name ($repo ${tag:-latest})"
    if ! fetch "$name" "$repo" "$pattern" "$tag"; then
        echo "!!! fallo descargando $name" >&2
        printf '%s\t%s\n' "$name" "$repo" >> "$FAILED"
    fi
done
rm -rf "$WORK"
