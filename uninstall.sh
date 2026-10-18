#!/bin/bash
# Uninstall netwatch: stops and disables the service, then removes the installed files.

# Strict mode : stops on failure
set -euo pipefail

# Requires to be run as sudoer
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root: sudo $0" >&2
    exit 1
fi
 
echo "Stopping and disabling netwatch.service"
# Don't fail if the service is already stopped, disabled, or was never installed
systemctl disable --now netwatch.service 2>/dev/null || true
 
echo "Removing installed files"
rm -f /etc/systemd/system/netwatch.service
rm -f /usr/local/bin/netwatch.sh
 
echo "Reloading systemd"
systemctl daemon-reload
# Clear any leftover "failed" state so the unit disappears from systemctl listings
systemctl reset-failed netwatch.service 2>/dev/null || true
 
echo "Done. netwatch has been removed."
 
