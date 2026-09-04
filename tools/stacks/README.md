# Plataformas CTI (Docker Compose)

Las plataformas grandes no se empaquetan en la ISO. Se despliegan bajo demanda con Docker Compose
usando los repositorios oficiales de cada proyecto:

| Plataforma | Uso | Repositorio |
|---|---|---|
| OpenCTI | Gestión de conocimiento CTI, STIX 2.1 nativo, conectores | OpenCTI-Platform/docker |
| MISP | Compartición de indicadores, feeds, taxonomías | MISP/misp-docker |
| ATT&CK Navigator | Mapeo de técnicas ATT&CK sin conexión | mitre-attack/attack-navigator |

```bash
sudo systemctl start docker
sudo /opt/cti/stacks/fetch-stacks.sh     # o: tools/stacks/fetch-stacks.sh ~/stacks
```

Requisitos orientativos: OpenCTI necesita 8 GB de RAM (Elasticsearch/OpenSearch); MISP funciona
con 4 GB. En modo live sin persistencia los datos se pierden al apagar: usa persistencia LUKS o
instalación en disco para trabajo real.

Candidatas para fases posteriores: TheHive + Cortex (gestión de casos), Timesketch (líneas de
tiempo), IntelOwl (enriquecimiento), Yeti.
