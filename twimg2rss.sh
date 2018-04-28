#!/bin/bash
set -euo pipefail
docker run --rm -d -v "${HOME}:/home/${LOGNAME}" kiyoad/twimg2rss "$@"
