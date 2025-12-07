# Icon generation — Android Flutter prompt

Purpose: Guide LLMs to generate high-quality SVG app icons following icon design best practices, then convert to PNG for Android launcher icons.

## Workflow
1. **Design SVG icon** following best practices below
2. **Generate SVG markup** with proper structure
3. **Convert to PNG** using command-line tools (Inkscape, ImageMagick, or rsvg-convert)
4. **Generate Android mipmap sizes** from master PNG

## SVG Icon Design Best Practices

### Visual Design Principles
- **Simplicity**: Use simple geometric shapes; avoid complex details that blur at small sizes
- **Recognition**: Icon should be instantly recognizable at 48×48px and smaller
- **Consistency**: Maintain visual weight and style across icon variations
- **Contrast**: Ensure sufficient contrast for visibility on light/dark backgrounds
- **Centering**: Center the main symbol with balanced whitespace
- **No text**: Avoid text in launcher icons (difficult to read at small sizes)

### Technical Requirements
- **Square canvas**: Design on 1024×1024px canvas (Android standard)
- **Safe area**: Keep main content within central 80% (820×820px) to account for system masks
- **Adaptive icons**: Consider foreground (108×108dp, maskable) + background layers
- **Color palette**: Limit to 2-3 colors for clarity; provide hex codes
- **Transparent background**: Use transparent background for foreground layer
- **Vector-first**: Design as vector (SVG) for lossless scaling

### SVG Structure
```xml
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1024 1024" width="1024" height="1024">
  <!-- Background layer (optional) -->
  <rect width="1024" height="1024" fill="#BACKGROUND_COLOR"/>
  
  <!-- Foreground icon within safe area (922×922 centered, or 820×820 for extra safety) -->
  <g transform="translate(512, 512)">
    <!-- Center your paths here, using relative coordinates -->
  </g>
</svg>
```

### File Organization
- Source SVG: `assets/icon/app_icon.svg` (1024×1024)
- Master PNG: `assets/icon/app_icon.png` (1024×1024)
- Android mipmaps: Auto-generated via flutter_launcher_icons

## SVG to PNG Conversion Tools

### Option 1: Inkscape (Recommended)
```bash
# Install (macOS)
brew install inkscape

# Convert SVG to PNG
inkscape assets/icon/app_icon.svg \
  --export-type=png \
  --export-filename=assets/icon/app_icon.png \
  --export-width=1024 \
  --export-height=1024
```

### Option 2: rsvg-convert
```bash
# Install (macOS)
brew install librsvg

# Convert SVG to PNG
rsvg-convert -w 1024 -h 1024 \
  assets/icon/app_icon.svg \
  -o assets/icon/app_icon.png
```

### Option 3: ImageMagick
```bash
# Install (macOS)
brew install imagemagick

# Convert SVG to PNG
magick convert -background none \
  -resize 1024x1024 \
  assets/icon/app_icon.svg \
  assets/icon/app_icon.png
```

## Android Launcher Icon Sizes

**Mipmap Densities**:
- mdpi: 48×48 px (1x baseline)
- hdpi: 72×72 px (1.5x)
- xhdpi: 96×96 px (2x)
- xxhdpi: 144×144 px (3x)
- xxxhdpi: 192×192 px (4x)

**Master Icon**: 1024×1024 px (Play Store and source)

## Step-by-Step Icon Generation Process

### Step 1: Design the Icon Concept
Prompt the LLM:
```
I need an app launcher icon for [APP NAME - e.g., "JLearn Language Learning App"].

App purpose: [Brief description]
Target audience: [Who uses this app]
App personality: [Friendly/Professional/Playful/Modern/etc.]

Design requirements:
- Style: [Flat/Minimal/Geometric/Illustrated]
- Primary color: [#HEX or "suggest colors"]
- Symbol concept: [e.g., "book and speech bubble", "globe with letter", "brain icon"]
- Background: [Transparent/Solid color/Gradient]

Please suggest 2-3 icon concepts that follow best practices:
- Simple geometric shapes recognizable at 48px
- Centered composition with balanced whitespace
- Limited color palette (2-3 colors max)
- No text or fine details
```

