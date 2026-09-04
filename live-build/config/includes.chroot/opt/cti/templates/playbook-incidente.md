---
title: "Playbook de respuesta a incidentes: <tipo de incidente>"
author: "{{ANALISTA}}"
date: "{{FECHA}}"
tlp: "TLP:AMBER"
---

# Ficha

| Campo | Valor |
|-------|-------|
| Tipo | Phishing / ransomware / fuga de datos / compromiso de cuenta / DDoS |
| Severidad de referencia | Crítica / Alta / Media / Baja |
| Responsable del playbook | |
| Obligaciones de notificación | AEPD (72 h, RGPD art. 33), CSIRT de referencia (NIS2: alerta temprana 24 h, notificación 72 h), clientes/contratos |

# Fases (NIST SP 800-61 r3)

## 1. Preparación

Contactos, herramientas, accesos, plantillas de comunicación, criterios de severidad.

## 2. Detección y análisis

- Fuentes de detección y triaje inicial.
- Preguntas clave: ¿qué, cuándo, dónde, cómo, alcance?
- Registro de evidencias con `cti-evidence` (hash, hora UTC, cadena de custodia).

## 3. Contención, erradicación y recuperación

| Paso | Acción | Responsable | Evidencia |
|------|--------|-------------|-----------|
| 1 | Contención inmediata (aislar, bloquear IOCs, revocar credenciales) | | |
| 2 | Erradicación | | |
| 3 | Recuperación y verificación | | |

## 4. Actividad posterior

Lecciones aprendidas (en 10 días), métricas (tiempo de detección, contención, recuperación), mejoras de controles, actualización de este playbook.

# Comunicación

| Audiencia | Canal | Cuándo | Quién |
|-----------|-------|--------|-------|
| Dirección | | | |
| Personas afectadas | | | |
| Autoridades | | | |
