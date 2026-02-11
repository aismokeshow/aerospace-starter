# Image Theme — AeroSpace Starter

All project images follow this theme spec.

## Aesthetic

Paper craft fire emoji on a clean background. The fire is handcrafted from layered cut paper with visible textures, creases, and distinct color layers. It casts a soft drop shadow. Minimal, playful, and warm. Two variants: light (white background) and dark (GitHub dark #0d1117 background).

## Brand Elements

- **Fire emoji:** Paper craft-style, centered in the upper half of the frame. Warm oranges, reds, yellows in layered cut paper.
- **Title:** "AISMOKESHOW" in Geist Bold 54pt
- **Subtitle:** "Aerospace Starter" in Geist Regular 30pt
- **Tagline:** "where there's smoke, there's code" in Geist Regular 17pt

## Colors

| Element | Light variant | Dark variant |
|---|---|---|
| Background | Pure white #FFFFFF | GitHub dark #0d1117 |
| Title text | Near-black (40, 40, 40) | Near-white (235, 235, 235) |
| Subtitle text | Medium gray (100, 100, 100) | Light gray (170, 170, 170) |
| Tagline text | Light gray (160, 160, 160) | Medium gray (110, 110, 110) |

## Typography

Geist font family (Vercel, SIL Open Font License). Bundled in the skill at `.claude/skills/generate-readme-hero/fonts/`.

- Title: Geist-Bold.ttf @ 54pt
- Subtitle: Geist-Regular.ttf @ 30pt
- Tagline: Geist-Regular.ttf @ 17pt

## Layout

- **Aspect ratio:** 16:9
- **Final size:** 1280x720
- **Format:** JPEG
- **Fire position:** Centered horizontally, upper half (~40-50% vertical space)
- **Text block:** Starts at ~76% of image height (below fire + shadow)
- **Edge fade:** Cosine-eased, 18% per edge, to background color

## Pipeline

See `/.claude/skills/generate-readme-hero/SKILL.md` for the full generation pipeline.

```bash
SKILL=".claude/skills/generate-readme-hero"

# Light variant
python3 $SKILL/scripts/text-composite.py base-clean.jpg concepts/hero-light-text.jpg \
  --title "AISMOKESHOW" --subtitle "Aerospace Starter" --mode light
python3 $SKILL/scripts/edge-fade.py concepts/hero-light-text.jpg concepts/hero-light-faded.jpg --target white
img process concepts/hero-light-faded.jpg --profile clean -o images/ --name aerospace-ais-hero-light

# Dark variant
python3 $SKILL/scripts/bg-swap.py base-clean.jpg concepts/hero-dark-bg.jpg
python3 $SKILL/scripts/text-composite.py concepts/hero-dark-bg.jpg concepts/hero-dark-text.jpg \
  --title "AISMOKESHOW" --subtitle "Aerospace Starter" --mode dark
python3 $SKILL/scripts/edge-fade.py concepts/hero-dark-text.jpg concepts/hero-dark-faded.jpg --target dark
img process concepts/hero-dark-faded.jpg --profile clean -o images/ --name aerospace-ais-hero-dark
```

## README Usage

```html
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="images/aerospace-ais-hero-dark.jpg">
  <source media="(prefers-color-scheme: light)" srcset="images/aerospace-ais-hero-light.jpg">
  <img alt="AISMOKESHOW Aerospace Starter" src="images/aerospace-ais-hero-light.jpg" width="720">
</picture>
```

## Hero Images

| Variant | Filename |
|---|---|
| Light (white bg) | `aerospace-ais-hero-light.jpg` |
| Dark (GitHub dark bg) | `aerospace-ais-hero-dark.jpg` |

## Feature Images

| Feature | Filename | Content Focus |
|---|---|---|
| App Routing | `aerospace-ais-routing.jpg` | Auto-categorization: terminals/browsers/float |
