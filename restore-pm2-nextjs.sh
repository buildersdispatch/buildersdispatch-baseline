#!/usr/bin/env bash
set -euo pipefail

echo "=== BuildersDISPATCH PM2 + Next.js Restore Script ==="

# --- CONFIG ---
APP_DIR="/root/next-test"
PM2_APP_NAME="buildersdispatch-next"
USER_HOME="/root"

# --- SAFETY CHECKS ---
if [[ "$EUID" -ne 0 ]]; then
  echo "ERROR: Must run as root"
  exit 1
fi

if [[ ! -d "$APP_DIR" ]]; then
  echo "ERROR: App directory not found: $APP_DIR"
  exit 1
fi

command -v pm2 >/dev/null || { echo "ERROR: pm2 not installed"; exit 1; }
command -v npm >/dev/null || { echo "ERROR: npm not installed"; exit 1; }

echo "✔ Preconditions satisfied"

# --- ENSURE PM2 SYSTEMD BINDING ---
echo "=== Ensuring PM2 systemd startup binding ==="
pm2 startup systemd -u root --hp "$USER_HOME"

# --- CLEAN SLATE (PM2 ONLY) ---
echo "=== Clearing existing PM2 state ==="
pm2 delete all || true

# --- BUILD NEXT.JS ---
echo "=== Building Next.js ==="
cd "$APP_DIR"
npm run build

# --- START NEXT.JS UNDER PM2 ---
echo "=== Starting Next.js under PM2 ==="
pm2 start npm --name "$PM2_APP_NAME" -- start

# --- VERIFY RUNNING ---
echo "=== Verifying PM2 process ==="
pm2 status | grep "$PM2_APP_NAME" || {
  echo "ERROR: PM2 process not running"
  exit 1
}

# --- PERSIST STATE ---
echo "=== Saving PM2 state ==="
pm2 save

# --- VERIFY DUMP ---
if [[ ! -s "$USER_HOME/.pm2/dump.pm2" ]]; then
  echo "ERROR: PM2 dump.pm2 missing or empty"
  exit 1
fi

echo "✔ PM2 dump verified"

# --- FINAL STATUS ---
echo "=== Final PM2 Status ==="
pm2 status

echo ""
echo "=== SCRIPT COMPLETE ==="
echo "Next step: REBOOT the server and run:"
echo "  pm2 status"
echo ""
echo "If process survives reboot, PM2 persistence is restored."