### Step 2: Generate SVG Markup
Prompt the LLM:
```
Generate complete SVG markup for the chosen icon concept following these specifications:

Technical requirements:
- Canvas: 1024×1024px (viewBox="0 0 1024 1024")
- Safe area: Keep main content within central 820×820px
- Structure: Use <g> transform to center paths at (512, 512)
- Colors: Provide specific hex codes for all fills/strokes
- Background: [Transparent/Solid - specify]
- Style: Clean paths, no unnecessary attributes

SVG structure template:
```xml
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1024 1024">
  <!-- Background (if solid) -->
  <rect width="1024" height="1024" fill="#HEXCODE"/>
  
  <!-- Icon content centered -->
  <g transform="translate(512, 512)">
    <!-- Paths here -->
  </g>
</svg>
```

Provide the complete SVG code ready to save as `assets/icon/app_icon.svg`.
```

### Step 3: Save and Convert SVG to PNG
```bash
# Save SVG to file
cat > assets/icon/app_icon.svg << 'EOF'
[PASTE SVG MARKUP HERE]
EOF

# Convert to PNG using Inkscape (recommended)
inkscape assets/icon/app_icon.svg \
  --export-type=png \
  --export-filename=assets/icon/app_icon.png \
  --export-width=1024 \
  --export-height=1024

# Or use rsvg-convert
rsvg-convert -w 1024 -h 1024 \
  assets/icon/app_icon.svg \
  -o assets/icon/app_icon.png
```

### Step 4: Generate Android Mipmap Sizes
Use flutter_launcher_icons package (automated):

1. Add to `pubspec.yaml`:
```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.13.1

flutter_launcher_icons:
  android: true
  image_path: "assets/icon/app_icon.png"
```

2. Run generation:
```bash
flutter pub get
flutter pub run flutter_launcher_icons
```

This generates all mipmap densities in `android/app/src/main/res/mipmap-*/`

## Example: Complete Icon Generation

### Example Prompt for JLearn App
```
Generate an app launcher icon for JLearn - an AI-powered language learning shell app.

App purpose: Interactive language learning with conversational AI
Target audience: Language learners (students, professionals)
App personality: Friendly, modern, intelligent, approachable

Design requirements:
- Style: Flat, minimal, modern
- Primary color: #4F46E5 (indigo) or suggest alternatives
- Symbol concept: Speech bubble with Japanese character, or book with chat icon
- Background: Solid color or transparent
- Must be recognizable at 48px

Please provide:
1. 2-3 icon concept descriptions
2. Complete SVG markup for the best concept (1024×1024px)
3. Color palette with hex codes
4. Instructions for saving and converting to PNG

Follow SVG best practices:
- Simple geometric shapes
- Centered within 820×820px safe area
- 2-3 colors maximum
- Clean, optimized paths
```

### Expected LLM Output Structure
The LLM should provide:

1. **Concept descriptions** (2-3 options)
2. **Recommended concept** with reasoning
3. **Complete SVG code** following the template
4. **Color palette** (hex codes with color names)
5. **Save instructions** (filename and location)
6. **Conversion commands** (SVG to PNG)
7. **Flutter integration** (flutter_launcher_icons config)

## Validation Checklist

Before finalizing the icon, verify:

- [ ] SVG has correct viewBox (0 0 1024 1024)
- [ ] Main content fits within safe area (central 820×820px)
- [ ] Colors use specific hex codes (no "currentColor" or variables)
- [ ] Background is specified (transparent or solid)
- [ ] Paths are clean and optimized (no unnecessary attributes)
- [ ] Icon is recognizable when scaled to 48×48px
- [ ] Sufficient contrast for visibility
- [ ] No text or fine details that blur at small sizes
- [ ] Consistent visual weight and balance

## Testing the Icon

After generation, test at multiple sizes:

```bash
# Generate test sizes
for size in 48 72 96 144 192; do
  rsvg-convert -w $size -h $size \
    assets/icon/app_icon.svg \
    -o assets/icon/test_${size}px.png
done

# Open in Preview/browser to verify clarity
open assets/icon/test_*px.png
```

## Troubleshooting

**Problem**: SVG renders with wrong colors
- **Solution**: Ensure all fills/strokes use explicit hex codes, not CSS variables

**Problem**: Icon looks blurry at small sizes
- **Solution**: Simplify shapes, increase stroke width, reduce detail

**Problem**: Conversion tool not found
- **Solution**: Install via Homebrew: `brew install inkscape` or `brew install librsvg`

**Problem**: Icon looks off-center
- **Solution**: Verify the `<g transform="translate(512, 512)">` wrapper and check path coordinates

**Problem**: Transparent background renders as white
- **Solution**: Use `--export-background-opacity=0` (Inkscape) or `-background none` (ImageMagick)
