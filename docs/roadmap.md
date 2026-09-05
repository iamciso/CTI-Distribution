# Roadmap

## Fase 0 - Definición (hecha)

- [x] Elegir base (Debian 13) y constructor (live-build).
- [x] Principios: pasivo por defecto, OPSEC integrada, evidencia trazable, reproducible.
- [x] Catálogo inicial de herramientas con origen y licencia.
- [x] Estructura del repositorio y CI de validación.

## Fase 1 - Primera ISO reproducible

- [x] CI en verde: todos los paquetes existen en trixie.
- [x] Primer build completo con `workflow_dispatch`; revisar `pipx-failed.txt` y `go-failed.txt`.
- [x] Arranque en QEMU/VirtualBox: escritorio, red, `cti-netcheck`, `cti-smoke-test`.
- [x] Fijar versiones en `pipx-tools.txt`, `go-tools.txt` y `release-tools.txt` (`cti-update --latest` las ignora).
- [x] Probar persistencia LUKS (VirtualBox, disco cifrado con `persistence.conf`).
- [ ] Probar el instalador (Calamares con cifrado de disco).
- [ ] Publicar `v0.1.0` con SHA256SUMS.

## Fase 1b - Gobernanza y análisis (hecha en la primera iteración)

- [x] Capa de gobernanza: Lynis, OpenSCAP, testssl.sh, ssh-audit, checkdmarc, dnsviz, trestle (OSCAL),
      cve-bin-tool, Trivy, Grype, Syft, osv-scanner.
- [x] Evidencias con valor probatorio: `cti-evidence url` (PNG, PDF, HTML, WARC) y sello OpenTimestamps; pywb.
- [x] Plantillas y reporting: `cti-report` (informe de inteligencia, ACH, registro de riesgos, auditoría,
      política, playbook, cuestionario de proveedores) con pandoc y XeLaTeX.
- [x] `cti-keys`, `cti-feeds`, `cti-update`, `cti-selfaudit`, `cti-extras` (Flathub) y aviso de bienvenida.
- [x] Plataformas GRC y de casos bajo demanda: CISO Assistant, DFIR-IRIS, Timesketch, GoPhish, Miniflux.
- [x] Hardening de la estación: sysctl, auditd, unattended-upgrades, Secure Boot, USBGuard a demanda.
- [ ] Imágenes OVA y qcow2 publicadas junto a la ISO; variantes analista / gobernanza / lite (metapaquetes).
- [x] SBOM (SPDX y CycloneDX) e informe de vulnerabilidades (Grype) de cada build; firma GPG de SHA256SUMS si existe el secreto `GPG_PRIVATE_KEY`.
- [x] Manual de usuario con flujos de trabajo (`docs/manual.md`).

## Fase 2 - Capa OPSEC completa

- [ ] `cti-netprofile` (directo / vpn / tor) con kill switch en nftables.
- [ ] dnscrypt-proxy configurado y activable con un comando.
- [ ] Perfiles de Firefox por identidad y lanzador de "persona".
- [ ] Perfiles Firejail para las herramientas que abren ficheros externos.
- [ ] CyberChef offline y ATT&CK Navigator sin Docker.

## Fase 3 - Experiencia de analista

- [x] Menú organizado por categorías (Reconocimiento, Personas, Ficheros, CTI, OPSEC, Evidencias,
      Plataformas) generado desde `tools.tsv`; escritorio GNOME con aspecto limpio.
- [ ] Plantillas de caso: estructura de carpetas, informe Markdown con pandoc, matriz ACH, escala Admiralty.
- [ ] `cti-evidence` con sellado de tiempo externo (OpenTimestamps) y exportación a STIX.
- [ ] Notas: evaluar Obsidian/Joplin vía Flatpak.
- [ ] Manual de usuario en `docs/` y sitio web del proyecto.

## Fase 4 - Mantenimiento y comunidad

- [ ] Repositorio APT propio con metapaquetes `ctidistro-*`.
- [ ] Builds nocturnos y pruebas automáticas de arranque en QEMU en CI.
- [ ] Política de inclusión de herramientas y proceso de contribución.
- [ ] Variantes: "lite" (sin escritorio) y "lab" (plataformas preinstaladas).
