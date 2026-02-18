# Redundancy snapshot

Quick scan (MD5 hash comparison of files ≤2 MB, ignoring `.git`, `bin`, `build_dir`, `staging_dir`, `tmp`, `dl`, `logs`) surfaced identical file copies that could be deduplicated in future cleanups:

- **`target/linux/*/generic/target.mk` (16 copies)** – every file only contains `BOARDNAME:=Generic`.
- **WWAN device data (8 copies)** – `package/network/utils/wwan/files/data/19d2-12xx/151x` entries all carry the same JSON payload for ZTE MF192.
- **`target/linux/lantiq/*/profiles/00-default.mk` (6 copies)** – identical default profile stubs across lantiq subtargets.
- **`etc/inittab` (5 copies)** – identical content in `package/base-files/files/etc/inittab` and target base-files for ramips, realtek, zynq, and mediatek.
- **LZMA loader sources (5 copies each)** – `LzmaDecode.c`, `LzmaDecode.h`, and `LzmaTypes.h` repeated across `target/linux/{ramips,ath79,bmips,lantiq}/image/lzma-loader/src/` and `package/kernel/lantiq/ltq-vdsl-fw/src/`.
- **LZMA loader config (2 copies)** – `config.h` is identical between `target/linux/lantiq/image/lzma-loader/src/` and `target/linux/ramips/image/lzma-loader/src/`.

These duplicates are functional but represent redundant maintenance points; consolidating them into shared includes or templates would reduce drift risk.
