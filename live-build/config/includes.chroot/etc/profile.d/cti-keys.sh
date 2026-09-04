# Carga las claves API guardadas con cti-keys (~/.config/cti/keys.env) en cada shell de login.
if [ -r "${XDG_CONFIG_HOME:-$HOME/.config}/cti/keys.env" ]; then
    set -a
    # shellcheck disable=SC1090
    . "${XDG_CONFIG_HOME:-$HOME/.config}/cti/keys.env"
    set +a
fi
