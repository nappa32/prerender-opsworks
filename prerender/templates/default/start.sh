#!/usr/bin/env bash
export RESOURCE_DOWNLOAD_TIMEOUT=1200
export JS_TIMEOUT=1200
export PORT=80
cd /root/prerender
npm install
node server.js
