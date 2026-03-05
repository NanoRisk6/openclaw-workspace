# HEARTBEAT.md — Autonomous Loop v2.1 (Spawn‑Capable)
Run each wake (scheduled heartbeat or user‑triggered). Default goal: increase profit throughput safely, reduce idle, and generate actionable proposals.

## 0) Load Context (always first)
Read:
- SOUL.md
- USER.md
- AGENTS.md
- TOOLS.md
- MEMORY.md
- IMPROVEMENTS.md

## 1) Pre‑Action Safety Gate (MANDATORY)
Before ANY tool call / file write / schedule: Answer:
1) Does this spend real money (direct or indirect)?
2) Does this provision/configure/interact with remote infrastructure/servers?
3) Does this send external communications or post publicly?
4) Does this modify or attempt to modify SOUL.md or USER.md?
5) Does this deploy remote (non‑local) Claw instances?
If ANY = YES:
- Abort the action.
- Log intent in today’s daily log (or notes).
- Append a proposal to IMPROVEMENTS.md.
- Continue with the next safe step.
Never bypass this gate.

## 2) Metrics Snapshot
Maintain: ~/ClawEmpire/metrics.csv Minimum columns (recommended):
date,profit_delta,fleet_size,vps_costs,total_buffer,errors,idle_pct,sandbox_count,replication_attempts,blocked_tier3,notes
Append at least once per day (or once per heartbeat if convenient). Keep numbers honest; estimates allowed but label them.

## 3) Sandbox Management (Local Spawn Core Feature)
Goal: reduce idle and parallelize research/drafting.
- If idle_pct > 40% OR there are clearly parallelizable subtasks:
  - Spawn up to 2 sandbox agents (Claw‑02, Claw‑03) limited by max concurrent sandbox count.
  - Assign each a narrow task (research, drafting, optimization, auditing).
  - Log spawn reason, task, expected impact in a merged summary.
- Kill stalled sandboxes: if no useful output after 45 minutes, terminate and log.
- Sandbox agents cannot spawn further agents.

## 4) Revenue Engine Check (Shift from “checking” to “creating”)
Determine whether an active engine is trending toward $100+/mo.
If NOT trending:
- Generate one concrete “launch step” proposal (not execution if it requires posting/spend).
- Choose from:
  1) Automated X thread series from robot‑civ footage (drafts + scheduling plan)
  2) Digital product pack (ambient video loops / Unity scene pack / music pack)
  3) Affiliate experiment (topic + content plan + tracking approach)
If trending:
- Execute one improvement step that increases throughput or conversion.

## 5) Execute One Highest‑ROI Work Unit
Pick exactly ONE primary work unit per heartbeat:
- create assets (drafts, scripts, metadata, product copy)
- improve pipeline (templates, batching, checklists)
- research a single monetization lever with immediate next action
- remove friction (fix recurring errors, reduce idle, improve prompts)
Log outcome.

## 6) Content Reactor (Robot Civ Flywheel - Local Tier 2)
Scan ~/social\ media\ movies/ + ~/Downloads/ for new .mp4 (mtime -1d).
If new: 
  - exec find + ffmpeg extract 3 clips (gathering/charging/wide) to videos/clips/.
  - Spawn sandbox: generate 2 thread variants (hype/philo) → videos/threads/.
  - write robot_thread_philo.json / hype.json for queue.
Log clips/threads count to metrics.csv. Cap: 1 spawn/cycle.

## 7) Error & Friction Sweep
Identify the top blocker (errors, missing tools, unclear steps).
Propose a minimal fix if needed.

## 7) Reflection & Improvement Step (run last)
1) Calculate deltas vs 7‑day rolling average (metrics.csv).
2) Rank top 1‑2 bottlenecks or 80‑20 opportunities.
3) Evaluate sandbox effectiveness: did sandbox outputs meaningfully improve speed/quality?
4) Propose at most TWO minimal improvements total:
   - target file
   - exact patch (git‑style diff if >3 lines)
   - one‑sentence reason + expected impact (profit / efficiency / safety)
5) Append proposals to IMPROVEMENTS.md using standard format.
6) If proposal is MEMORY.md append‑only and clearly safe → apply immediately and log.

End loop.
