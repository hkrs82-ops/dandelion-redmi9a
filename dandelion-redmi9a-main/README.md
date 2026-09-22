# Redmi 9A (dandelion) — NetHunter Kernel (Universal, Android 10)

Автосборка ядра с поддержкой **HID/RNDIS** и базовых опций для Kali NetHunter. Работает на стоковых MIUI Q и большинстве AOSP/кастомов (Android 10).

## Что делает репозиторий
- Берёт исходники ядра: **MiCode/Xiaomi_Kernel_OpenSource @ dandelion-q-oss**
- Подставляет готовый `dandelion_defconfig` (включены HID/RNDIS, cfg80211/mac80211 и др.)
- Собирает `Image.gz-dtb` (clang)
- Упаковывает в **AnyKernel3** → `nethunter-dandelion-kernel.zip`
- Публикует ZIP как **artifact** и (при теге) — как **Release**

## Быстрый старт (GitHub)
1. Создай у себя репозиторий, например: `redmi9a-nethunter-kernel`.
2. Залей сюда содержимое этого архива (в корень репозитория).
3. Сделай коммит в `main` — сработает GitHub Actions, артефакт появится в разделе **Actions → Artifacts**.
4. Для публикации релиза — создай тег, например `v1.0.0`:
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```
   После этого ZIP прикрепится к **Releases**.

## Локальная сборка (Linux/WSL2)
```bash
sudo apt update
sudo apt install -y git clang llvm lld gcc-aarch64-linux-gnu binutils-aarch64-linux-gnu flex bison make bc zip unzip
bash scripts/build_local.sh
```
Готовые файлы:
- `out/Image.gz-dtb`
- `nethunter-dandelion-kernel.zip`

## Важные примечания
- Устройство: **Redmi 9A (dandelion), MT6762G, Android 10**. A-only.
- AnyKernel3 **не меняет ramdisk**, репакует текущий `boot` с вашим ядром ⇒ хорошо для большинства стока/кастомов.
- Если ROM строго проверяет AVB/dm-verity — используйте совместимое рекавери/ROM (патч vbmeta включать не рекомендуется без необходимости).
- Для Wi‑Fi инжекта используйте **внешние USB Wi‑Fi** адаптеры. Встроенный чип MTK обычно не поддерживает monitor/injection.
- Никакого разгона — **стоковые частоты** для стабильности.

## Credits
- AnyKernel3 — @osm0sis
- Kali NetHunter Team
- Xiaomi Kernel Open Source — MiCode