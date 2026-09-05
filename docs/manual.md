# Manual de usuario

CTI Distribution es una distribución Debian 13 para analistas de ciberinteligencia, OSINT y
responsables de seguridad con enfoque de gobernanza. Este manual explica cómo arrancarla, cómo está
organizada y cómo realizar los flujos de trabajo habituales. Para el diseño interno ver
[arquitectura.md](arquitectura.md); para el modelo de amenazas y los controles, [opsec.md](opsec.md).

## 1. Requisitos y modos de uso

| Modo | Cómo | Requisitos |
|---|---|---|
| En vivo (amnésico) | Arrancar la ISO desde USB o DVD; nada se guarda al apagar | 4 GB de RAM, procesador x86-64 |
| En vivo con persistencia cifrada | La misma ISO más una partición LUKS etiquetada `persistence` | USB de 16 GB o más |
| Instalado | Menú *8. Gobernanza y cumplimiento > Instalar en disco* (Calamares) | Disco de 30 GB (40 recomendados), UEFI o BIOS |
| Máquina virtual | Cualquiera de los anteriores en VirtualBox, VMware o QEMU | 4 GB de RAM, 2 CPU, gráficos VMSVGA/virtio |

La ISO es híbrida: se graba en USB con `dd`, Rufus (modo DD) o Ventoy, y arranca en BIOS y en UEFI
con Secure Boot activado.

Usuario en vivo: `analyst` (contraseña `live`, sin contraseña para `sudo`). En un sistema instalado
el usuario, la contraseña y la contraseña de cifrado son los que se elijan en el instalador.

## 2. Primeros minutos

1. Al iniciar sesión aparece un aviso de bienvenida con la guía rápida (`~/README-ctidistro.txt`).
2. Comprueba la postura de red antes de investigar:

   ```bash
   cti-netcheck
   ```

   Muestra las interfaces, la MAC actual frente a la permanente (aleatoria por defecto), la IP pública,
   si el tráfico sale por Tor y qué resolvedor DNS ven los terceros.
3. Guarda las claves API de los servicios que uses. Se almacenan en `~/.config/cti/keys.env`
   (permisos 0600) y se exportan automáticamente en cada terminal nuevo:

   ```bash
   cti-keys set SHODAN_API_KEY
   cti-keys list
   ```

4. Descarga los catálogos públicos de referencia (ATT&CK, D3FEND, CAPEC, CWE, KEV, EPSS, NIST CSF
   2.0, SP 800-53, ThreatFox, URLhaus) en `~/cti-data`:

   ```bash
   cti-feeds
   ```

5. Verifica que todas las herramientas están presentes:

   ```bash
   cti-smoke-test
   ```

## 3. El menú de herramientas

El menú (icono superior izquierdo o tecla Super) y la parrilla de aplicaciones agrupan las
herramientas por funcionalidad, al estilo de Kali:

| Categoría | Contenido |
|---|---|
| 1. Reconocimiento | Dominios, subdominios, DNS, certificados, huella web, buscadores de dispositivos, vigilancia RSS |
| 2. Personas y redes sociales | Nombres de usuario, correos, teléfonos, cuentas Google, Instagram, Telegram, archivado de publicaciones |
| 3. Ficheros, medios y metadatos | ExifTool, mat2, OCR, triaje de PDF y Office, carving, esteganografía, códigos QR |
| 4. Análisis CTI | YARA, capa, Sigma, ATT&CK, IOCs, VirusTotal, GreyNoise, secretos en repositorios, JupyterLab |
| 5. OPSEC y anonimato | Tor Browser, OnionShare, OpenSnitch, KeePassXC, discos cifrados, BleachBit, Firejail |
| 6. Evidencias e informes | `cti-evidence`, `cti-report`, CherryTree, LibreOffice, Thunderbird, warcio, OpenTimestamps |
| 7. Plataformas | OpenCTI, MISP, ATT&CK Navigator, SpiderFoot, CISO Assistant, DFIR-IRIS, Timesketch, GoPhish (Docker) |
| 8. Gobernanza y cumplimiento | Lynis, OpenSCAP, testssl, ssh-audit, checkdmarc, OSCAL, Trivy, Grype, Syft, instalador |

