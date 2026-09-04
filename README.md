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
| Escritorio | XFCE | Ligero para arranque en vivo y máquinas virtuales |
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

Usuario en vivo: `analyst` (sin contraseña, con `sudo`). Teclado `es`, locale `es_ES.UTF-8`.

## Estado

Fase 0 (definición) completada. Fase 1 (primera ISO reproducible) en curso. Ver `docs/roadmap.md`.

## Licencia

Pendiente de decidir. Recomendación: GPL-3.0 para los scripts y configuración del proyecto; cada
herramienta incluida conserva su propia licencia (ver catálogo).
