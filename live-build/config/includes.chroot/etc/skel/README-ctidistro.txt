CTI Distribution - guia rapida
==============================

Antes de investigar:
  cti-netcheck               Comprueba IP publica, Tor, DNS y MAC.
  sudo systemctl start tor   Arranca Tor (apagado por defecto).

Durante la investigacion:
  cti-evidence <fichero> "nota"   Hashea y registra el fichero en ~/Evidence/manifest.csv
  Firefox incluye Multi-Account Containers para separar identidades.

Plataformas (requieren Docker: sudo systemctl start docker):
  /opt/cti/stacks/           OpenCTI, MISP, ATT&CK Navigator via docker compose.

Herramientas que fallaron durante la construccion de la imagen (si las hay):
  /opt/cti/manifests/*-failed.txt

Scripting y notebooks:
  cti-python                 Python con stix2, pymisp, taxii2-client, pandas...
  jupyter notebook           Kernel "Python (CTI)"
