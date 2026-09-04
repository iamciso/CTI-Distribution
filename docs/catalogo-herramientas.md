# Catálogo de herramientas

Origen: **deb** = archivo Debian trixie, **pipx** = PyPI en entorno aislado, **go** = compilado en el
build, **release** = binario oficial descargado de GitHub Releases en el build, **venv** = librería en
`/opt/cti/venv`, **docker** = desplegado bajo demanda. Criterio de inclusión: uso pasivo o de análisis,
mantenida activamente, licencia compatible con la redistribución.

Los nombres de paquete se validan automáticamente en CI (`tests/check-packages.sh`). Los
nombres ya han sido validados contra trixie: theHarvester, Amass, oletools, stix2, PyMISP y taxii2-client
no están en Debian 13 y se instalan por pipx, Go o venv.

## Reconocimiento de infraestructura (pasivo)

| Herramienta | Origen | Licencia | Notas |
|---|---|---|---|
| theHarvester | pipx (desde GitHub, etiqueta fija) | GPL-2 | Correos, subdominios, IPs desde fuentes públicas. El paquete PyPI es un placeholder vacío |
| recon-ng | deb | GPL-3 | Framework modular con claves API |
| Amass | go | Apache-2 | Enumeración de subdominios y mapeo de superficie |
| Sublist3r | deb | GPL-2 | Subdominios desde buscadores |
| subfinder, dnsx, httpx, katana | go | MIT | Cadena ProjectDiscovery: descubrimiento y verificación |
| uncover, asnmap, cdncheck, tlsx | go | MIT | ProjectDiscovery: buscadores agregados, ASN, CDN/WAF y certificados |
| hakrawler, metabigor | go | MIT | Rastreo rápido de enlaces; IPs, ASN y organización |
| waybackurls, gau, assetfinder | go | MIT | URLs históricas y activos |
| dnsrecon, dnsenum, fierce | deb | GPL | Enumeración DNS |
| dnstwist | deb | Apache-2 | Dominios typosquatting / phishing |
| whatweb, wafw00f | deb | GPL | Huella tecnológica de sitios web |
| gowitness | go | GPL-3 | Capturas de pantalla masivas de sitios |
| nmap, masscan | deb | Nmap/AGPL | Incluidos para verificación puntual; **no** para escaneo masivo de terceros |
| Shodan CLI, Censys CLI, ZoomEye CLI | deb / pipx | MIT / Apache-2 / GPL-3 | Requieren claves API |
| whois, dig, mtr, geoip | deb | varias | Utilidades de red |

## Personas, redes sociales e identidades

| Herramienta | Origen | Licencia | Notas |
|---|---|---|---|
| SpiderFoot | docker | MIT | Automatización OSINT con interfaz web. Su versión 4.0 (2022) no se instala en Python 3.13; se construye con Docker desde `/opt/cti/stacks/spiderfoot` |
| Sherlock, Maigret | pipx | MIT | Nombres de usuario en cientos de sitios |
| Holehe, socialscan | pipx | GPL-3 / MPL-2 | Correos registrados en servicios |
| GHunt | pipx | AGPL-3 | Cuentas Google |
| h8mail, emailrep | pipx | BSD / MIT | Filtraciones y reputación de correos |
| bbot | pipx | GPL-3 | OSINT recursivo modular |
| PhoneInfoga, ignorant, telegram-phone-number-checker | release / pipx | GPL-3 / GPL-3 / MIT | Números de teléfono: operador, servicios registrados, cuentas de Telegram |
| toutatis, socid-extractor, xeuledoc | pipx | GPL-3 / MIT / GPL-3 | Instagram, extracción de identificadores de perfiles, documentos de Google |
| CrossLinked | pipx | MIT | Empleados de una organización vía buscadores (LinkedIn) |
| auto-archiver (Bellingcat) | pipx | MIT | Archivado con hash y captura de publicaciones y páginas |
| Instaloader, gallery-dl, yt-dlp | deb | MIT / GPL / Unlicense | Descarga y archivado de contenido |
| Multi-Account Containers (Firefox) | extensión | MPL-2 | Separación de identidades (sock puppets) |

## Ficheros, medios y metadatos

| Herramienta | Origen | Licencia | Notas |
|---|---|---|---|
| ExifTool, exiv2, mediainfo | deb | Perl / GPL | Metadatos de imagen, vídeo y documentos |
| mat2 | deb | LGPL-3 | Limpieza de metadatos antes de compartir |
| Tesseract (es, en) | deb | Apache-2 | OCR |
| GIMP, ImageMagick, ffmpeg | deb | GPL | Mejora y conversión de imagen y vídeo |
| foremost, PhotoRec (testdisk), sleuthkit | deb | GPL | Carving y recuperación de ficheros |
| steghide, stegseek, zbar-tools, qrencode | deb | GPL / MIT / LGPL | Esteganografía y códigos QR/barras |
| poppler-utils, pdfgrep, pdfid | deb / venv | GPL / Public | Análisis de PDF. `pdfid` se instala en `/opt/cti/venv` (PyPI lo publica sin ejecutable) con un lanzador en `/usr/local/bin` |

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
| binwalk, pev, binutils | deb | MIT / BSD / GPL | Triaje ligero de ficheros y documentos |
| oletools | pipx | BSD-2 | olevba, oleid, mraptor para documentos Office |
| iocextract | pipx | GPL-2 | Extracción de IOCs de texto |
| vt-cli, GreyNoise CLI | go / pipx | Apache-2 / MIT | VirusTotal y GreyNoise desde la terminal |
| gitleaks, TruffleHog | go / release | MIT / AGPL-3 | Secretos y credenciales expuestos en repositorios y ficheros |
| pycti, vt-py, OTXv2 | venv | Apache-2 / Apache-2 / BSD | Clientes de OpenCTI, VirusTotal y AlienVault OTX en `/opt/cti/venv` |
| JupyterLab, pandas, matplotlib, folium, networkx, graphviz | deb | BSD | Análisis de datos, mapas y grafos |
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
| OpenSnitch | deb | GPL-3 | Cortafuegos de aplicaciones saliente. Deshabilitado por defecto: al arrancar añade reglas nftables propias (`sudo systemctl start opensnitch`) |
| OnionShare | deb | GPL-3 | Compartir ficheros vía Tor |
| KeePassXC, age, GnuPG | deb | GPL / Apache-2 | Credenciales y cifrado |
| Discos de GNOME, cryptsetup | deb | GPL | Volúmenes LUKS con interfaz gráfica y por consola |
| BleachBit, secure-delete, USBGuard | deb | GPL | Limpieza y control de USB |

