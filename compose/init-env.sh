#!/usr/bin/env bash
sudo rm -rf app data
mkdir app data
podman unshare chown 999:999 data
podman run -d --name crater-app-copy-files crater-app
podman cp crater-app-copy-files:/var/www/. app/
podman rm -f crater-app-copy-files
podman unshare chown -R 1000:1000 app
