# CTI Distribution

Distribución GNU/Linux orientada a profesionales de **Cyber Threat Intelligence (CTI)** y **OSINT**.

No es "otro Kali": el foco no es la explotación, sino la **recolección pasiva, el análisis, la
gestión de evidencias y la seguridad operacional (OPSEC) del analista**.

## Principios de diseño

1. **Pasivo por defecto.** Las herramientas incluidas priorizan la recolección sin tocar al objetivo.
   No se incluyen frameworks de explotación.
2. **OPSEC integrada, no opcional.** Aleatorización de MAC, cortafuegos restrictivo, Tor y VPN
   listos, navegador endurecido sin telemetría, contenedores para identidades (sock puppets).
3. **Evidencia con trazabilidad.** Utilidades para hashear, sellar en el tiempo y registrar la
   cadena de custodia de todo lo que se recolecta.
4. **Reproducible.** La ISO se genera desde este repositorio con `live-build` en CI. Nada se
   configura a mano sobre una imagen.
5. **Estable y mantenible.** Base Debian *stable*; las herramientas que cambian rápido se
   instalan aisladas (pipx / Go / Docker) para no romper el sistema base.

## Decisiones principales

| Aspecto | Decisión | Motivo |
|---|---|---|
| Base | Debian 13 "trixie" | Estable, enorme archivo de paquetes, mismo enfoque que Kali, Parrot y Tails |
| Constructor | `live-build` | Estándar Debian, reproducible, soporta persistencia cifrada e instalador |
| Escritorio | GNOME (Wayland) con dock inferior, Arc Menu y tema oscuro | Aspecto limpio y profesional; menú de herramientas por categorías al estilo Kali |
| Herramientas Python | `pipx` (entornos aislados en `/opt/pipx`) | Evita conflictos con el Python del sistema |
| Herramientas Go | compiladas en build, binarios en `/usr/local/bin` | No existen en Debian, se fijan versiones |
| Plataformas pesadas (OpenCTI, MISP, ATT&CK Navigator) | Docker Compose bajo `/opt/cti/stacks` | No pueden empaquetarse razonablemente; se levantan bajo demanda |
| Persistencia | Modo amnésico por defecto, persistencia LUKS opcional en USB, instalador disponible | Cubre investigación sensible y uso como estación de trabajo |

Documentación de diseño en [`docs/`](docs/):

- [`docs/arquitectura.md`](docs/arquitectura.md): capas, perfiles y flujo de construcción.
- [`docs/catalogo-herramientas.md`](docs/catalogo-herramientas.md): herramientas por categoría, origen y licencia.
- [`docs/opsec.md`](docs/opsec.md): modelo de amenazas del analista y controles.
- [`docs/roadmap.md`](docs/roadmap.md): fases del proyecto.

## Estructura del repositorio

```
.
├── docs/                     Diseño y documentación
├── live-build/
│   ├── auto/                 Parámetros de lb config / build / clean
│   └── config/
│       ├── package-lists/    Paquetes Debian por capa (*.list.chroot)
│       ├── hooks/normal/     Scripts ejecutados dentro del chroot durante el build
│       │                     (pipx, venv, Go, servicios, menú de herramientas y escritorio)
│       └── includes.chroot/  Ficheros copiados tal cual al sistema (configs, scripts, manifiestos)
├── tools/stacks/             Despliegue de plataformas CTI vía Docker Compose
├── tests/                    Comprobación de paquetes y smoke tests
└── .github/workflows/        CI: validación en cada push, build de ISO bajo demanda
```

## Construcción local

Requisitos: Debian 13 (o contenedor `debian:trixie` con `--privileged`), `live-build`, unos 15 GB
de disco y acceso a red.

```bash
sudo apt-get install live-build
make build          # genera live-build/ctidistro-*.iso
make clean          # limpia artefactos
make check          # valida que todos los paquetes existen en el archivo de Debian
```

Prueba rápida en QEMU:

```bash
qemu-system-x86_64 -m 4096 -enable-kvm -cdrom live-build/*.iso -boot d
```

Usuario en vivo: `analyst` (contraseña `live`, con `sudo` sin contraseña). Teclado `es`, locale `es_ES.UTF-8`.

## Escritorio y menú de herramientas

GNOME con dock inferior (Dash to Dock), Arc Menu a la izquierda del panel, botones de ventana a la
izquierda, tipografía Inter, iconos Papirus y tema oscuro. Los ajustes por defecto están en
`live-build/config/includes.chroot/etc/dconf/db/local.d/00-ctidistro`.

Las herramientas se ordenan por funcionalidad (1. Reconocimiento, 2. Personas y redes sociales,
3. Ficheros, medios y metadatos, 4. Análisis CTI, 5. OPSEC y anonimato, 6. Evidencias e informes,
7. Plataformas), tanto en Arc Menu como en carpetas de la parrilla de aplicaciones. El menú se genera
en el build a partir de un único manifiesto, `live-build/config/includes.chroot/opt/cti/menu/tools.tsv`;
cada herramienta de terminal se abre con `cti-run`, que muestra su ayuda y deja un shell listo.

## Para responsables de seguridad y gobernanza

Además de la recolección OSINT/CTI, la distribución cubre el trabajo de un responsable de seguridad o
analista de ciberinteligencia con enfoque de gobernanza (no ofensivo):

| Necesidad | Qué incluye |
|---|---|
| Cumplimiento y riesgo | CISO Assistant (ISO 27001, NIS2, DORA, ENS, CIS, NIST CSF) bajo demanda; `trestle` (OSCAL); plantillas de registro de riesgos, política, auditoría y proveedores (`cti-report`) |
| Auditoría defensiva | Lynis, OpenSCAP (guías SSG), `testssl.sh`, `ssh-audit`, `checkdmarc`, `dnsviz`; `cti-selfaudit` contra la propia estación |
| Vulnerabilidades y SBOM | Trivy, Grype, Syft, osv-scanner, cve-bin-tool, calculadora CVSS; catálogos KEV, EPSS, CWE, CAPEC con `cti-feeds` |
| Análisis de inteligencia | Plantillas ACH, escala Admiralty, niveles de confianza, TLP/PAP; `harpoon`, `unfurl`, VisiData, lnav, JupyterLab |
| Evidencias con valor probatorio | `cti-evidence url` (PNG, PDF, HTML, WARC), sello de tiempo OpenTimestamps, pywb |
| Incidentes y casos | DFIR-IRIS, Timesketch, playbooks NIST SP 800-61; GoPhish para concienciación |
| Estación endurecida | Secure Boot, sysctl, auditd, actualizaciones automáticas, AppArmor, instalador Calamares con cifrado |

Comandos propios: `cti-netcheck`, `cti-evidence`, `cti-keys`, `cti-feeds`, `cti-report`, `cti-selfaudit`,
`cti-update`, `cti-extras`, `cti-smoke-test`, `cti-run`.

## Estado

Fase 0 (definición) completada. Fase 1 (primera ISO reproducible) en curso. Ver `docs/roadmap.md`.

## Licencia

Pendiente de decidir. Recomendación: GPL-3.0 para los scripts y configuración del proyecto; cada
herramienta incluida conserva su propia licencia (ver catálogo).
