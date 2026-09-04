# OPSEC del analista

## Modelo de amenazas

El analista de CTI/OSINT investiga a actores que pueden tener capacidad de contraespionaje. Los
riesgos que la distribución debe reducir:

1. **Atribución del analista**: el objetivo descubre quién le investiga (IP corporativa, MAC,
   huella del navegador, cuentas reales).
2. **Contaminación de identidades**: mezclar una persona ficticia con la identidad real en el mismo
   perfil de navegador o sesión.
3. **Exposición de la organización**: fugas de DNS, telemetría del sistema o del navegador, servicios
   escuchando en red.
4. **Compromiso del puesto**: abrir ficheros maliciosos recolectados durante la investigación.
5. **Pérdida o incautación del equipo**: datos de casos en claro.
6. **Integridad de la evidencia**: no poder demostrar qué se recolectó, cuándo y sin alteraciones.

## Controles incluidos

| Riesgo | Control | Dónde |
|---|---|---|
| 1, 3 | MAC aleatoria por conexión y en escaneo Wi-Fi | `etc/NetworkManager/conf.d/99-mac-randomization.conf` |
| 1, 3 | Firefox sin telemetría, sin cuenta, DoH, protección de rastreo, uBlock | `etc/firefox-esr/policies/policies.json` |
| 3 | nftables: todo lo entrante cerrado | `etc/nftables.conf` |
| 3 | Tor, Docker/containerd, freshclam, dnscrypt y OpenSnitch instalados pero apagados | hook `0300` |
| 1 | `cti-netcheck` verifica IP pública, salida por Tor y resolvedor DNS antes de empezar | `usr/local/bin/cti-netcheck` |
| 2 | Multi-Account Containers para separar identidades; Tor Browser para la máxima separación | Firefox / torbrowser-launcher |
| 4 | Firejail y AppArmor para abrir ficheros sospechosos; triaje con yara/oletools/capa antes de abrir | listas 30 y 40 |
| 5 | Modo amnésico por defecto; persistencia solo cifrada con LUKS; zuluCrypt | `auto/config` |
| 6 | `cti-evidence`: SHA-256, marca UTC, analista y nota en manifiesto CSV | `usr/local/bin/cti-evidence` |

## Perfiles de red (fase 2)

Se prevé un selector `cti-netprofile` con tres modos:

- **directo**: sin cambios, para consultar fuentes propias o de confianza.
- **vpn**: obliga a que todo el tráfico salga por la interfaz WireGuard/OpenVPN (kill switch en nftables).
- **tor**: enrutado transparente por Tor con bloqueo de todo lo demás, al estilo Tails/Whonix. Aviso: muchas
  plataformas bloquean nodos de salida; para redes sociales suele ser mejor VPN + navegador aislado.

## Reglas operativas que la herramienta no puede sustituir

- Nunca iniciar sesión con cuentas reales en el mismo navegador que las personas ficticias.
- Dar de alta las personas ficticias desde la red y dispositivo que se usará después con ellas.
- Registrar cada evidencia en el momento de recolectarla, no al final del día.
- Limpiar metadatos (`mat2`) de todo lo que se comparta fuera del equipo.
- Mantener el cumplimiento legal: RGPD/LOPDGDD para datos personales, términos de servicio de las
  plataformas y autorización documentada del cliente para cada investigación.
