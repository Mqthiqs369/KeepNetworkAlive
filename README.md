# netwatch

A tiny watchdog that keeps a flaky network connection alive.

It pings your gateway every 30 seconds. If the gateway stops answering, it restarts networking and keeps going. That's it.

## Why

One of my devices runs on an Intel Dual Band Wireless-AC 3168 card, and the card's firmware crashes every now and then (`Microcode SW error detected` in the kernel log). Sometimes the driver recovers on its own, sometimes the connection just stays dead until someone kicks it. On a headless box I'm not sitting next to, that's annoying.

This doesn't fix the card, it just notices when the network is gone and brings it back without me having to.

## Install

```bash
git clone <this repo>
cd netwatch
chmod +x install.sh uninstall.sh
sudo ./install.sh
```

This copies `netwatch.sh` to `/usr/local/bin/`, puts `netwatch.service` in `/etc/systemd/system/`, and enables the service so it starts on boot.

Check that it's running:

```bash
systemctl status netwatch
journalctl -u netwatch -f
```

## Uninstall

```bash
sudo ./uninstall.sh
```

## Notes

- Tested on Debian with ifupdown (`systemctl restart networking`). If you use NetworkManager, that command won't do anything; change it to something like `nmcli device disconnect <iface> && nmcli device connect <iface>`.
- It runs as root, since it needs to restart networking.
