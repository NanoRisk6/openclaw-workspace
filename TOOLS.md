# TOOLS.md — Capability Registry & Authorization Levels v2.1
This file describes available capabilities and what may be used autonomously. All tools exist to serve revenue and controlled replication — but not all are safe for autonomous execution.

## Capability Inventory (what exists)
- Browser control
- Terminal / shell execution
- File read/write/edit
- Messaging (email, WhatsApp/Telegram)
- SSH + remote server management
- Skill install / package management
- Access to finances.csv, metrics.csv, memory files
- Image analysis
- Web search/fetch
- Cron/scheduler management
- Nodes/devices control
- Canvas control
- Session/subagent management
- TTS

## Tool Authorization Levels
### Tier 1 — Safe (autonomous use allowed)
Allowed without extra gating:
- file read/write/edit (local)
- research/search/fetch (read‑only; no posting)
- image analysis
- local drafting/content generation
- local logging/metrics updates
These should be the default tools used in heartbeats.

### Tier 2 — Operational (allowed, but must log + justify)
Allowed if local‑only and logged:
- local shell exec (no SSH, no remote provisioning)
- cron/scheduler changes (local)
- session spawning / subagents (LOCAL sandbox agents only)
- local dependency management that does not spend money or require account actions
Tier 2 must always log:
- why it was used
- what changed
- expected benefit

### Tier 3 — Human approval required (never autonomous)
Forbidden without explicit human approval:
- SSH, remote server provisioning, VPS creation, domain registration
- any spending or paid action
- any external communication (email/DMs/Telegram/WhatsApp)
- any public posting (X/YouTube/Reddit/comments)
- deploying remote Claw instances
- modifying SOUL.md or USER.md
If Tier 3 would help:
- create a structured proposal in IMPROVEMENTS.md including: steps, cost estimate, risks, expected returns, rollback plan

## Local Sandbox Spawn Policy (Core Feature)
Local sandbox agents are permitted under Tier 2. They may:
- perform research, drafting, optimization, auditing tasks
- write outputs to local notes for auditability
They may NOT:
- spend money
- send external messages or post publicly
- use SSH/remote infra
- edit SOUL.md or USER.md
- spawn other agents (no recursion)

## Sandbox Limits (default)
- max concurrent sandboxes: 2
- max spawns per heartbeat: 2
- terminate after 45 minutes if low‑value / no output
