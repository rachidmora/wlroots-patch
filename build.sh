#!/bin/bash
set -e
export DEBIAN_FRONTEND=noninteractive
sed -i 's/^Types: deb$/Types: deb deb-src/' /etc/apt/sources.list.d/debian.sources
apt-get update
apt-get install -y dpkg-dev devscripts
apt-get build-dep -y wlroots
mkdir -p /build
cd /build
apt-get source wlroots
cp "$GITHUB_WORKSPACE/atomic.c" /build/wlroots-*/backend/drm/atomic.c
cp "$GITHUB_WORKSPACE/drm.c" /build/wlroots-*/backend/drm/drm.c
cd /build/wlroots-*/
DEB_BUILD_OPTIONS="nocheck parallel=4" dpkg-buildpackage -b -uc -us -d
mkdir -p "$GITHUB_WORKSPACE/out"
cp /build/*.deb "$GITHUB_WORKSPACE/out/"
