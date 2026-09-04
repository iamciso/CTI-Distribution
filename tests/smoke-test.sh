#!/bin/sh
# Envoltorio: el smoke test vive en la imagen como /usr/local/bin/cti-smoke-test para poder
# ejecutarlo directamente en el sistema arrancado. Este fichero lo lanza desde el repositorio.
exec "$(dirname "$0")/../live-build/config/includes.chroot/usr/local/bin/cti-smoke-test" "$@"
