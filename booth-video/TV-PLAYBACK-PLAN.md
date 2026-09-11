# Exasol booth: attract attention, then demonstrate

## Files to put on the TVs

| Setup | File | Duration | Position / role |
| --- | --- | --- | --- |
| Two TVs: TV 1 | TV1-exasol-overview-45s-v4.mp4 | 0:45 | Face the aisle. Introduce Exasol, explain its architecture, invite a question. |
| Two TVs: TV 2 | TV2-exasol-features-loop-v10.mp4 | 2:51 | Face people at the booth. Full story: SQL → dashboard → feature value → cost/cloud question → free local starter kit. |
| One TV | ONE-TV-exasol-complete-loop-v10.mp4 | 3:36 | Overview → SQL → dashboard → feature value → cost/cloud question → free local starter kit. |

All outputs are 1920×1080, H.264 MP4, and silent. The overview and source demos render at 30 fps; concatenated loops preserve the source timing at approximately 29.96 fps. Use the player's Repeat One setting and full-screen playback. The MP4 files themselves do not force repeat playback. The two-TV files are intentionally independent; synchronization is unnecessary. Keep player controls and desktop notifications hidden. Verify actual screen readability and repeat behavior on the intended TV before the event.

## 45-second overview story

| Time | Scene |
| --- | --- |
| 0–5 | Your next question should not wait. Three recognizable analytical questions. |
| 5–9 | Meet Exasol: an analytics database for SQL, dashboards, AI and ML. |
| 9–13 | One query fans out across three illustrative cluster nodes. |
| 13–17 | Column selection, compression and in-memory processing. |
| 17–21 | Partial results combine; automatic optimization reduces manual tuning. |
| 21–28 | Workload comparison: transactional row access versus columnar analytical scans, JOINs and aggregations. |
| 28–36 | Connect, predict, visualize: introduce the three existing demonstration films. |
| 36–41 | On-prem, cloud and hybrid deployment options. |
| 41–45 | Bring a hard question. Let's run the SQL. Meet the booth engineers. |

## Sources checked on 2026-09-10

- [Exasol database](https://www.exasol.com/exasol-database/): analytical positioning, MPP, in-memory processing, self-tuning, UDF/model execution, MCP access and deployment choices.
- [Exasol MPP architecture](https://www.exasol.com/hub/database/mpp/): distributes scans, JOINs and aggregations across nodes and combines partial results. The three drawn nodes are illustrative, not a required topology or a claim of linear speedup.
- [Exasol in-memory architecture](https://www.exasol.com/hub/database/in-memory/): column-oriented access, compression and memory-based processing; in-memory execution does not imply absence of durable storage.
- [Row versus column storage](https://www.exasol.com/hub/database/row-vs-column/): row-oriented transactional access and columnar analytical scans serve different typical workloads. Other analytical databases use related techniques. No blanket competitive winner or invented speed ratio is presented.
- [Exasol profiling documentation](https://docs.exasol.com/db/latest/database_concepts/profiling.htm): automatic optimizer tuning actions; manual query investigation can still be needed.
- [Exasol agentic engineering](https://www.exasol.com/blog/exasol-agentic-engineering/): external data through adapters and SQL-accessible analytical workflows.

This is a conceptual product explainer, not a benchmark or exact deployment diagram. No vendor-wide performance comparison, cost saving, uptime guarantee or exclusive capability is asserted. The dashboard scene now uses a real screenshot from `Archive 2.zip` (`orders_enriched-report.html`, rendered locally) inside an animated presentation frame. Dash-server is the dashboard hosting tool used by this demonstration, not a database engine component.

## Suggested booth conversation

Lead with: “What is the hardest question your data needs to answer?” Then choose the matching demonstration: a cross-source JOIN, a model called from SQL, or a dashboard built on the shared view. The front screen introduces why; the second screen gives engineers concrete SQL to discuss.

## Rebuild

The overview is the `--overview` mode in `render.swift`; prior modes remain available. `assemble.swift` concatenates exports without rewriting their content. `verify.swift` fully decodes each output and checks the expected frame count.
