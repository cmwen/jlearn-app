# Icon generation / usage guide

This document contains the generation workflow and quick commands to produce the master PNG from the project SVG and generate Android launcher icons.

Files created/expected
- `assets/icon/app_icon.svg` — master vector source (1024×1024)
- `assets/icon/app_icon.png` — master PNG (1024×1024) — generated from the SVG

Recommended workflow

1. Convert SVG -> PNG (macOS)

Using Inkscape (recommended):

```bash
# install if missing
brew install inkscape

inkscape assets/icon/app_icon.svg \
  --export-type=png \
  --export-filename=assets/icon/app_icon.png \
  --export-width=1024 \
  --export-height=1024
```

Or using librsvg (`rsvg-convert`):

```bash
brew install librsvg
rsvg-convert -w 1024 -h 1024 assets/icon/app_icon.svg -o assets/icon/app_icon.png
```

2. Generate Android mipmaps

We added `flutter_launcher_icons` to dev_dependencies and a minimal config in `pubspec.yaml`. After you generate the master PNG, run:

```bash
flutter pub get
flutter pub run flutter_launcher_icons:main
```

This will populate `android/app/src/main/res/mipmap-*` with the densities.

3. Verify results

Check small-size PNGs to confirm clarity and recognition at 48×48, 72×72 etc. You can derive test files from the SVG:

```bash
# generate several sizes for quick eyeballing
for size in 48 72 96 144 192; do 
  rsvg-convert -w $size -h $size assets/icon/app_icon.svg -o assets/icon/test_${size}px.png
done
open assets/icon/test_*px.png
```

Notes
- Keep main contents inside the central 820×820 safe area.
- Avoid text and tiny details that won't scale down.
- Use the SVG as the single source-of-truth for future edits.
