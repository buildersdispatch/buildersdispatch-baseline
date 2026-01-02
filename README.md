
# buildersdispatch-baseline
Clean, portable baseline for the live BuildersDISPATCH website.  Includes a minimal Next.js (App Router) splash page, nginx + PM2 verified runtime,  and a reproducible build intended for fresh-server migration and future development.
=======
# BuildersDISPATCH

BuildersDISPATCH is a modern platform for the construction industry.

## Current State

- Framework: Next.js (App Router)
- Runtime: Node.js
- Process Manager: PM2
- Reverse Proxy: nginx
- Environment: Ubuntu VPS
- Domain: buildersdispatch.com

## Repository Purpose

This repository contains **application source only**.

It intentionally excludes:
- node_modules
- secrets
- runtime configuration
- server-specific state

## Deployment Notes

Typical deployment flow:

1. Clone repository
2. Install dependencies
3. Build Next.js
4. Run with PM2 behind nginx

## Status

- Splash page live
- Crossmint integration paused pending support review
- Repository reset as of this baseline commit


