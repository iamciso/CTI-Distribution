# Roadmap

## Fase 0 - Definición (hecha)

- [x] Elegir base (Debian 13) y constructor (live-build).
- [x] Principios: pasivo por defecto, OPSEC integrada, evidencia trazable, reproducible.
- [x] Catálogo inicial de herramientas con origen y licencia.
- [x] Estructura del repositorio y CI de validación.

## Fase 1 - Primera ISO reproducible

- [x] CI en verde: todos los paquetes existen en trixie.
- [ ] Primer build completo con `workflow_dispatch`; revisar `pipx-failed.txt` y `go-failed.txt`.
- [ ] Arranque en QEMU/VirtualBox: escritorio, red, `cti-netcheck`, `tests/smoke-test.sh`.
- [ ] Fijar versiones en `pipx-tools.txt` y `go-tools.txt`.
- [ ] Probar persistencia LUKS en USB y el instalador.
- [ ] Publicar `v0.1.0` con SHA256SUMS.

## Fase 2 - Capa OPSEC completa

- [ ] `cti-netprofile` (directo / vpn / tor) con kill switch en nftables.
- [ ] dnscrypt-proxy configurado y activable con un comando.
- [ ] Perfiles de Firefox por identidad y lanzador de "persona".
- [ ] Perfiles Firejail para las herramientas que abren ficheros externos.
- [ ] CyberChef offline y ATT&CK Navigator sin Docker.

## Fase 3 - Experiencia de analista

- [ ] Menú XFCE organizado por categorías (Reconocimiento, Personas, Ficheros, CTI, OPSEC, Reporting).
- [ ] Plantillas de caso: estructura de carpetas, informe Markdown con pandoc, matriz ACH, escala Admiralty.
- [ ] `cti-evidence` con sellado de tiempo externo (OpenTimestamps) y exportación a STIX.
- [ ] Notas: evaluar Obsidian/Joplin vía Flatpak.
- [ ] Manual de usuario en `docs/` y sitio web del proyecto.

## Fase 4 - Mantenimiento y comunidad

- [ ] Repositorio APT propio con metapaquetes `ctidistro-*`.
- [ ] Builds nocturnos y pruebas automáticas de arranque en QEMU en CI.
- [ ] Política de inclusión de herramientas y proceso de contribución.
- [ ] Variantes: "lite" (sin escritorio) y "lab" (plataformas preinstaladas).