Las herramientas de terminal se abren con `cti-run`: una ventana muestra la ayuda del comando y deja
un shell listo para usarlo. El menú se genera a partir de `/opt/cti/menu/tools.tsv`; para añadir una
herramienta basta con una línea en ese fichero y ejecutar `sudo python3 /opt/cti/menu/generate-menu.py`
seguido de `sudo dconf update`.

## 4. Flujos de trabajo

### 4.1 Investigación OSINT con cadena de custodia

1. Crea la carpeta del caso y registra los requisitos de información (plantilla `informe-inteligencia`):

   ```bash
   mkdir -p ~/Casos/2026-09-caso-ejemplo && cd ~/Casos/2026-09-caso-ejemplo
   cti-report new informe-inteligencia
   ```

2. Comprueba la red (`cti-netcheck`). Si la investigación requiere anonimato, usa Tor Browser o
   `proxychains4` con Tor arrancado (`sudo systemctl start tor`), y nunca mezcles cuentas reales con
   identidades ficticias en el mismo navegador.
3. Recolecta con las herramientas de las categorías 1 y 2. Ejemplos:

   ```bash
   theHarvester -d ejemplo.es -b crtsh,duckduckgo
   subfinder -d ejemplo.es -silent | dnsx -silent | httpx -silent -title
   sherlock usuario_objetivo
   holehe correo@ejemplo.es
   ```

4. Captura cada página relevante como evidencia. `cti-evidence url` guarda PNG, PDF, HTML y WARC,
   calcula el SHA-256, anota analista, fecha UTC y nota, y sella el hash con OpenTimestamps:

   ```bash
   cti-evidence url https://ejemplo.es/pagina "Perfil público del objetivo"
   cti-evidence captura.png "Captura manual"
   cti-evidence verify ~/Evidence/20260906-120000-ejemplo.es/page.pdf
   ```

   El manifiesto acumulado está en `~/Evidence/manifest.csv`.
5. Limpia los metadatos de todo lo que vayas a compartir (`mat2 fichero`).
6. Redacta el informe con la plantilla (escala Admiralty para las fuentes, niveles de confianza,
   etiqueta TLP) y genera el PDF:

   ```bash
   cti-report build 2026-09-06-informe-inteligencia.md
   ```

### 4.2 Panorama de amenazas o perfil de actor

1. Actualiza los catálogos (`cti-feeds`) y consulta ATT&CK sin conexión:

   ```bash
   attackcti --help
   cti-python -c "import json; d=json.load(open('/home/analyst/cti-data/attack-enterprise.json')); print(len(d['objects']))"
   ```

2. Prioriza vulnerabilidades con KEV y EPSS (`~/cti-data/cisa-kev.json`, `epss.csv.gz`) desde
   JupyterLab (kernel *Python (CTI)*) o VisiData.
3. Contrasta hipótesis con la matriz ACH (`cti-report new matriz-ach`).
4. Publica el informe con `cti-report build`, indicando la etiqueta TLP en la cabecera.

### 4.3 Auditoría y cumplimiento

- Postura de correo del dominio: `checkdmarc ejemplo.es`.
- Configuración TLS y SSH de servicios propios: `testssl servidor:443`, `ssh-audit servidor`.
- Hardening de un sistema: `sudo lynis audit system` o, sobre la propia estación, `sudo cti-selfaudit`
  (informes en `~/Audit`).
- Dependencias y contenedores: `syft dir:proyecto -o cyclonedx-json`, `grype dir:proyecto`,
  `trivy image imagen:tag`, `osv-scanner -r proyecto`.
- Marcos de control en OSCAL (`trestle`), catálogo NIST 800-53 y CSF 2.0 en `~/cti-data`.
- Registro de riesgos, política de seguridad, playbook de incidentes y cuestionario de proveedores:
  `cti-report list` muestra las plantillas disponibles.
