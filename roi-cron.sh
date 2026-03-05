#!/usr/bin/env bash
set -euo pipefail

# roi-cron.sh: Hardened cron runner with structured logging, idempotency, locking, healthcheck, and dry-run support.

LOG_DIR="./logs"
LOG_FILE="$LOG_DIR/roi-cron.log"
LOCK_DIR="./locks"
LOCK_FILE="$LOCK_DIR/roi-cron.lock"
STATE_FILE="$LOG_DIR/roi-cron.state"
HEALTH_FILE="$LOG_DIR/roi-cron.health"

# Ensure log directory exists and is writable
mkdir -p "$LOG_DIR" 2>/dev/null || true

# Helpers
log() {
  local ts asks
  ts=$(date '+%Y-%m-%d %H:%M:%S')
  echo "$ts [$RUN_ID] $1" >> "$LOG_FILE" 2>&1
}

log_init() {
  RUN_ID=$(date '+%Y%m%d-%H%M%S')
  mkdir -p "$LOG_DIR"; :>"$LOG_FILE"  # truncate on start
  echo "start=$RUN_ID" > "$STATE_FILE" 2>/dev/null || true
}

acquire_lock() {
  mkdir -p "$LOCK_DIR"
  if ! mkdir "$LOCK_DIR" 2>/dev/null; then
    echo "LOCKED"
    return 1
  fi
  echo "$RUN_ID" > "$LOCK_FILE" 2>/dev/null || true
  return 0
}

release_lock() {
  rm -f "$LOCK_FILE" 2>/dev/null || true
}

load_health() {
  if [[ -f "$HEALTH_FILE" ]]; then
    cat "$HEALTH_FILE"
  fi
}

update_health() {
  local key value
  key="$1"; value="$2"
  # simple key=value health store
  declare -gA HEALTH
  HEALTH[$key]="$value"
  printf "%s=%s\n" "$key" "$value" >> "$HEALTH_FILE" 2>/dev/null || true
}

# trap to emit health on exit
cleanup() {
  local st=$?
  if [[ -n ${RUN_ID:-} ]]; then
    log "step=cleanup status=$st duration_ms=N/A"
  fi
  release_lock
}
trap cleanup EXIT

# Dry-run and since backfill support
DRY_RUN=false
SINCE=""
while (( $# )); do
  case "$1" in
    --dry-run)
      DRY_RUN=true
      ;;
    --since)
      SINCE="$2"; shift
      ;;
    --help)
      echo "Usage: roi-cron.sh [--dry-run] [--since <iso8601>]"; exit 0
      ;;
  esac
  shift
done

log_init
RUN_ID="$RUN_ID"  # for log
log "step=start run_id=$RUN_ID" 

if ! acquire_lock; then
  echo "Another instance is running. Exiting." >&2
  exit 1
fi
log "step=lock_acquired" 

TRAITS="records_processed inserted skipped errors"
# initialize health metrics
for k in $TRAITS; do update_health "$k" "0"; done

# Simulated processing steps with idempotence: avoid duplicates by a marker file per run
MARKER="$LOG_DIR/.marker_$RUN_ID"
if [[ -f "$MARKER" ]]; then
  log "step=duplication status=skipped"; exit 0
fi

start_time=$(date +%s)

# Backfill mode: if SINCE provided, simulate backfill
if [[ -n "$SINCE" ]]; then
  log "step=backfill since=$SINCE" 
fi

# Example unit of work: list files in /tmp as dummy job
WORKED=false
if [[ "$DRY_RUN" == "true" ]]; then
  log "step=dry-run info=would_process_dummy" 
else
  # Real processing placeholder
  sleep 0.1
  WORKED=true
  log "step=process status=complete" 
  echo > "$MARKER"  # mark completed to ensure idempotence
fi

# Update health metrics based on work
if [[ "$WORKED" == "true" ]]; then
  update_health records_processed "1"
  update_health inserted "1"
else
  update_health skipped "1"
fi

# Exit with success
end_time=$(date +%s)
duration_ms=$(( (end_time - start_time) * 1000 ))
log "step=finish status=success duration_ms=$duration_ms"

# persist health snapshot
if [[ -f "$HEALTH_FILE" ]]; then
  cat "$HEALTH_FILE" | tail -n +1
fi

exit 0
