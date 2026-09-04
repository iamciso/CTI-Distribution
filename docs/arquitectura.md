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
│ 4. Herramientas fuera de Debian (pipx en /opt/pipx, Go)     │  SpiderFoot, Maigret, subfinder...
├─────────────────────────────────────────────────────────────┤
│ 3. Herramientas Debian por dominio (package-lists 20-40)    │  theHarvester, yara, tor...
├─────────────────────────────────────────────────────────────┤
│ 2. Capa OPSEC (includes.chroot + hooks)                     │  nftables, MAC random, Firefox endurecido
├─────────────────────────────────────────────────────────────┤
│ 1. Escritorio XFCE (package-list 10)                        │
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
   - `0100` instala herramientas Python con pipx.
   - `0150` crea `/opt/cti/venv` con librerías CTI (stix2, pymisp) y un kernel de Jupyter.
   - `0200` compila herramientas Go.
   - `0300` habilita/deshabilita servicios, grupos del usuario, permisos.
4. `lb binary` genera el squashfs, el cargador de arranque y la ISO híbrida (BIOS + UEFI, grabable en USB).

Los fallos de herramientas de terceros (PyPI o GitHub caídos, dependencias rotas) no abortan el build:
quedan registrados en `/opt/cti/manifests/*-failed.txt` para revisarlos.

## Modos de uso

| Modo | Cómo | Para qué |
|---|---|---|
| Amnésico | Arrancar la ISO sin persistencia | Investigaciones sensibles, no queda rastro local |
| Persistente cifrado | USB con partición `persistence` cifrada con LUKS | Estación portátil con casos y credenciales |
| Instalado | Instalador de Debian incluido en el menú de arranque | Estación de trabajo fija o máquina virtual |

## Convenciones

- Scripts propios: prefijo `cti-`, POSIX sh, en `/usr/local/bin`.
- Manifiestos de herramientas externas en `/opt/cti/manifests/` (fuente única de verdad para el build y
  para el smoke test).
- El smoke test vive en la imagen (`/usr/local/bin/cti-smoke-test`); `tests/smoke-test.sh` es un
  envoltorio para ejecutarlo desde el repositorio.
- Servicios con impacto en OPSEC o recursos (Tor, Docker, freshclam, dnscrypt) instalados pero
  **deshabilitados**: el analista los activa de forma consciente.

## Evolución prevista

- Metapaquetes Debian (`ctidistro-osint`, `ctidistro-cti`, `ctidistro-opsec`) servidos desde un
  repositorio APT propio, para actualizar el conjunto de herramientas sin regenerar la ISO.
- Variante "lab" con las plataformas preinstaladas y variante "lite" sin escritorio para servidores.
- Build reproducible bit a bit (`SOURCE_DATE_EPOCH`, versiones fijadas en todos los manifiestos).