- Plataforma GRC completa: `sudo systemctl start docker`, `sudo /opt/cti/stacks/fetch-stacks.sh` y
  después CISO Assistant en `https://localhost:8443` (ver `/opt/cti/stacks/README.md`).

### 4.4 Gestión de incidentes y casos

DFIR-IRIS (casos), Timesketch (líneas de tiempo) y MISP (compartición) se despliegan con Docker desde
`/opt/cti/stacks`. Para el triaje de correos y ficheros sospechosos sin abrirlos: `unfurl` para URLs,
`olevba` y `oleid` para Office, `pdfid` para PDF, `capa` y `yara` para binarios, todo dentro de
`firejail` si se necesita ejecutar algo.

## 5. Persistencia cifrada en USB

1. Crea una partición adicional en el USB (o en un segundo disco) y cífrala:

   ```bash
   sudo cryptsetup luksFormat --type luks2 /dev/sdX2
   sudo cryptsetup open /dev/sdX2 persist
   sudo mkfs.ext4 -L persistence /dev/mapper/persist
   sudo mount /dev/mapper/persist /mnt && echo "/home union" | sudo tee /mnt/persistence.conf
   sudo umount /mnt && sudo cryptsetup close persist
   ```

2. Al arrancar, la ISO pide la contraseña del volumen y monta la persistencia.
3. `/home union` conserva solo los datos del usuario (casos, claves, evidencias) y sobrevive a los
   cambios de versión de la ISO. `/ union` conserva todo el sistema, pero debe recrearse al actualizar
   la ISO.

## 6. Instalación en disco

Desde la sesión en vivo, menú *8. Gobernanza y cumplimiento > Instalar en disco*. El asistente
(Calamares) permite borrar el disco con cifrado LUKS de todo el sistema, crea el usuario con los mismos
grupos que el usuario en vivo y deja el sistema con las actualizaciones de seguridad automáticas,
auditd y el cortafuegos activos. Tras instalar:

```bash
sudo cti-update            # paquetes Debian y herramientas (versiones fijadas en los manifiestos)
sudo cti-update --latest   # últimas versiones publicadas de las herramientas externas
cti-extras                 # Obsidian, Logseq, Signal, Element, draw.io, Zotero vía Flathub
```

## 7. Servicios apagados por defecto

Tor, Docker, OpenSnitch, ClamAV (freshclam), dnscrypt-proxy y USBGuard están instalados pero
apagados; el analista los activa de forma consciente:

```bash
sudo systemctl start tor
sudo systemctl start docker
sudo systemctl start opensnitch           # la interfaz aparece en la siguiente sesión
sudo freshclam && clamscan -r carpeta
sudo usbguard generate-policy > /etc/usbguard/rules.conf && sudo systemctl enable --now usbguard
```

## 8. Resolución de problemas

| Síntoma | Causa y solución |
|---|---|
| Una herramienta no aparece en `cti-smoke-test` | Revisa `/opt/cti/manifests/*-failed.txt`; `sudo cti-update pipx` (o `go`, `release`) la reintenta |
| GDM no arranca tras cambiar de ISO con persistencia `/ union` | El `/etc/passwd` antiguo enmascara al nuevo; recrea el volumen o usa `/home union` |
| El instalador rechaza el disco | Exige 30 GB libres; la imagen descomprimida ocupa unos 15 GB |
| El instalador tarda minutos en "recopilando información" | os-prober se bloquea con instalaciones antiguas en el disco; bórralas antes (`sudo sgdisk --zap-all /dev/sdX`) |
| GRUB pide contraseña y cae a su consola | Volúmenes LUKS2 con Argon2 no son compatibles con GRUB; el instalador usa LUKS1 por este motivo |
| OpenSCAP marca todas las reglas como no aplicables | trixie aún no incluye la guía SSG de Debian 13; usa el resultado de Lynis |
| Sin teclado ni USB en hardware real | USBGuard estaba activado con una política vacía; en la imagen actual está apagado por defecto |
| VirtualBox muy lento en Windows | Hyper-V o WSL2 activos obligan a VirtualBox a usar su modo de compatibilidad |
