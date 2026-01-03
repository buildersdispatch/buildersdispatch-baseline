#!/usr/bin/env bash
set -euo pipefail

cd /root/next-test

echo "=== Verifying repo state ==="
git status

echo "=== Staging canonical Hosted Checkout files ==="
git add app/crossmint-test
git add -u app/api

echo "=== Status after staging ==="
git status

echo "=== Creating milestone commit ==="
git commit -m "feat: canonical Crossmint Hosted Checkout baseline (staging)"

echo "=== Pushing to origin ==="
git push origin main

echo "=== Tagging milestone ==="
git tag crossmint-hosted-checkout-staging
git push origin crossmint-hosted-checkout-staging

echo "=== DONE: Crossmint Hosted Checkout baseline committed and tagged ==="
