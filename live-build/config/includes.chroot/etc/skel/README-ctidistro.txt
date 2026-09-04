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

Gobernanza y reporting:
  cti-keys set NOMBRE        Guarda una clave API (Shodan, VirusTotal, Censys...).
  cti-feeds                  Descarga ATT&CK, KEV, EPSS, CWE, NIST CSF y 800-53 en ~/cti-data.
  cti-report list            Plantillas (informe, ACH, riesgos, auditoria, politica, playbook).
  cti-report build doc.md    Genera PDF/DOCX con pandoc.
  sudo cti-selfaudit         Lynis + OpenSCAP contra esta estacion (informes en ~/Audit).
  cti-evidence url <URL>     Captura PNG, PDF, HTML y WARC con hash y sello OpenTimestamps.
  sudo cti-update            Actualiza paquetes y herramientas (sistemas instalados).
  cti-extras                 Obsidian, Signal, Element, draw.io... via Flathub.
  Instalar en disco: menu 8. Gobernanza > Instalar en disco (Calamares, con cifrado).

Scripting y notebooks:
  cti-python                 Python con stix2, pymisp, taxii2-client, pandas...
  jupyter notebook           Kernel "Python (CTI)"
