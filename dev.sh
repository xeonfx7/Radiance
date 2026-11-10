#!/usr/bin/env bash

set -euo pipefail

# Run from the theme root even when this script is invoked by its full path.
cd "$(dirname "$0")"

exec shopify theme dev "$@"
