#!/bin/sh
# Smoke test para ejecutar DENTRO de un sistema arrancado (live o instalado).
# Verifica que las herramientas clave están en el PATH.
set -u

tools="
nmap amass theHarvester recon-ng dnstwist whatweb exiftool mat2 gallery-dl yt-dlp instaloader
olevba yara clamscan ssdeep binwalk r2 jupyter-notebook pandoc
tor torsocks proxychains4 macchanger wg openvpn nft firejail onionshare-cli age
spiderfoot sherlock maigret holehe socialscan ghunt h8mail bbot sigma capa pdfid censys
subfinder dnsx httpx katana waybackurls assetfinder gau gowitness vt
cti-netcheck cti-evidence cti-python
docker
"

fail=0
for t in $tools; do
    if command -v "$t" >/dev/null 2>&1; then
        printf 'OK    %s\n' "$t"
    else
        printf 'FALTA %s\n' "$t"
        fail=$((fail + 1))
    fi
done

echo
echo "Herramientas ausentes: $fail"
for f in /opt/cti/manifests/pipx-failed.txt /opt/cti/manifests/go-failed.txt /opt/cti/manifests/python-libs-failed.txt; do
    [ -s "$f" ] && { echo "Fallos registrados en $f:"; cat "$f"; }
done
[ "$fail" -eq 0 ]
