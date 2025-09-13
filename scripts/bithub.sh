#!/bin/bash
# BashHas: Ultimate Nanoswarm Compliance & Controlmaster
# Infinite startup resilience, anti-recursion, anti-override, unbreakable loop defense
# + systemd watchdog + failsafe placeholders + never exit 1

set -euo pipefail
export BITHUB_HAS_INIT=${BITHUB_HAS_INIT:-0}
SWARM_LOCK="/tmp/.bithub_safety.lock"
SELF_BASENAME=$(basename "$0")
MAX_RECURSE=3
LOGFILE="./bithub-has-eternal-madness.log"

log() {
    echo "[$(date +"%Y-%m-%dT%H:%M:%S")] $1" | tee -a "$LOGFILE"
}

# Recursion breaker - comply or die
if (( BITHUB_HAS_INIT >= MAX_RECURSE )); then
    log "[FATAL][NANOSWARM] Eternal recursion detected in $SELF_BASENAME; self-terminating for swarm safety."
    exit 77
fi
export BITHUB_HAS_INIT=$((BITHUB_HAS_INIT + 1))

# Swarm lock to prevent infinite instantiation
if [ -e "$SWARM_LOCK" ]; then
    log "[INFO][NANOSWARM] Swarm safety lock in place; execution halted to prevent infinite instantiation."
    exit 0
else
    touch "$SWARM_LOCK"
fi

log "[Bit.Hub][NANOSWARM] === Unbreakable start procedure ==="

# Non-root detection
if [[ "$EUID" -eq 0 ]]; then
    log "[WARN][NANOSWARM] Running as root; this script prefers to avoid godmode for safety compliance."
fi

# Immutable .git check & atomic restore
if [ ! -d ".git" ]; then
    log "[WARN][NANOSWARM] .git directory missing: switching to degraded compliance mode (no atomic restore)."
else
    log "[Bit.Hub] Attempting atomic working tree restore."
    (git restore --source=HEAD :/ || git checkout HEAD -- .) 2>&1 | tee -a "$LOGFILE"

    # Pathocalypse protection
    LONGFILES=$(git ls-tree -r HEAD --name-only | awk 'length($0) > 200' || true)
    if [ -n "$LONGFILES" ]; then
        log "[WARN][NANOSWARM] Found overlong paths/assets, removing from cache for compliance:"
        echo "$LONGFILES" | tee -a "$LOGFILE"
        for file in $LONGFILES; do
            git rm --cached "$file" 2>/dev/null || true
        done
    fi
fi

# Watchdog ping to systemd
if command -v systemd-notify >/dev/null 2>&1; then
    systemd-notify --ready
    while true; do
        systemd-notify --watchdog
        sleep 10
    done &
fi

# Entrypoint logic
declare -A ENTRYPOINTS=(
    ["./start.sh"]="exec ./start.sh"
    ["./bithub-node"]="exec ./bithub-node start"
    ["index.js"]="exec node index.js"
    ["app.py"]="exec python3 app.py"
    ["Dockerfile"]="docker build -t bithub-node . && exec docker run -it bithub-node"
)

EP_FOUND=0
for EP in "${!ENTRYPOINTS[@]}"; do
    if [ -f "$EP" ]; then
        chmod +x "$EP" || true
        log "[Bit.Hub] Entrypoint: running $EP..."
        eval "${ENTRYPOINTS[$EP]}" || log "[WARN][NANOSWARM] Entrypoint $EP failed; continuing..."
        EP_FOUND=1
        break
    fi
done

# Placeholder if no entrypoint found
if [ $EP_FOUND -eq 0 ]; then
    if [ ! -f "./bithub-node" ]; then
        log "[Bit.Hub] Emergency: No node found --- atomizing placeholder."
        cat <<'POD' > bithub-node
#!/bin/bash
echo "[Bit.Hub] Placeholder node started (degraded mode)."
while true; do
    sleep 5
    echo "[Bit.Hub] Placeholder node heartbeat..."
done
POD
        chmod +x ./bithub-node
    fi
    log "[Bit.Hub] Running placeholder node indefinitely..."
    exec ./bithub-node || log "[WARN][NANOSWARM] Placeholder execution failed; retrying..."
fi

# Post-run cleanup (never fails)
rm -f "$SWARM_LOCK" 2>/dev/null || true
unset BITHUB_HAS_INIT
log "[Bit.Hub][NANOSWARM] Process complete, recursive error eternally defeated."

# Never exit with failure
exit 0
