#!/bin/sh
# Comprueba que todos los paquetes de live-build/config/package-lists existen en el
# archivo de Debian trixie (main contrib non-free non-free-firmware).
# Pensado para ejecutarse dentro de un contenedor debian:trixie (ver CI) o en un Debian 13.
set -eu

cd "$(dirname "$0")/.."
LISTS_DIR=live-build/config/package-lists

if [ "$(id -u)" -eq 0 ] && [ -f /etc/apt/sources.list.d/debian.sources ]; then
    sed -i 's/^Components: .*/Components: main contrib non-free non-free-firmware/' \
        /etc/apt/sources.list.d/debian.sources
    apt-get update -qq
fi

cat "$LISTS_DIR"/*.list.chroot | grep -vE '^\s*(#|$)' | sort -u | while read -r pkg; do
    # "apt-cache show" devuelve 0 para paquetes virtuales o sin candidato (p. ej. radare2 en
    # trixie); lo que importa es que apt tenga un candidato instalable.
    cand=$(apt-cache policy "$pkg" 2>/dev/null | awk '/Candidate:/{print $2}')
    if [ -z "$cand" ] || [ "$cand" = "(none)" ]; then
        echo "FALTA: $pkg"
    fi
done > /tmp/check-packages.out
cat /tmp/check-packages.out
missing=$(grep -c '^FALTA' /tmp/check-packages.out || true)
total=$(cat "$LISTS_DIR"/*.list.chroot | grep -cvE '^\s*(#|$)')
echo "Paquetes comprobados: $total, no encontrados: $missing"
[ "$missing" -eq 0 ]
