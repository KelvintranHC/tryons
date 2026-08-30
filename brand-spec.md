# Brand spec — RENDER.CAMP / Architectural AI Filmmaking
Source: https://ai.pvrender.camp/ (extracted from live CSS `:root`)

## Color tokens (mapped to OD six + observed extras)

| Token | Hex (source) | OKLch approx |
|---|---|---|
| `--bg` / `--paper` | `#FAFAFA` | `oklch(98.5% 0 0)` |
| `--surface` / `--paper-2` | `#F2F2F2` | `oklch(96.2% 0 0)` |
| `--fg` / `--ink` | `#0A0A0A` | `oklch(12% 0 0)` |
| `--muted` / `--mute` | `#707070` | `oklch(54% 0 0)` |
| `--border` / `--line` | `#E5E5E5` | `oklch(92% 0 0)` |
| `--accent` / `--live` | `#E11D2A` | `oklch(55% 0.22 25)` |

Supporting: `--ink-2` `#1F1F1F`, `--mute-2` `#9A9A9A`, `--line-strong` `#D0D0D0`, cover shell `#050505`, Trustpilot green `#00b67a`, Google star `#fbbc04`.

## Typography

- Display + body: `"Helvetica Neue", Helvetica, Arial, sans-serif` (single family; weight does hierarchy)
- Display weight 600, tracking `-.026em`, line-height ~0.95–1; display size ~49px
- Course italic line: Helvetica weight 100 italic
- Labels: 11–14px, uppercase tracking `.08em`–`.14em` where used
- Body ~17px / 1.55, tracking `-.005em`

## Layout posture (observed)

1. Magazine cover hero: full-bleed video, dark overlay gradient, glass CTA (blur + 1px light border), zero radius.
2. Hairline borders (`1px` `--line`), no card shadows, no rounded corners — editorial/brutal restraint.
3. Container max-width `1320px`; fluid pad `--pad-x` 20 → 40 → 64; section gap 80 → 112 → 144.
4. Accent red (`--live`) is rare (price/save moments); most UI is ink-on-paper.
5. Breakpoints: 720px tablet+, 1100px desktop grid for examples (8-col), sticky mobile CTA below cover.
