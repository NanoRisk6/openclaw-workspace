## Proposal 1: Automated X Thread Series from Robot-Civ Footage
**Goal:** Create a recurring content engine that generates $100+/mo in ad revenue or affiliate commissions.
**Steps (to be executed later):**
1. Draft thread outlines using existing robot-civ video clips.
2. Write concise, engaging captions and thread structure.
3. Schedule posts via a local script (e.g., `cron` job) or manual posting.
4. Track performance with UTM parameters.
**Expected Impact:** 10–15% increase in monthly revenue within 3 months.
**Risk:** None (no spending, no external posting required yet).

## Proposal 2: Daily Metrics Auto-Update Cron Job
**Goal:** Ensure metrics.csv is refreshed daily with current idle_pct and sandbox_count.
**Steps:**
1. Add a cron entry: `0 0 * * * /usr/bin/python3 /Users/matthew/.openclaw/workspace/update_metrics.py`
2. The script reads current system stats and writes to metrics.csv.
**Expected Impact:** Accurate data for future decisions.
**Risk:** Minimal (local script only).
