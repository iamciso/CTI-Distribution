#!/bin/sh
# Genera la lista de materiales (SBOM) del sistema de ficheros de la imagen y un informe de
# vulnerabilidades conocidas, para publicarlos junto a cada ISO (transparencia de la cadena de
# suministro). Se ejecuta en el build de CI sobre el chroot de live-build, o localmente.
# Uso: tools/release/sbom.sh [directorio-chroot] [directorio-salida]
#   Salida: ctidistro.spdx.json, ctidistro.cdx.json (CycloneDX), vulns.json, vulns.txt, vulns-summary.txt
# Requiere curl, jq y tar; descarga Syft y Grype (mismas versiones que el manifiesto release-tools).
set -eu
CHROOT=${1:-live-build/chroot}
OUT=${2:-live-build/sbom}
SYFT_VERSION=${SYFT_VERSION:-v1.51.1}
GRYPE_VERSION=${GRYPE_VERSION:-v0.118.0}
[ -d "$CHROOT" ] || { echo "No existe el chroot: $CHROOT" >&2; exit 1; }
mkdir -p "$OUT"
BIN=$(mktemp -d)

fetch_tool() {
    name=$1; repo=$2; pattern=$3; tag=$4
    url=$(curl -fsSL "https://api.github.com/repos/$repo/releases/tags/$tag" \
        | jq -r --arg re "$pattern" '.assets[] | select(.name | test($re)) | .browser_download_url' | head -n 1)
    [ -n "$url" ] || { echo "sin asset para $name $tag" >&2; return 1; }
    curl -fsSL "$url" | tar -xz -C "$BIN" "$name"
    chmod 0755 "$BIN/$name"
}
command -v syft >/dev/null 2>&1 || fetch_tool syft anchore/syft 'syft_.*_linux_amd64\.tar\.gz$' "$SYFT_VERSION"
command -v grype >/dev/null 2>&1 || fetch_tool grype anchore/grype 'grype_.*_linux_amd64\.tar\.gz$' "$GRYPE_VERSION"
PATH="$BIN:$PATH"; export PATH

echo ">>> SBOM del chroot ($CHROOT)"
syft "dir:$CHROOT" --source-name ctidistro -q \
    -o "spdx-json=$OUT/ctidistro.spdx.json" \
    -o "cyclonedx-json=$OUT/ctidistro.cdx.json"

echo ">>> Vulnerabilidades conocidas (Grype)"
grype "sbom:$OUT/ctidistro.spdx.json" -q -o json > "$OUT/vulns.json"
grype "sbom:$OUT/ctidistro.spdx.json" -q -o table > "$OUT/vulns.txt" || true

{
    echo "Informe de vulnerabilidades de la imagen (Grype $GRYPE_VERSION, $(date -u +%Y-%m-%dT%H:%MZ))"
    echo "Paquetes en el SBOM: $(jq '.packages | length' "$OUT/ctidistro.spdx.json")"
    echo "Coincidencias por severidad:"
    jq -r '.matches[].vulnerability.severity' "$OUT/vulns.json" | sort | uniq -c | sort -rn | sed 's/^/  /'
    echo "Con corrección disponible: $(jq '[.matches[] | select(.vulnerability.fix.state == "fixed")] | length' "$OUT/vulns.json")"
} > "$OUT/vulns-summary.txt"
cat "$OUT/vulns-summary.txt"
rm -rf "$BIN"
