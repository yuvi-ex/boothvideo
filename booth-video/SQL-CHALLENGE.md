# Two databases. One SQL query?

Current video: `exasol-sql-challenge.mp4` — 48 seconds, 1920 × 1080, H.264, 30 fps. Silent, caption-led booth loop.

| Time | Visual beat |
| --- | --- |
| 0–4s | Oversized challenge typography; MongoDB and Exasol cards enter from opposite sides. |
| 4–9s | Engineer close-up: “My data lives in two places.” / “How do I JOIN it?” |
| 9–13s | Second engineer: “WATCH THIS.” |
| 13–17s | Virtual Schema bridge and animated data flow. |
| 17–33s | Complete original SQL in a large code view. Highlights progress through orders, customer JOIN, location JOIN, loyalty JOIN, then aggregation and ranking. Matching source indicators light up. |
| 33–43s | Complete SQL beside all five original result rows, with original column aliases and MongoDB/Exasol source labels. |
| 43–48s | “YOUR DATA. YOUR QUESTION. LET’S RUN THE SQL.” Booth invitation and fade to loop. |

Full SQL remains visible for 26 seconds. The animation illustrates the source video's query and sample results; it does not execute the SQL or present a performance benchmark. No new revenue figures or speed claims were added.

Editable source: `render.swift`, function `draw`. Earlier layouts remain as unused functions for reference; previous MP4 exports are preserved. Generate a new output with:

```sh
swift -module-cache-path /private/tmp/booth-swift-cache booth-video/render.swift booth-video/sql-challenge-v2.mp4
```

Enable repeat playback in the booth's media player.
