#!/bin/bash
# Daily Naukri CV refresh. Called by Windows Task Scheduler via wsl.exe.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$HOME" || exit 1

# Credentials live in ~/.naukri_env (chmod 600), never in the repo:
#   export NAUKRI_EMAIL="you@example.com"
#   export NAUKRI_PASS="your-password"
if [ ! -f "$HOME/.naukri_env" ]; then
    echo "$(date) ERROR: ~/.naukri_env missing" >> "$HOME/naukri.log"
    exit 1
fi
source "$HOME/.naukri_env"

# Use the WSLg display so the (visible) Chrome window can open
export DISPLAY="${DISPLAY:-:0}"
export WAYLAND_DISPLAY="${WAYLAND_DISPLAY:-wayland-0}"
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/mnt/wslg/runtime-dir}"

echo "=== $(date) ===" >> "$HOME/naukri.log"
"$HOME/venv/bin/python" "$SCRIPT_DIR/naukri_upload.py" >> "$HOME/naukri.log" 2>&1
echo "exit code: $?" >> "$HOME/naukri.log"
