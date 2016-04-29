#!/bin/sh

set -e

SENTINEL_CONFIGURATION_FILE=/etc/sentinel.conf

QUORUM=$QUORUM
: ${QUORUM:=2}

GROUP_NAME=$GROUP_NAME
: ${GROUP_NAME:=mymaster}

MASTER_PORT=$MASTER_PORT
: ${MASTER_PORT:=6379}

echo "port 26379" >> $SENTINEL_CONFIGURATION_FILE

if [ "$ANNOUNCE_IP" ]; then
    echo "sentinel announce-ip $ANNOUNCE_IP" >> $SENTINEL_CONFIGURATION_FILE
fi

if [ "$ANNOUNCE_PORT" ]; then
    echo "sentinel announce-port $ANNOUNCE_PORT" >> $SENTINEL_CONFIGURATION_FILE
fi

echo "sentinel monitor $GROUP_NAME $MASTER_IP $MASTER_PORT $QUORUM" >> $SENTINEL_CONFIGURATION_FILE

redis-server $SENTINEL_CONFIGURATION_FILE --sentinel