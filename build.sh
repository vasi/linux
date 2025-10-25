#!/bin/sh

# Needs:
# * Setup icecc for distributed compiling
# * Build gcc crosstool

VERS=${1:-vasi-kvm}
if ! [ -f configs/$VERS ]; then
  echo "No such config $VERS"
  exit 1
fi

export PATH=$HOME/ppc/crosstool/icecc:$HOME/ppc/crosstool/powerpc-unknown-linux-gnu/bin:$PATH
export ICECC_VERSION=x86_64:$HOME/ppc/crosstool/icecc-ppc-crosstool.tgz

MAKE="make ARCH=powerpc CROSS_COMPILE=powerpc-unknown-linux-gnu- INSTALL_MOD_PATH=$HOME/ppc/arch/kernel"

cp configs/$VERS .config
$MAKE olddefconfig

echo -1 > localversion.10-pkgrel
echo "-$VERS" > localversion.20-pkgname
$MAKE -s kernelrelease > version

$MAKE -j25
cp .config  ~/ppc/arch/kernel/config-linux-$VERS
cp vmlinux  ~/ppc/arch/kernel/vmlinuz-linux-$VERS
$MAKE modules_install
