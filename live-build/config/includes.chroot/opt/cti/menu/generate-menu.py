#!/usr/bin/python3
"""Genera el menú de herramientas de CTI Distribution a partir de /opt/cti/menu/tools.tsv.

Produce:
  /usr/share/applications/cti-*.desktop          lanzadores de herramientas de terminal y URLs
  /usr/share/desktop-directories/cti-*.directory categorías del menú
  /etc/xdg/menus/{applications,gnome-applications}-merged/ctidistro.menu  menú XDG por categorías
  /etc/dconf/db/local.d/10-cti-menu              carpetas de la parrilla de aplicaciones de GNOME
Se ejecuta en el chroot durante el build (hook 0400) y puede relanzarse en un sistema instalado
(seguido de "dconf update").
"""
import re
import shlex
import sys
from pathlib import Path

MANIFEST = Path("/opt/cti/menu/tools.tsv")
APPS = Path("/usr/share/applications")
DIRS = Path("/usr/share/desktop-directories")
MENUS = [Path("/etc/xdg/menus/applications-merged"), Path("/etc/xdg/menus/gnome-applications-merged")]
DCONF = Path("/etc/dconf/db/local.d/10-cti-menu")

# id -> (nombre visible, icono, categoría XDG)
CATEGORIES = {
    "recon": ("1. Reconocimiento", "network-workgroup", "X-CTI-Recon"),
    "people": ("2. Personas y redes sociales", "system-users", "X-CTI-People"),
    "files": ("3. Ficheros, medios y metadatos", "image-x-generic", "X-CTI-Files"),
    "cti": ("4. Análisis CTI", "security-high", "X-CTI-Analysis"),
    "opsec": ("5. OPSEC y anonimato", "preferences-desktop-privacy", "X-CTI-Opsec"),
    "evidence": ("6. Evidencias e informes", "x-office-document", "X-CTI-Evidence"),
    "platforms": ("7. Plataformas", "network-server", "X-CTI-Platforms"),
    "governance": ("8. Gobernanza y cumplimiento", "security-medium", "X-CTI-Governance"),
}
KINDS = ("help", "term", "url", "desktop")


def slug(name):
    return re.sub(r"[^a-z0-9]+", "-", name.lower()).strip("-")


def read_manifest():
    entries = []
    for lineno, raw in enumerate(MANIFEST.read_text(encoding="utf-8").splitlines(), 1):
        if not raw.strip() or raw.lstrip().startswith("#"):
            continue
        parts = [p.strip() for p in raw.split("\t")]
        if len(parts) != 5:
            sys.exit(f"{MANIFEST}:{lineno}: se esperaban 5 campos separados por tabulador")
        cat, kind, name, target, comment = parts
        if cat not in CATEGORIES:
            sys.exit(f"{MANIFEST}:{lineno}: categoría desconocida {cat!r}")
        if kind not in KINDS:
            sys.exit(f"{MANIFEST}:{lineno}: tipo desconocido {kind!r}")
        entries.append((cat, kind, name, target, comment))
    return entries


def desktop_file(cat, kind, name, target, comment):
    xdg_cat = CATEGORIES[cat][2]
    if kind == "help":
        exec_line, icon = "cti-run " + target, "utilities-terminal"
    elif kind == "term":
        exec_line, icon = "gnome-terminal --title=%s -- %s" % (shlex.quote(name), target), "utilities-terminal"
    else:  # url
        exec_line, icon = "xdg-open " + target, "web-browser"
    return "\n".join([
        "[Desktop Entry]",
        "Type=Application",
        "Version=1.0",
        f"Name={name}",
        f"Comment={comment}",
        f"Exec={exec_line}",
        f"Icon={icon}",
        "Terminal=false",
        f"Categories={xdg_cat};",
        "X-CTI-Generated=true",
        "",
    ])


def main():
    entries = read_manifest()
    APPS.mkdir(parents=True, exist_ok=True)
    DIRS.mkdir(parents=True, exist_ok=True)
    for old in APPS.glob("cti-*.desktop"):
        if "X-CTI-Generated=true" in old.read_text(encoding="utf-8", errors="replace"):
            old.unlink()

    by_cat = {cat: [] for cat in CATEGORIES}
    for cat, kind, name, target, comment in entries:
        if kind == "desktop":
            filename = target
        else:
            filename = f"cti-{slug(name)}.desktop"
            (APPS / filename).write_text(desktop_file(cat, kind, name, target, comment), encoding="utf-8")
        by_cat[cat].append(filename)

    menu = [
        '<!DOCTYPE Menu PUBLIC "-//freedesktop//DTD Menu 1.0//EN"',
        ' "http://www.freedesktop.org/standards/menu-spec/menu-1.0.dtd">',
        "<Menu>",
        "  <Name>Applications</Name>",
    ]
    dconf = [
        "# Generado por /opt/cti/menu/generate-menu.py a partir de tools.tsv. No editar a mano.",
        "[org/gnome/desktop/app-folders]",
        "folder-children=[%s]" % ", ".join(f"'cti-{c}'" for c in CATEGORIES),
        "",
    ]
    for cat, (label, icon, xdg_cat) in CATEGORIES.items():
        (DIRS / f"cti-{cat}.directory").write_text(
            f"[Desktop Entry]\nType=Directory\nName={label}\nIcon={icon}\n", encoding="utf-8")
        menu += [
            "  <Menu>",
            f"    <Name>{label}</Name>",
            f"    <Directory>cti-{cat}.directory</Directory>",
            "    <Include>",
            f"      <Category>{xdg_cat}</Category>",
        ]
        menu += [f"      <Filename>{f}</Filename>" for f in by_cat[cat]]
        menu += ["    </Include>", "  </Menu>"]
        dconf += [
            f"[org/gnome/desktop/app-folders/folders/cti-{cat}]",
            f"name='{label}'",
            "translate=false",
            f"categories=['{xdg_cat}']",
            "apps=[%s]" % ", ".join(f"'{f}'" for f in by_cat[cat]),
            "",
        ]
    menu.append("</Menu>")
    for d in MENUS:
        d.mkdir(parents=True, exist_ok=True)
        (d / "ctidistro.menu").write_text("\n".join(menu) + "\n", encoding="utf-8")
    DCONF.parent.mkdir(parents=True, exist_ok=True)
    DCONF.write_text("\n".join(dconf), encoding="utf-8")
    print(f"Menú generado: {len(entries)} herramientas en {len(CATEGORIES)} categorías")


if __name__ == "__main__":
    main()
