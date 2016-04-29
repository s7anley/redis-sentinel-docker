#!/bin/sh

set -e

SENTINEL_CONFIGURATION_FILE=/etc/sentinel.conf

echo "port 26379" >> $SENTINEL_CONFIGURATION_FILE

redis-server $SENTINEL_CONFIGURATION_FILE --sentinel