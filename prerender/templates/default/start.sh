#!/usr/bin/env bash

export RESOURCE_DOWNLOAD_TIMEOUT=1200
export JS_TIMEOUT=1200
export PORT=80
export lockfile="prerender.lock"
if [ ! -e $lockfile ]; then
   trap "rm -f $lockfile; exit" INT TERM EXIT
   touch $lockfile
   killall  node phantomjs
   cd /root/prerender
   source env.sh
   npm install
   node server.js
   
   rm -f $lockfile
   trap - INT TERM EXIT
else
   echo "prerender is already running.... :("
fi

