#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm libnss_nis nss-mdns nss

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
#make-aur-package PACKAGENAME

echo "Getting binary..."
echo "---------------------------------------------------------------"
case "$ARCH" in
	x86_64)  farch=x64;;
	aarch64) farch=arm64;;
esac

link=$(wget https://api.github.com/repos/stoatchat/for-desktop/releases -O - \
	  | sed 's/[()",{} ]/\n/g' | grep -o -m 1 "https.*/Stoat-linux-$farch.*.zip")
wget --retry-connrefused --tries=30 "$link" -O /tmp/temp.zip

mkdir -p ./AppDir/bin
unzip /tmp/temp.zip
mv -v ./Stoat-linux-"$farch"/* ./AppDir/bin

echo "$link" | awk -F'/' '{print $(NF-1); exit}' > ~/version
