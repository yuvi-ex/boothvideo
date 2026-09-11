# One SQL view. Six dashboards?

Video: `exasol-dashboard-story-v1.mp4` — 75 seconds, 1920×1080, 30 fps, silent booth loop.

Source repository: https://github.com/yuvi-ex/meetup2assets, commit `0671d54ad7072e5203541ce1631b5edd087221be`.

| Time | Scene |
| --- | --- |
| 0–4 | One SQL view. Six dashboards? |
| 4–8 | Engineer: “The JOIN works. Can my team use it?” |
| 8–14 | MongoDB → Exasol view → dash-server → browser. |
| 14–19 | Actual JOIN excerpt from orders_enriched.sql. |
| 19–24 | Complete summary SQL from 06_dashboard.sh. |
| 24–36 | Real `orders_enriched-report.html` dashboard screen from `Archive 2.zip`, animated into a dark Exasol presentation frame. |
| 36–43 | Finance, sales, product, data science, inventory, delivery; validation/deployment/page verification flow. |
| 43–48 | Booth invitation and loop fade. |

## Evidence and limits

`06_dashboard.sh` creates the shared view, uses external recipes at `$HOME/exasol-recipes`, calls dryrun.py, ship.sh and preflight.py, and checks `/apps/<board>` on port 5100. Those external recipe app files are not included in the source repository and the directory was not available locally. The video uses a real dashboard HTML asset from `/Users/yuvi/Downloads/Archive 2.zip`, extracted locally and captured with Chrome headless; it is not a live network recording. No dashboards were deployed or database state modified for this video.

SQL view and formulas: `sql/orders_enriched.sql`. Summary query and board names: `06_dashboard.sh`. Summary expected values: `RUNSHEET.md`. Order-status revenue chart calculated directly from `data/retail_orders.csv` using decimal arithmetic. Values are whole-unit rounded; no currency was assumed.

| Metric | Whole-unit value |
| --- | ---: |
| Booked revenue | 17,108,805 |
| Realised revenue | 9,808,944 |
| Lost revenue | 4,880,883 |
| Delivered | 7,361,838 |
| Shipped | 2,447,105 |
| Processing | 2,418,978 |
| Returned | 2,444,822 |
| Cancelled | 2,436,061 |

Realised = Delivered + Shipped. Lost = Cancelled + Returned. Processing belongs to neither subtotal. This is generated sample data, not production business performance.

## Render

```sh
swift -module-cache-path /private/tmp/booth-swift-cache booth-video/render.swift booth-video/dashboard-v2.mp4 --dashboard
swift -module-cache-path /private/tmp/booth-swift-cache booth-video/render.swift --preview --dashboard
```

The final story files are `exasol-dashboard-story-v1.mp4`, `TV2-exasol-features-loop-v10.mp4`, and `ONE-TV-exasol-complete-loop-v10.mp4`. Use repeat playback on the booth media player. The corrected SQL scene is `exasol-sql-challenge-v5.mp4`; UDF remains `exasol-udf-challenge-v4.mp4`.
