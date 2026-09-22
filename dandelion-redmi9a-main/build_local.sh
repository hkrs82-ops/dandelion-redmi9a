
#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
KERNEL_BRANCH="dandelion-q-oss"
KERNEL_REPO="https://github.com/MiCode/Xiaomi_Kernel_OpenSource.git"
DEFCONFIG_PATH="$(cd "$(dirname "$0")" && pwd)/dandelion_defconfig"

mkdir -p "$REPO_DIR/out"

echo "[*] Installing dependencies (Ubuntu/Debian)..."
if command -v apt >/dev/null 2>&1; then
  sudo apt update
  sudo apt install -y git clang llvm lld gcc-aarch64-linux-gnu binutils-aarch64-linux-gnu                       flex bison make bc zip unzip
fi

cd "$REPO_DIR"
echo "[*] Cloning kernel sources..."
[ -d dandelion-kernel ] || git clone "$KERNEL_REPO" -b "$KERNEL_BRANCH" dandelion-kernel
cd dandelion-kernel

echo "[*] Applying defconfig..."
cp -f "$DEFCONFIG_PATH" "arch/arm64/configs/dandelion_defconfig"

export ARCH=arm64
make dandelion_defconfig

echo "[*] Building kernel (Image.gz-dtb)..."
if command -v clang >/dev/null 2>&1; then
  make -j"$(nproc)" CC=clang CROSS_COMPILE=aarch64-linux-gnu- CROSS_COMPILE_ARM32=arm-linux-gnueabi-
else
  make -j"$(nproc)" CROSS_COMPILE=aarch64-linux-gnu- CROSS_COMPILE_ARM32=arm-linux-gnueabi-
fi

IMG="arch/arm64/boot/Image.gz-dtb"
cp -f "$IMG" "$REPO_DIR/out/Image.gz-dtb"

cd "$REPO_DIR"
echo "[*] Preparing AnyKernel3..."
rm -rf AK3
git clone https://github.com/osm0sis/AnyKernel3.git AK3
cp -f anykernel/anykernel.sh AK3/anykernel.sh
cp -f out/Image.gz-dtb AK3/zImage

echo "[*] Packing flashable ZIP..."
( cd AK3 && zip -r9 "$REPO_DIR/nethunter-dandelion-kernel.zip" * )

echo "[*] Done."
echo "ZIP: $REPO_DIR/nethunter-dandelion-kernel.zip"
echo "IMG: $REPO_DIR/out/Image.gz-dtb"
