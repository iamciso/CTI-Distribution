# Catálogo de herramientas

Origen: **deb** = archivo Debian trixie, **pipx** = PyPI en entorno aislado, **go** = compilado en el
build, **venv** = librería en `/opt/cti/venv`, **docker** = desplegado bajo demanda. Criterio de inclusión: uso pasivo o de análisis,
mantenida activamente, licencia compatible con la redistribución.

Los nombres de paquete se validan automáticamente en CI (`tests/check-packages.sh`). Los
nombres ya han sido validados contra trixie: theHarvester, Amass, oletools, stix2, PyMISP y taxii2-client
no están en Debian 13 y se instalan por pipx, Go o venv.

## Reconocimiento de infraestructura (pasivo)

| Herramienta | Origen | Licencia | Notas |
|---|---|---|---|
| theHarvester | pipx | GPL-2 | Correos, subdominios, IPs desde fuentes públicas |
| recon-ng | deb | GPL-3 | Framework modular con claves API |
| Amass | go | Apache-2 | Enumeración de subdominios y mapeo de superficie |
| Sublist3r | deb | GPL-2 | Subdominios desde buscadores |
| subfinder, dnsx, httpx, katana | go | MIT | Cadena ProjectDiscovery: descubrimiento y verificación |
| waybackurls, gau, assetfinder | go | MIT | URLs históricas y activos |
| dnsrecon, dnsenum, fierce | deb | GPL | Enumeración DNS |
| dnstwist | deb | Apache-2 | Dominios typosquatting / phishing |
| whatweb, wafw00f | deb | GPL | Huella tecnológica de sitios web |
| gowitness | go | GPL-3 | Capturas de pantalla masivas de sitios |
| nmap, masscan | deb | Nmap/AGPL | Incluidos para verificación puntual; **no** para escaneo masivo de terceros |
| Shodan CLI, Censys CLI | deb / pipx | MIT / Apache-2 | Requieren claves API |
| whois, dig, mtr, geoip | deb | varias | Utilidades de red |

## Personas, redes sociales e identidades

| Herramienta | Origen | Licencia | Notas |
|---|---|---|---|
| SpiderFoot | pipx | MIT | Automatización OSINT con interfaz web (`spiderfoot -l 127.0.0.1:5001`) |
| Sherlock, Maigret | pipx | MIT | Nombres de usuario en cientos de sitios |
| Holehe, socialscan | pipx | GPL-3 / MPL-2 | Correos registrados en servicios |
| GHunt | pipx | AGPL-3 | Cuentas Google |
| h8mail, emailrep | pipx | BSD / MIT | Filtraciones y reputación de correos |
| bbot | pipx | GPL-3 | OSINT recursivo modular |
| Instaloader, gallery-dl, yt-dlp | deb | MIT / GPL / Unlicense | Descarga y archivado de contenido |
| Multi-Account Containers (Firefox) | extensión | MPL-2 | Separación de identidades (sock puppets) |

## Ficheros, medios y metadatos

| Herramienta | Origen | Licencia | Notas |
|---|---|---|---|
| ExifTool, exiv2, mediainfo | deb | Perl / GPL | Metadatos de imagen, vídeo y documentos |
| mat2 | deb | LGPL-3 | Limpieza de metadatos antes de compartir |
| Tesseract (es, en) | deb | Apache-2 | OCR |
| GIMP, ImageMagick, ffmpeg | deb | GPL | Mejora y conversión de imagen y vídeo |
| poppler-utils, pdfgrep, pdfid | deb / pipx | GPL / Public | Análisis de PDF |

## CTI: formatos, detección y triaje

| Herramienta | Origen | Licencia | Notas |
|---|---|---|---|
| stix2, taxii2-client | venv | BSD-3 | Lectura y escritura STIX 2.1 / TAXII, en `/opt/cti/venv` (`cti-python`) |
| PyMISP | venv | BSD-2 | Cliente de MISP, en `/opt/cti/venv` |
| attackcti, mitreattack-python | pipx | BSD / Apache-2 | Consulta de ATT&CK |
| sigma-cli | pipx | LGPL-2.1 | Conversión de reglas Sigma |
| YARA | deb | BSD-3 | Reglas de detección |
| capa | pipx | Apache-2 | Capacidades de binarios |
| ClamAV, ssdeep, hashdeep | deb | GPL | Antivirus y hashes difusos |
| binwalk, radare2, pev | deb | MIT / LGPL / BSD | Triaje ligero de ficheros y documentos |
| oletools | pipx | BSD-2 | olevba, oleid, mraptor para documentos Office |
| iocextract | pipx | GPL-2 | Extracción de IOCs de texto |
| vt-cli | go | Apache-2 | VirusTotal desde la terminal |
| Jupyter, pandas, networkx, graphviz | deb | BSD | Análisis de datos y grafos |
| OpenCTI | docker | Apache-2 | Plataforma de conocimiento CTI |
| MISP | docker | AGPL-3 | Compartición de indicadores |
| ATT&CK Navigator | docker | Apache-2 | Mapas de técnicas |

## OPSEC y cifrado

| Herramienta | Origen | Licencia | Notas |
|---|---|---|---|
| Tor, torsocks, Tor Browser Launcher | deb | BSD / GPL | Tor deshabilitado por defecto |
| proxychains4 | deb | GPL-2 | Encadenar proxies |
| WireGuard, OpenVPN | deb | GPL | VPN comerciales o propias |
| dnscrypt-proxy | deb | ISC | DNS cifrado a nivel de sistema (opcional) |
| nftables | deb | GPL-2 | Cortafuegos entrante cerrado |
| macchanger + NetworkManager | deb | GPL | MAC aleatoria por conexión |
| AppArmor, Firejail | deb | GPL | Confinamiento de aplicaciones |
| OpenSnitch | deb | GPL-3 | Cortafuegos de aplicaciones saliente |
| OnionShare | deb | GPL-3 | Compartir ficheros vía Tor |
| KeePassXC, age, GnuPG | deb | GPL / Apache-2 | Credenciales y cifrado |
| Discos de GNOME, cryptsetup | deb | GPL | Volúmenes LUKS con interfaz gráfica y por consola |
| BleachBit, secure-delete, USBGuard | deb | GPL | Limpieza y control de USB |

## Documentación y reporting

| Herramienta | Origen | Notas |
|---|---|---|
| CherryTree | deb | Notas jerárquicas por caso |
| LibreOffice, pandoc | deb | Informes; pandoc convierte Markdown a PDF/DOCX |
| KeePassXC | deb | Claves API y credenciales de personas ficticias |
| `cti-evidence` | propio | Hash + marca de tiempo + manifiesto CSV |

## Evaluadas y excluidas

| Herramienta | Motivo |
|---|---|
| Maltego | Licencia propietaria; el usuario puede instalar Maltego CE por su cuenta |
| Hunchly | Propietaria y de pago |
| Metasploit, sqlmap, hydra, etc. | Fuera del alcance: explotación activa |
| metagoofil, zuluCrypt | No están en Debian 13; cubiertos por theHarvester y Discos de GNOME |
| twint, snscrape | Sin mantenimiento, rotas por cambios en las plataformas |
| Obsidian, Joplin | No empaquetadas en Debian; candidatas vía Flatpak en fase 3 |
| CyberChef | Candidata: descargar la release oficial en un hook (fase 2) |
