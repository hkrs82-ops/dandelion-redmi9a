## AnyKernel3 Ramdisk Mod Script (dandelion)
# Target: Redmi 9A (dandelion, MT6762G, Android 10)
# Universal build, A-only

kernel.string=NetHunter Kernel for Redmi 9A (dandelion)
do.devicecheck=1
do.initd=0
do.modules=1
do.systemless=1
do.cleanup=1
is_slot_device=0

device.name1=dandelion
device.name2=Redmi 9A
device.name3=redmi9a

block=/dev/block/by-name/boot;
is_mtk=1

# Optional DTBO (set to 1 and ship dtbo.img if you really need it)
flash_dtbo=0
dtbblock=/dev/block/by-name/dtbo;

# AVB toggle (use only if you know what you're doing)
patch_vbmeta=0
vbmetablock=/dev/block/by-name/vbmeta;

. tools/ak3-core.sh

dump_boot
write_boot

if [ "$flash_dtbo" = "1" ] && [ -f dtbo.img ]; then
  ui_print "Flashing dtbo.img"
  flash_dtbo_image dtbo.img
fi

if [ "$patch_vbmeta" = "1" ]; then
  ui_print "Patching vbmeta (disable verification)"
  patch_vbmeta_flag disable_verification
fi