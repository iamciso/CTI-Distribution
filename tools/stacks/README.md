# Plataformas CTI (Docker Compose)

Las plataformas grandes no se empaquetan en la ISO. Se despliegan bajo demanda con Docker Compose
usando los repositorios oficiales de cada proyecto:

| Plataforma | Uso | Repositorio |
|---|---|---|
| OpenCTI | Gestión de conocimiento CTI, STIX 2.1 nativo, conectores | OpenCTI-Platform/docker |
| MISP | Compartición de indicadores, feeds, taxonomías | MISP/misp-docker |
| ATT&CK Navigator | Mapeo de técnicas ATT&CK sin conexión | mitre-attack/attack-navigator |
| SpiderFoot | Automatización OSINT con interfaz web (`http://127.0.0.1:5001`) | smicallef/spiderfoot |
| CISO Assistant | GRC: ISO 27001, NIS2, DORA, ENS, CIS, NIST CSF; riesgos, controles y evidencias | intuitem/ciso-assistant-community |
| DFIR-IRIS | Gestión colaborativa de casos e incidentes | dfir-iris/iris-web |
| Timesketch | Líneas de tiempo forenses colaborativas | google/timesketch |
| GoPhish | Campañas de concienciación frente al phishing | gophish/gophish |
| Miniflux | Agregador RSS de fuentes de amenazas y CERTs | miniflux/miniflux (imagen Docker) |

```bash
sudo systemctl start docker
sudo /opt/cti/stacks/fetch-stacks.sh     # o: tools/stacks/fetch-stacks.sh ~/stacks
```

SpiderFoot no se instala con pipx: su última versión (4.0, 2022) fija dependencias que no
compilan en el Python 3.13 de trixie, así que se construye su imagen oficial (Python 3.8 en Alpine).

Requisitos orientativos: OpenCTI necesita 8 GB de RAM (Elasticsearch/OpenSearch); MISP funciona
con 4 GB. En modo live sin persistencia los datos se pierden al apagar: usa persistencia LUKS o
instalación en disco para trabajo real.

Candidatas para fases posteriores: TheHive + Cortex (gestión de casos), Timesketch (líneas de
tiempo), IntelOwl (enriquecimiento), Yeti.