## Gobernanza, cumplimiento y auditoría defensiva

| Herramienta | Origen | Licencia | Notas |
|---|---|---|---|
| Lynis | deb | GPL-3 | Auditoría de hardening del sistema |
| OpenSCAP + SCAP Security Guide | deb | LGPL / BSD | Evaluación de cumplimiento (perfiles ANSSI para Debian) |
| testssl.sh, ssh-audit, dnsviz | deb | GPL / MIT / GPL | Configuración TLS, SSH y DNSSEC de servicios propios |
| checkdmarc | pipx | Apache-2 | SPF, DKIM y DMARC del dominio |
| compliance-trestle | pipx | Apache-2 | Catálogos y perfiles de controles en OSCAL (NIST 800-53, CSF) |
| Trivy, Grype, Syft, osv-scanner | release | Apache-2 | SBOM y vulnerabilidades de contenedores, imágenes, código y dependencias |
| cve-bin-tool, cvss | pipx | GPL-3 / MIT | CVEs en binarios; calculadora CVSS |
| unfurl | pipx | Apache-2 | Desmontaje de URLs sospechosas |
| VisiData, Miller, csvkit, lnav | deb | GPL / BSD / MIT / BSD | Tablas, CSV, JSON y logs en terminal |
| newsboat, toot, Miniflux | deb / docker | MIT / GPL / Apache-2 | Vigilancia de fuentes RSS y fediverso |
| warcio, OpenTimestamps | pipx | Apache-2 / LGPL-3 | Ficheros WARC (creados por `cti-evidence` con wget) y sellado de tiempo de evidencias |
| CISO Assistant | docker | AGPL-3 | Plataforma GRC (ISO 27001, NIS2, DORA, ENS, CIS, NIST CSF) |
| DFIR-IRIS, Timesketch | docker | LGPL-3 / Apache-2 | Gestión de casos y líneas de tiempo |
| GoPhish | docker | MIT | Simulaciones de phishing para concienciación |
| Calamares | deb | GPL-3 | Instalador gráfico con cifrado de disco |
| Flatpak (Flathub) | deb | LGPL | Obsidian, Logseq, Signal, Element, draw.io, Zotero bajo demanda (`cti-extras`) |
| Thunderbird | deb | MPL-2 | Correo con OpenPGP |

## Documentación y reporting

| Herramienta | Origen | Notas |
|---|---|---|
| CherryTree | deb | Notas jerárquicas por caso |
| LibreOffice, pandoc | deb | Informes; pandoc convierte Markdown a PDF/DOCX |
| KeePassXC | deb | Claves API y credenciales de personas ficticias |
| `cti-evidence` | propio | Hash, marca de tiempo, captura de páginas y sello OpenTimestamps |
| `cti-report` | propio | Plantillas Markdown (inteligencia, ACH, riesgos, auditoría, política, playbook, proveedores) y PDF/DOCX con pandoc y XeLaTeX |

## Evaluadas y excluidas

| Herramienta | Motivo |
|---|---|
| Maltego | Licencia propietaria; el usuario puede instalar Maltego CE por su cuenta |
| Hunchly | Propietaria y de pago |
| Metasploit, sqlmap, hydra, nuclei, naabu | Fuera del alcance: explotación y escaneo activo |
| mitmproxy, bulk-extractor, urlcrazy | No están en Debian 13 |
| OSRFramework, metagoofil, pagodo, blackbird | Sin paquete PyPI utilizable en Python 3.13 (candidatas vía git en fase 2) |
| harpoon, pywb | Fijan lxml<5 y gevent antiguos que no compilan en Python 3.13; cubiertos por uncover/vt/greynoise y wget + warcio |
| metagoofil, zuluCrypt | No están en Debian 13; cubiertos por theHarvester y Discos de GNOME |
| twint, snscrape | Sin mantenimiento, rotas por cambios en las plataformas |
| Obsidian, Joplin | No empaquetadas en Debian; candidatas vía Flatpak en fase 3 |
| CyberChef | Candidata: descargar la release oficial en un hook (fase 2) |
| radare2 / rizin / Cutter | No están en Debian 13 (radare2 solo en sid); candidatos vía .deb oficial o Flatpak en fase 2 |
