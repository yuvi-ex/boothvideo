# Two engineers. One data question.

Latest revision: `exasol-booth-polished.mp4`. Updated presentation uses Avenir Next headings/dialogue, Menlo SQL, a navy/violet gradient background, shaded panels, and redrawn engineers with conference badges and animated hand gestures. The SQL and complete five-row results appear side by side during 24–40 seconds, preserving the original MONGO_CITY, MONGO_TIER and EXASOL_REVENUE aliases and FROM MONGODB / FROM EXASOL labels. The engineers move to the bottom so the technical demonstration fills the screen. Previous exports are retained.

48-second, 1920 × 1080, 30 fps booth animation. English on-screen dialogue; intentionally silent for a busy exhibition space. Enable repeat playback on the booth player.

## Storyboard

| Time | Story |
| --- | --- |
| 00–08 | Maya asks whether MongoDB customers can be joined with Exasol orders. Dev proposes connecting the sources. |
| 08–16 | Maya asks about another copying pipeline. Dev introduces querying through a Virtual Schema. |
| 16–24 | An animated connection explains external data exposed as virtual tables. |
| 24–32 | Maya asks about familiar SQL. The demo query types onto the screen. |
| 32–40 | The city, loyalty tier and revenue result appears row by row. |
| 40–48 | The engineers invite visitors to see Virtual Schemas at the booth. |

Custom vector characters, teal/amber source coding, animated data particles, blinking and gently moving characters, staggered dialogue, SQL reveal, and a fade for repeat playback.

Based on `/Users/yuvi/Downloads/beat1-virtual-schema.mp4`. The source is a silent 22-second SQL/results demonstration. SQL and sample results were transcribed from the source; this animation does not execute the query or independently validate the sample data. The EXASOL heading is typeset text, not an official logo asset.

## Editable source

`render.swift` contains the text, drawings, animation timings and MP4 exporter. Uses only macOS AppKit and AVFoundation.

Generate preview frames:

```sh
swift -module-cache-path /private/tmp/booth-swift-cache booth-video/render.swift --preview
```

Render to a new output filename (AVAssetWriter requires a path that does not already exist):

```sh
swift -module-cache-path /private/tmp/booth-swift-cache booth-video/render.swift booth-video/engineers-virtual-schema-v2.mp4
```
# Exasol Booth Video Package

Final booth-ready videos and source renderer for the Exasol community event.

## Recommended playback

- `ONE-TV-exasol-complete-loop-v10.mp4` — one-TV loop, 3:36
- `TV1-exasol-overview-45s-v4.mp4` — overview/architecture screen, 45 seconds
- `TV2-exasol-features-loop-v10.mp4` — SQL → dashboard → feature reveal → free local starter-kit ending, 2:51

The final story asks what Exasol can do after the dashboard reveal, walks through feature value, then resolves the cost/cloud objection with Exasol Personal Local and the starter kit.

## Source

- `render.swift` renders the SQL, UDF, dashboard, feature, and local-starter-kit scenes.
- `assemble.swift` concatenates scenes into booth loops.
- `verify.swift` validates dimensions, duration, and decoded frame count.

The renderer uses the official Exasol logo, Exasol green/navy theme, generated photorealistic engineer cutouts, and the archived dashboard asset in `assets/`.
