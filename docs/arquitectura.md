# Arquitectura

## Por qué Debian + live-build

Se evaluaron cuatro opciones:

| Opción | Ventajas | Inconvenientes | Veredicto |
|---|---|---|---|
| Debian stable + live-build | Reproducible, archivo enorme, persistencia LUKS e instalador integrados, precedente en Kali/Parrot/Tails | Paquetes algo antiguos (se mitiga con pipx/Go/Docker) | **Elegida** |
| Ubuntu + Cubic / remastering | Fácil de empezar | Proceso manual, difícil de reproducir en CI | Descartada |
| Arch + archiso | Herramientas muy recientes | Rolling release: rompe con frecuencia, mal para uso profesional | Descartada |
| NixOS | Reproducibilidad total | Curva de aprendizaje alta, muchas herramientas OSINT sin empaquetar | Interesante para el futuro |

## Capas

```
┌─────────────────────────────────────────────────────────────┐
│ 5. Plataformas (Docker Compose, bajo demanda)               │  OpenCTI, MISP, ATT&CK Navigator
├─────────────────────────────────────────────────────────────┤
│ 4. Herramientas fuera de Debian (pipx, Go, releases GitHub) │  Maigret, subfinder, TruffleHog...
├─────────────────────────────────────────────────────────────┤
│ 3. Herramientas Debian por dominio (package-lists 20-40)    │  theHarvester, yara, tor...
├─────────────────────────────────────────────────────────────┤
│ 2. Capa OPSEC (includes.chroot + hooks)                     │  nftables, MAC random, Firefox endurecido
├─────────────────────────────────────────────────────────────┤
│ 1. Escritorio GNOME + menú por categorías (lista 10, hook 0400)│
├─────────────────────────────────────────────────────────────┤
│ 0. Debian 13 base + kernel + firmware (package-list 00)     │
└─────────────────────────────────────────────────────────────┘
```

Cada capa corresponde a un fichero en `live-build/config/package-lists/` o a un hook, de forma que se
puede eliminar o sustituir una capa sin tocar las demás.

## Flujo de construcción

1. `lb config` (vía `auto/config`) fija distribución, áreas del archivo, kernel, opciones de arranque.
2. `lb bootstrap` crea el chroot mínimo de Debian.
3. `lb chroot`: instala las listas de paquetes, copia `includes.chroot/` sobre el sistema y ejecuta los
   hooks en orden numérico:
   - `0100` instala herramientas Python con pipx (`/opt/cti/lib/install-pipx.sh`).
   - `0150` crea `/opt/cti/venv` con librerías CTI (stix2, pymisp) y un kernel de Jupyter.
   - `0200` compila herramientas Go.
   - `0250` descarga binarios oficiales de GitHub Releases (herramientas que no admiten `go install`).
   - `0300` habilita/deshabilita servicios, grupos del usuario, permisos, hardening y Flathub.
   - `0400` rasteriza el fondo, genera el menú de herramientas por categorías desde
     `/opt/cti/menu/tools.tsv` (lanzadores `.desktop`, menú XDG y carpetas de GNOME) y compila dconf.
4. `lb binary` genera el squashfs, el cargador de arranque y la ISO híbrida (BIOS + UEFI, grabable en USB).

Los fallos de herramientas de terceros (PyPI o GitHub caídos, dependencias rotas) no abortan el build:
quedan registrados en `/opt/cti/manifests/*-failed.txt` para revisarlos.

## Modos de uso

| Modo | Cómo | Para qué |
|---|---|---|
| Amnésico | Arrancar la ISO sin persistencia | Investigaciones sensibles, no queda rastro local |
| Persistente cifrado | USB con partición `persistence` cifrada con LUKS | Estación portátil con casos y credenciales |

Persistencia: con `persistence.conf` = `/ union` se guarda todo el sistema (incluidos `/etc/passwd` y la
configuración que live-config escribe al arrancar), así que **al cambiar de versión de la ISO hay que
recrear el volumen** o el sistema nuevo arrancará con ficheros de sistema antiguos (por ejemplo, GDM falla
porque falta el usuario `Debian-gdm`). Para conservar solo los datos entre versiones usa `/home union`
(casos, claves API, evidencias) y deja el sistema en modo amnésico.
| Instalado | Calamares desde la sesión en vivo (menú 8. Gobernanza > Instalar en disco), con cifrado LUKS; también el instalador de Debian en texto desde el menú de arranque | Estación de trabajo fija o máquina virtual. Requiere un disco de al menos 30 GB (recomendado 60 GB; el sistema descomprimido ocupa 15 GB) y 4 GB de RAM |

## Convenciones

- Scripts propios: prefijo `cti-`, POSIX sh, en `/usr/local/bin` (`cti-run` abre una herramienta de
  terminal desde el menú; `generate-menu.py` es la excepción en Python).
- Menú de herramientas: una línea por herramienta en `/opt/cti/menu/tools.tsv` (categoría, tipo,
  nombre, comando o `.desktop`, descripción). Añadir una herramienta = añadir una línea.
- Manifiestos de herramientas externas en `/opt/cti/manifests/` (fuente única de verdad para el build,
  para `cti-update` y para el smoke test). Los instaladores viven en `/opt/cti/lib/` y los hooks del
  build solo los invocan, de modo que un sistema instalado se actualiza con la misma lógica.
- Plantillas de documentos en `/opt/cti/templates/` (`cti-report`), catálogos públicos descargables con
  `cti-feeds` y claves API gestionadas con `cti-keys`.
- El smoke test vive en la imagen (`/usr/local/bin/cti-smoke-test`); `tests/smoke-test.sh` es un
  envoltorio para ejecutarlo desde el repositorio.
- Servicios con impacto en OPSEC o recursos (Tor, Docker, freshclam, dnscrypt) instalados pero
  **deshabilitados**: el analista los activa de forma consciente.

## Evolución prevista

- Metapaquetes Debian (`ctidistro-osint`, `ctidistro-cti`, `ctidistro-opsec`) servidos desde un
  repositorio APT propio, para actualizar el conjunto de herramientas sin regenerar la ISO.
- Variante "lab" con las plataformas preinstaladas y variante "lite" sin escritorio para servidores.
- Build reproducible bit a bit (`SOURCE_DATE_EPOCH`, versiones fijadas en todos los manifiestos).
