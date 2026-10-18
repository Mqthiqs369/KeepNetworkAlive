#!/bin/bash
# Install netwatch: copies the script and systemd unit, then enables and starts the service.

# Strict mode : the script stops as soon as something goes wrong.
set -euo pipefail


# Stop if not running as sudoer
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root: sudo $0" >&2
    exit 1
fi

# Work from the directory this script lives in, wherever it's called from
SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check for presence of needed files
for f in netwatch.sh netwatch.service; do
    if [ ! -f "$SRC_DIR/$f" ]; then
        echo "Missing $f in $SRC_DIR" >&2
            exit 1
    fi
done

echo "Installing netwatch.sh to /usr/local/bin/"
install -m 755 "$SRC_DIR/netwatch.sh" /usr/local/bin/netwatch.sh

echo "Installing netwatch.service to /etc/systemd/system/"
install -m 644 "$SRC_DIR/netwatch.service" /etc/systemd/system/netwatch.service

echo "Reloading systemd and enabling service"
systemctl daemon-reload
systemctl enable --now netwatch.service

# A plain enable --now won't pick up a new script if the service was already running
systemctl restart netwatch.service

echo
systemctl --no-pager status netwatch.service || true
echo
echo "Done. Follow logs with: journalctl -u netwatch -f"
