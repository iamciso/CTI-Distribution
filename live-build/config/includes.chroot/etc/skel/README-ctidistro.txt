CTI Distribution - guia rapida
==============================

Antes de investigar:
  cti-netcheck               Comprueba IP publica, Tor, DNS y MAC.
  sudo systemctl start tor   Arranca Tor (apagado por defecto).

Durante la investigacion:
  cti-evidence <fichero> "nota"   Hashea y registra el fichero en ~/Evidence/manifest.csv
  Firefox incluye Multi-Account Containers para separar identidades.

Plataformas (requieren Docker: sudo systemctl start docker):
  /opt/cti/stacks/           OpenCTI, MISP, ATT&CK Navigator y SpiderFoot via Docker.

Comprobar la imagen:
  cti-smoke-test             Verifica que las herramientas clave estan instaladas.
  /opt/cti/manifests/*-failed.txt   Herramientas que fallaron al construir la imagen (si las hay).
  Menu de aplicaciones: herramientas por categorias (1. Reconocimiento ... 7. Plataformas).

Scripting y notebooks:
  cti-python                 Python con stix2, pymisp, taxii2-client, pandas...
  jupyter notebook           Kernel "Python (CTI)"
