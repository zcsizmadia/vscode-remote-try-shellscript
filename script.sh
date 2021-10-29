#!/bin/bash

# Exit script if any error occurs
set -e

VERSION="0.1.0"

# Default parameters
CONFIGURATION="Release"
TARGET_FRAMEWORK="net5.0"
TARGET_RUNTIME="linux-x64"

ENABLE_BUILD="true"
ENABLE_TEST="true"
ENABLE_PUBLISH="true"
ENABLE_FLAG="false"

# Colors
COLOR_RED="\033[0;31m"
COLOR_GREEN="\033[0;32m"
COLOR_YELLOW="\033[0;33m"
COLOR_NONE="\033[0m"

function usage()
{
    echo "Usage: $(basename "$0") [OPTION]..."
    echo "Sample script v$VERSION"
    echo ""
    echo "  -f, --framework FRAMEWORK             Framework"
    echo "  -r, --runtime RUNTIME                 Runtime"
    echo "  -c, --configuration CONFIGURATION     Configuration"
    echo "      --{enable|disable}-build          Enable/disable build"
    echo "      --{enable|disable}-test           Enable/disable test"
    echo "      --{enable|disable}-publish        Enable/disable publish"
    echo "      --{enable|disable}-flag           Enable/disable flag"
    echo "  -V, --version                         Version"
    echo "  -h, --help                            Shows help"
}

function cleanup()
{
    local RC="$?"

    trap "" INT TERM EXIT
    set +e

    # Cleanup here

    exit "$RC"
}

function log()
{
    echo -e "[$(date +"%Y-%m-%d %H:%M:%S.%N")] [$1] $2$COLOR_NONE"
}

function info()
{
    log "INF" "$1"
}

function ok()
{
    echo -en "$COLOR_GREEN"
    log "INF" "$1"
}

function warn()
{
    echo -en "$COLOR_YELLOW"
    log "WRN" "$1"
}

function error()
{
    echo -en "$COLOR_RED"
    log "ERR" "$1"
}

function fatal()
{
    error "$1"
    [ "$2" ] && exit "$2" || exit 1
}

function disable-colors()
{
    COLOR_RED=""
    COLOR_GREEN=""
    COLOR_YELLOW=""
    COLOR_NONE=""
}

# Cleanup function to be called if script exits normally, CTRL+C or TERM signal
trap "cleanup" EXIT TERM INT

# Turn off colors automatically if not terminal
#[ -t 1 ] || disable-colors

# Iterate through arguments
while [ $# -gt 0 ]
do
  case "$1" in
    -f|--framework)
        TARGET_FRAMEWORK="$2"
        shift
        ;;

    -r|--runtime)
        TARGET_RUNTIME="$2"
        shift
        ;;

    -c|--configuration)
        CONFIGURATION="$2"
        shift
        ;;

    --disable-build)
        ENABLE_BUILD="false"
        ;;

    --enable-build)
        ENABLE_BUILD="true"
        ;;

    --disable-test)
        ENABLE_TEST="false"
        ;;

    --enable-test)
        ENABLE_TEST="true"
        ;;

    --disable-publish)
        ENABLE_PUBLISH="false"
        ;;

    --enable-publish)
        ENABLE_PUBLISH="true"
        ;;

    --disable-flag)
        ENABLE_FLAG="false"
        ;;

    --enable-flag)
        ENABLE_FLAG="true"
        ;;

    --no-colors)
        disable-colors
        ;;

    -V|--version)
        echo "$VERSION"
        exit 0
        ;;

    -h|--help)
        usage
        exit 0
        ;;

    *)
        fatal "Unknown argument - $1"
        ;;
    esac

    shift
done

#
# Start
#

START_TIME="$SECONDS"

info "Started script v$VERSION ..."

"$ENABLE_FLAG" && info "Flag is enabled"

warn "Simulate a warning!"

#
# Build
#
if "$ENABLE_BUILD"
then
    info "Building: config=$CONFIGURATION, framework=$TARGET_FRAMEWORK, runtime=$TARGET_RUNTIME  ..."
fi

#
# Test
#
if "$ENABLE_TEST"
then
    info "Testing: config=$CONFIGURATION, framework=$TARGET_FRAMEWORK, runtime=$TARGET_RUNTIME  ..."
fi

#
# Long time out
#
info "Waiting ..."
sleep 2s
error "Operation timed out (simulated)!"

#
# Publish
#
if "$ENABLE_PUBLISH"
then
    info "Publishing: config=$CONFIGURATION, framework=$TARGET_FRAMEWORK, runtime=$TARGET_RUNTIME  ..."
fi

ok "Done in $((SECONDS - START_TIME))s."
